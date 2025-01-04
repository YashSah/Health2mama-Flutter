import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health2mama/Utils/connectivity_service.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:developer' as developer;
import '../../Utils/api_constant.dart';
part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerInitial()) {

    // View Profile Get API
    on<LoadUserProfile>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(UserProfileLoading());

        final requestUrl = Uri.parse(APIEndPoints.viewProfile).toString();
        developer.log("Request URL: $requestUrl");  // Log the request URL

        try {
          final response = await http.get(
            Uri.parse(APIEndPoints.viewProfile),
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken()
            },
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);
            final successResponse = data['result'];
            emit(UserProfileLoaded(successResponse));
            print("Response Data: $successResponse");
          } else {
            final errorData = jsonDecode(response.body);
            emit(UserProfileError({'message': 'Failed to load user profile: ${errorData['message']}'}));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(CommonServerFailure('An error occurred: $e'));
            developer.log("Exception: $e");
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Change Password Post API
    on<ChangePasswordRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ChangePasswordLoading());
        try {
          final requestData = json.encode({
            "currentPassword": event.currentPassword,
            "newPassword": event.newPassword,
          });

          developer.log("Request URL: ${Uri.parse(APIEndPoints.changePassword)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.changePassword),
            headers: {
              'Content-Type': 'application/json',
              'token':PrefUtils.getUserLoginToken()
            },
            body: requestData,
          );
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            // Access the token from the responseData map
            emit(ChangePasswordLoaded(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(ChangePasswordError(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(CommonServerFailure(e.toString()));
            developer.log("Exception: $e");
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });


    // Update User Profile PUT API
    on<UpdateUserProfileRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(UpdateProfileLoading());
        try {
          // Prepare the request payload with proper types
          final Map<String, dynamic> requestData = {};

          if (event.coreProgramOpted?.isNotEmpty ?? false) {
            // If coreProgramOpted is not null and not empty, use it
            requestData["coreProgramOpted"] = event.coreProgramOpted;
          } else {
            // If coreProgramOpted is null or empty, use the default value
            requestData["coreProgramOpted"] = "NOTATTEMPTED";
          }

          if (event.fullName?.isNotEmpty ?? false) {
            requestData["fullName"] = event.fullName;
          }

          if (event.email?.isNotEmpty ?? false) {
            requestData["email"] = event.email;
          }

          if (event.profilePicture?.isNotEmpty ?? false) {
            requestData["profilePicture"] = event.profilePicture;
          }

          if (event.country?.isNotEmpty ?? false) {
            requestData["country"] = event.country;
          }

          if (event.countryCode?.isNotEmpty ?? false) {
            requestData["countryCode"] = event.countryCode;
          }


          if (event.phoneNumber?.isNotEmpty ?? false) {
            requestData["phoneNumber"] = event.phoneNumber;
          }

          if (event.otherWork?.isNotEmpty ?? false) {
            requestData["otherWork"] = event.otherWork;
          }

          if (event.languages?.isNotEmpty ?? false) {
            requestData["languages"] = event.languages;
          }

          if (event.exercise?.isNotEmpty ?? false) {
            requestData["exercise"] = event.exercise;
          }

          if (event.others?.isNotEmpty ?? false) {
            requestData["others"] = event.others;
          }

          if (event.age?.isNotEmpty ?? false) {
            requestData["age"] = event.age;
          }

          if(event.stage?.isNotEmpty ?? false) {
            requestData["stage"] = event.stage;
          }

          if (event.kids?.isNotEmpty ?? false) {
            requestData["kids"] = event.kids;
          }


          final token = PrefUtils.getUserLoginToken(); // Replace with your method to get the token

          developer.log("Request URL: ${Uri.parse(APIEndPoints.updateProfile)}");
          developer.log("Request Data: $requestData");

          var response = await http.put(
            Uri.parse(APIEndPoints.updateProfile),
            headers: {
              'Content-Type': 'application/json',
              'accept': 'application/json',
              'token': token
            },
            body: jsonEncode(requestData), // Convert the map to JSON string
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(UpdateProfileLoaded(responseData));
            developer.log("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(UpdateProfileError(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(CommonServerFailure(e.toString()));
            developer.log("Exception: $e");
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });




    // Get Options GET API

    on<GetOptionsEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(OptionsDataLoading());

        final requestUrl = Uri.parse(APIEndPoints.getOptions).toString();
        developer.log("Request URL: $requestUrl");  // Log the request URL

        try {
          final response = await http.get(
            Uri.parse(APIEndPoints.getOptions),
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken()
            },
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);
            final Map<String, List<String>> successResponse = Map<String, List<String>>.from(
                data['result'].map((key, value) => MapEntry(key, List<String>.from(value)))
            );
            emit(OptionsDataLoaded(successResponse));
            developer.log("Response Data: $successResponse");
          } else {
            final errorData = jsonDecode(response.body);
            emit(OptionsDataError(errorData['responseMessage'] ?? 'Unknown error occurred'));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(CommonServerFailure('An error occurred: $e'));
            developer.log("Exception: $e");
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });


  }
}

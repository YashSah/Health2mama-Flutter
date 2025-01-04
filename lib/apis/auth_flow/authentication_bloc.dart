import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/connectivity_service.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:meta/meta.dart';
import 'authentication_event.dart';
import 'package:http/http.dart' as http;
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(SignupLoadingState()) {
    // User Sign up API

    on<SignupRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SignupLoadingState());
        try {
          final requestData = json.encode({
            "fullName": event.fullName,
            "country": event.country,
            "countryCode": event.countryCode,
            "phoneNumber": event.phoneNumber,
            "email": event.email,
            "password": event.password,
            "deviceToken": event.deviceToken,
            "deviceType": event.deviceType
          });

          developer.log("Request URL: ${Uri.parse(APIEndPoints.signUp)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.signUp),
            headers: {'Content-Type': 'application/json'},
            body: requestData,
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final token = responseData['result']['token'];
            PrefUtils.setUserLoginToken(token);
            print("User Signup Token Is : ${PrefUtils.getUserLoginToken()}");
            emit(SignupSuccess(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(SignupFailure(errorData));
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

// Get All Countries API

    on<GetAllCountriesEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SignInLoadingState());
        try {
          final response = await http.get(
            Uri.parse(APIEndPoints.getAllCountries),
            headers: {
              'accept': 'application/json',
            },
          );
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(GetAllCountriesSuccess(responseData));
          } else {
            emit(CommonServerFailure(jsonDecode(response.body)));
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          if (kDebugMode) {
            print(e);
          }
        }
      } else {
        emit(CheckNetworkConnection());
      }
    });

    // User Login Post API
    on<SignInRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SignInLoadingState());
        try {
          final requestData = json.encode({
            "email": event.email,
            "password": event.password,
            "deviceToken": event.deviceToken,
            "deviceType": event.deviceType
          });

          developer.log("Request URL: ${Uri.parse(APIEndPoints.userLogin)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.userLogin),
            headers: {'Content-Type': 'application/json'},
            body: requestData,
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);

            // Log raw response data
            developer.log("Raw Response Data: $responseData");

            if (responseData.containsKey('result') &&
                responseData['result'] != null) {
              final result = responseData['result'];
              print(result);
              emit(SignInSuccess(responseData));
            } else {
              emit(SignInFailure({'error': 'Unexpected response structure'}));
              developer.log("Unexpected response structure: $responseData");
            }
          } else {
            final errorData = jsonDecode(response.body);
            emit(SignInFailure(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(CommonServerFailure(e.toString()));
            developer.log("Exception occurred: $e", name: 'SignInRequested');
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Add Location

    on<LocationRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(LocationLoading());
        try {
          final requestData =
              'longitude=${event.longitude}&latitude=${event.latitude}';

          final headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'token':
                event.token, // Use 'token' header instead of 'Authorization'
          };

          developer
              .log("Request URL: ${Uri.parse(APIEndPoints.updateLocation)}");
          developer.log("Request Headers: $headers");
          developer.log("Request Data: $requestData");

          var response = await http.put(
            Uri.parse(APIEndPoints.updateLocation),
            headers: headers,
            body: requestData,
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(LocationLoaded(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(LocationError(errorData));
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

    // Reset Password API

    on<ResetPasswordRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ResetLoading());
        try {
          // Construct the request body as JSON
          final requestData = jsonEncode({
            "email": event.email,
            "newPassword": event.newPassword,
          });

          developer
              .log("Request URL: ${Uri.parse(APIEndPoints.resetPassword)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.resetPassword),
            headers: {
              "Content-Type": "application/json",
            },
            body: requestData,
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(ResetSuccess(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(ResetFailure(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Send OTP API

    on<SendOTPRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SendOTPLoading());
        try {
          // Construct the request body as JSON
          final requestData = jsonEncode({
            "email": event.email,
          });

          developer.log("Request URL: ${Uri.parse(APIEndPoints.resendOtp)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.resendOtp), // Update endpoint
            headers: {
              'Content-Type': 'application/json', // Set Content-Type header
            },
            body: requestData, // Request body
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(SendOTPSuccess(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(SendOTPFailure(errorData));
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

// Verify OTP API

    on<VerifyOTPRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(VerifyOTPLoading());
        try {
          // Construct the request body as JSON
          final requestData =
              jsonEncode({"email": event.email, "otp": event.otp});

          developer.log("Request URL: ${Uri.parse(APIEndPoints.verifyOtp)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.verifyOtp), // Update endpoint
            headers: {
              'Content-Type': 'application/json', // Set Content-Type header
            },
            body: requestData, // Request body
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(VerifyOTPSuccess(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(VerifyOTPFailure(errorData));
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

    on<SelectStageRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SelectStageLoading());

        final String url =
            '${APIEndPoints.getCategoryByStage}?stage=${event.stage}';
        try {
          final response = await http.get(Uri.parse(url), headers: {
            'accept': 'application/json',
            'token': PrefUtils.getUserLoginToken(),
          });

          developer.log("Request URL: $url");
          print("Response Body: ${response.body}");

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);
            final List<dynamic> categories = data['result'] ?? [];

            emit(SelectStageSuccess({'result': categories}));
          } else {
            final errorData = jsonDecode(response.body);
            emit(SelectStageFailure({'error': errorData['responseMessage']}));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(SelectStageFailure({'error': e.toString()}));
            developer.log("Exception: $e");
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    on<GlobalSearchEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(GlobalSearchLoading());

        // Base URL
        final String baseUrl = '${APIEndPoints.globalSearch}';

        // Construct URL with query parameters
        final String url =
            '$baseUrl?search=${event.search}&page=${event.page}&limit=${event.limit}';

        try {
          final response = await http.get(Uri.parse(url), headers: {
            'accept': 'application/json',
            'token': PrefUtils.getUserLoginToken(),
          });

          developer.log("Request URL: $url");
          print("Response Body: ${response.body}");
          print(url);
          if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);

            // Parse programs, topics, and workout subcategories from response
            final programs = data['result']?['programs'] ?? {};
            final topics = data['result']?['topics'] ?? {};
            final workoutSubCategories =
                data['result']?['workoutSubCategories'] ?? {};
            final recipes =
                data['result']?['recipes'] ?? {};

            emit(GlobalSearchSuccess({
              'programs': programs,
              'topics': topics,
              'workoutSubCategories': workoutSubCategories,
              'recipes' : recipes
            }));
          } else {
            final errorData = jsonDecode(response.body);
            emit(GlobalSearchFailure({'error': errorData['responseMessage']}));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(GlobalSearchFailure({'error': e.toString()}));
            developer.log("Exception: $e");
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Update Preference POST API
    on<UpdatePreferenceRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(
            UpdatePreferenceLoading()); // Use Loading state to indicate process start

        try {
          final requestData = json.encode({
            "stage": event.stage,
            "categoryIds": event.categoryIds,
          });

          developer.log("Request URL: ${APIEndPoints.updatePreference}");
          developer.log("Request Data: $requestData");

          final response = await http.post(
            Uri.parse(APIEndPoints.updatePreference),
            headers: {
              'Content-Type': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Add token if required
            },
            body: requestData,
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            // Save the category IDs to PrefUtils
            await PrefUtils.setCategoryIds(event.categoryIds);

            // Await the Future to get the actual list of category IDs
            final storedCategoryIds = await PrefUtils.getCategoryIds();

            // Format the list with quotes for display
            final formattedCategoryIds = jsonEncode(storedCategoryIds);

            print('Selected Categories Ids Are : $formattedCategoryIds');

            emit(UpdatePreferenceSuccess(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(UpdatePreferenceFailure(errorData));
            print("Error Response: $errorData");
          }
        } catch (e) {
          if (kDebugMode) {
            emit(CommonServerFailure(e.toString()));
            developer.log("Exception: $e");
          } else {
            // Handle non-debug mode exceptions if necessary
            emit(CommonServerFailure("An unexpected error occurred."));
          }
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });
  }
}

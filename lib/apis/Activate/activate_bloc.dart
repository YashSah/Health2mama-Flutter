import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:health2mama/apis/Activate/activate_event.dart';
import 'package:health2mama/apis/Activate/activate_state.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../../Utils/api_constant.dart';
import '../../Utils/connectivity_service.dart';
import '../../Utils/pref_utils.dart';

class ActivateBloc extends Bloc<LearnHowToActivateEvent, LearnHowToActivateState> {
  ActivateBloc() : super(LearnHowToActivateInitial()) {

    // Learn How To Get Activate Get API
    on<FetchLearnHowToActivate>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(LearnHowToActivateLoading());
        try {
          final url = Uri.parse(APIEndPoints.listActivateExercise);
          developer.log("Request URL: $url");
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Replace with your actual token
            },
          );
          // Print the response data
          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(LearnHowToActivateLoaded(responseData));
          } else {
            final errorData = jsonDecode(response.body);
            emit(LearnHowToActivateError(errorData));
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

    // Set Reminder Post API
    on<SetReminderRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SetReminderLoading());
        try {
          final url = Uri.parse(APIEndPoints.createSetReminder);

          // Create the request data
          final requestData = jsonEncode({
            'userId': event.userId,
            'time': event.time,
            'reminderId': event.reminderId,
          });

          developer.log("Request URL: $url");
          developer.log("Request Data: $requestData");

          final response = await http.post(
            url,
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
            body: requestData,
          );

          developer.log("Response Status Code: ${response.statusCode}");
          developer.log("Response Headers: ${response.headers}");
          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final result = responseData['result'];

            emit(SetReminderSuccess(result));
          } else {
            // Handle HTML response
            if (response.headers['content-type']?.contains('text/html') ?? false) {
              emit(SetReminderFailure({
                'responseMessage': 'Received HTML response. Check API endpoint.',
              }));
              return;
            }

            final errorData = jsonDecode(response.body);
            emit(SetReminderFailure({
              'responseMessage': errorData['responseMessage'],
            }));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(SetReminderFailure({
            'responseMessage': 'An error occurred: $e',
          }));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Get Reminder Post API
    on<getReminderRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(getReminderLoading());
        try {
          final url = Uri.parse(APIEndPoints.getReminder);
          developer.log("Request URL: $url");
          final response = await http.get(
            url,
            headers: {
              'token': PrefUtils.getUserLoginToken(), // Replace with your actual token
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final List<dynamic> reminders = responseData['result']; // Access the result list
            final String responseMessage = responseData['responseMessage'];
            final int responseCode = responseData['responseCode'];

            // Emit the success state with the relevant data
            emit(getReminderSuccess(
              reminders: reminders,
              responseMessage: responseMessage,
              responseCode: responseCode,
            ));
          } else {
            final errorData = jsonDecode(response.body);
            emit(getReminderFailure(errorData));
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

    // DeleteExerciseRecord
    on<DeleteReminderRequested>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(DeleteReminderLoading());
        try {
          // Convert reminderId to String if it's an int
          final url = Uri.parse('${APIEndPoints.deleteReminder}?reminderId=${event.reminderId?.toString() ?? ''}');

          developer.log("Request URL: $url");

          final response = await http.delete(
            url,
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          developer.log("Response Status Code: ${response.statusCode}");
          developer.log("Response Headers: ${response.headers}");
          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final result = responseData['result'];

            emit(DeleteReminderSuccess(result, event.index)); // Ensure this is an int
          } else {
            if (response.headers['content-type']?.contains('text/html') ?? false) {
              emit(DeleteReminderFailure({
                'responseMessage': 'Received HTML response. Check API endpoint.',
              }));
              return;
            }

            final errorData = jsonDecode(response.body);
            emit(DeleteReminderFailure({
              'responseMessage': errorData['responseMessage'],
            }));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(DeleteReminderFailure({
            'responseMessage': 'An error occurred: $e',
          }));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // PostExerciseRecord
    on<PostExerciseRecord>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ExerciseRecordLoading());
        try {
          final url = Uri.parse(APIEndPoints.exerciseRecord);

          final requestData = jsonEncode({
            'stage': event.stage,
            'completed': event.completed,
            'points': event.points,
          });

          developer.log("Request URL: $url");
          developer.log("Request Data: $requestData");

          final response = await http.post(
            url,
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Replace with your actual token method
            },
            body: requestData,
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(ExerciseRecordSuccess(responseData));
          } else {
            final errorData = jsonDecode(response.body);
            emit(ExerciseRecordFailure(errorData['responseMessage']));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(ExerciseRecordFailure("An error occurred: $e"));
          developer.log("Exception: $e");
        }
      } else {
        emit(ExerciseRecordFailure("No internet connection."));
        developer.log("No internet connection.");
      }
    });

    // AddPoints to User Wallet
    on<AddPointsToUserWallet>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(AddPointsToUserLoading());
        try {
          final url = Uri.parse(APIEndPoints.addPointsToUserWallet);
          final requestData = jsonEncode({
            'points': event.points,
          });

          developer.log("Request URL: $url");
          developer.log("Request Data: $requestData");

          final response = await http.post(
            url,
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Replace with your actual token method
            },
            body: requestData,
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(AddPointsToUserSuccess(responseData));
          } else {
            final errorData = jsonDecode(response.body);
            emit(AddPointsToUserFailure(errorData['responseMessage']));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(AddPointsToUserFailure("An error occurred: $e"));
          developer.log("Exception: $e");
        }
      } else {
        emit(AddPointsToUserFailure("No internet connection."));
        developer.log("No internet connection.");
      }
    });

    // Get Exercise Record
    on<getExerciseRecord>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(GetExerciseRecordLoading());
        try {
          final url = Uri.parse(APIEndPoints.getExerciseRecord);
          developer.log("Request URL: $url");
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Replace with your actual token
            },
          );
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            List<dynamic> result = responseData['result'];
            developer.log("Response Data: ${result}");
            int totalPoints = result.fold(0, (sum, record) => sum + int.parse(record['points']));
            emit(GetExerciseRecordLoaded(result,totalPoints));
          } else {
            final errorData = jsonDecode(response.body);
            emit(GetExerciseRecordError(errorData));
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

  }
}

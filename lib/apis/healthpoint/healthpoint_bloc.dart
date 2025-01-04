import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../../Utils/api_constant.dart';
import '../../Utils/connectivity_service.dart';
import '../../Utils/pref_utils.dart';
import '../drawer/drawer_bloc.dart';

part 'healthpoint_event.dart';
part 'healthpoint_state.dart';

class HealthpointBloc extends Bloc<HealthpointEvent, HealthpointState> {
  HealthpointBloc() : super(HealthpointInitial()) {

    // Get Weekly Points GET API
    on<FetchWeeklyPoints>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(WeeklyPointsLoading());

        final requestUrl = Uri.parse(APIEndPoints.getWeeklyPoints);
        developer.log("Request URL: $requestUrl");

        try {
          final response = await http.get(
            requestUrl,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(WeeklyPointsLoaded(responseData));
          } else {
            final errorData = jsonDecode(response.body);
            emit(WeeklyPointsError({
              'message': 'Failed to load weekly points: ${errorData['message']}',
            }));
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

    // Get Weekly Goal GET API
    on<FetchWeeklyGoalEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(WeeklyGoalLoading());

        final requestUrl = Uri.parse(APIEndPoints.getWeeklyGoal);
        developer.log("Request URL: $requestUrl");

        try {
          final response = await http.get(
            requestUrl,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(WeeklyGoalLoaded(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(WeeklyGoalError(errorData));
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

    // Create Weekly Goal POST API
    on<CreateWeeklyGoalEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(CreateWeeklyGoalLoading());

        final requestUrl = Uri.parse(APIEndPoints.createWeeklyGoal);
        developer.log("Request URL: $requestUrl");

        try {
          final response = await http.post(
            requestUrl,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'weeklyGoal': event.weeklyGoal}),
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(CreateWeeklyGoalLoaded(responseData));
            print("Response Data: $responseData");
          } else {
            final errorData = jsonDecode(response.body);
            emit(CreateWeeklyGoalError(errorData));
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

  int getWeekNumber(DateTime date) {
    final year = date.year;
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstDayOfYearDay = firstDayOfYear.weekday;

    if (firstDayOfYearDay == DateTime.sunday) {
      if (date.isBefore(DateTime(year, 1, 2))) {
        return 1;
      } else {
        final daysSinceJan2 = date.difference(DateTime(year, 1, 2)).inDays;
        return ((daysSinceJan2 + 1) / 7).ceil() + 1;
      }
    }

    final nearestMonday = date.subtract(Duration(days: (date.weekday + 6) % 7));
    final daysDifference = nearestMonday.difference(firstDayOfYear).inDays;
    final weekNumber = (daysDifference + (firstDayOfYearDay == DateTime.sunday ? 1 : 0)) ~/ 7 + 1;

    return weekNumber;
  }
}

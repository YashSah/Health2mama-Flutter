import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/connectivity_service.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../APIs/auth_flow/authentication_bloc.dart';

part 'pregnancy_event.dart';
part 'pregnancy_state.dart';

class PregnancyBloc extends Bloc<PregnancyEvent, PregnancyState> {
  PregnancyBloc() : super(PregnancyInitial()) {
    on<FetchTrimesterData>(_onFetchTrimesterData);
    on<FetchWeekByTrimester>(_onFetchWeekByTrimester);
    on<DueDateCalculator>(_onDueDateCalculator);
    on<ViewWeekByTrimester>(_onViewWeekByTrimester);
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onFetchTrimesterData(
      FetchTrimesterData event,
      Emitter<PregnancyState> emit,
      ) async {
    emit(PregnancyLoading());

    final String url = APIEndPoints.getTrimester;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'token': PrefUtils.getUserLoginToken(),
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> trimesters = data['result'];

        final List<String> trimesterIds = trimesters.map((trimester) => trimester['_id'].toString()).toList();

        // Initialize the trimesterWeeks map
        final Map<String, List<dynamic>> trimesterWeeks = {};

        // Emit the loaded state with trimesters and empty weeks data
        emit(PregnancyLoaded(trimesters: trimesters, trimesterWeeks: trimesterWeeks));

        for (String id in trimesterIds) {
          add(FetchWeekByTrimester(trimesterId: id));
        }
      } else {
        emit(PregnancyError(error: 'Failed to load trimester data'));
      }
    } catch (error) {
      emit(PregnancyError(error: error.toString()));
    }
  }

  Future<void> _onFetchWeekByTrimester(
      FetchWeekByTrimester event,
      Emitter<PregnancyState> emit,
      ) async {
    emit(PregnancyLoading());

    final String url = '${APIEndPoints.listWeekByTrimester}?trimesterId=${event.trimesterId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'token': PrefUtils.getUserLoginToken(),
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> weeks = data['result'];

        // Emit WeekByTrimesterLoaded state with specific trimester ID
        emit(WeekByTrimesterLoaded(trimesterId: event.trimesterId, weeks: weeks));
      } else {
        emit(PregnancyError(error: 'Failed to load weeks by trimester data'));
      }
    } catch (error) {
      emit(PregnancyError(error: error.toString()));
    }
  }

  Future<void> _onDueDateCalculator(
      DueDateCalculator event,
      Emitter<PregnancyState> emit,
      ) async {
    if (await ConnectivityService.isConnected()) {
      emit(DueDateLoading());

      try {
        String dueDate = event.dueDate; // Assuming event.dueDate is already in "YYYY-MM-DD" format

        Map<String, dynamic> reqData = {
          'dueDate': dueDate,
        };
        final url = Uri.parse(APIEndPoints.updateDueDate);

        final response = await http.post(
          url,
          headers: {
            'token': PrefUtils.getUserLoginToken(),
            'Content-Type': 'application/json', // Ensure the content type is set to JSON
          },
          body: jsonEncode(reqData),
        );

        if (response.statusCode == 200) {
          emit(DueDateSuccess());
        } else {
          final errorData = jsonDecode(response.body);
          emit(DueDateFailure(errorData['responseMessage'] ?? 'Unknown error occurred'));
        }
      } catch (e) {
        emit(DueDateFailure(e.toString()));
      }
    } else {
      emit(DueDateFailure('No internet connection'));
    }
  }

  Future<void> _onViewWeekByTrimester(
      ViewWeekByTrimester event,
      Emitter<PregnancyState> emit,
      ) async {
    emit(ViewWeekLoading());

    final String url = '${APIEndPoints.viewWeek}?weekNumber=${event.weekNumber}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'token': PrefUtils.getUserLoginToken(),
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> weekData = data['result'];

        emit(ViewWeekLoaded(weekData));
      } else {
        emit(ViewWeekError(error: 'Failed to load weeks by trimester data'));
      }
    } catch (error) {
      emit(ViewWeekError(error: error.toString()));
    }
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event,
      Emitter<PregnancyState> emit,
      ) async {
    if (await ConnectivityService.isConnected()) {
      emit(UserProfileLoading());

      try {
        final response = await http.get(
          Uri.parse(APIEndPoints.viewProfile),
          headers: {
            'accept': 'application/json',
            'token': PrefUtils.getUserLoginToken(),
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          final successResponse = data['result'];
          emit(UserProfileLoaded(successResponse));
        } else {
          final errorData = jsonDecode(response.body);
          print('Error response: ${errorData['message']}');
          emit(UserProfileError('Failed to load user profile: ${errorData['message']}' as Map<String, dynamic>));
        }
      } catch (e) {
        print('Exception: $e');
        emit(CommonServerFailure('An error occurred: $e') as PregnancyState);
      }
    } else {
      emit(CheckNetworkConnection() as PregnancyState);
    }
  }

}


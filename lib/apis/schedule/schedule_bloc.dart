import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/connectivity_service.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:intl/intl.dart';  // Import the intl package
import '../../APIs/program_flow/programflow_state.dart';
part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleBooking>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ScheduleflowLoading());

        try {
          final url = Uri.parse(APIEndPoints.listBookingById);
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final List<dynamic> result = responseData['result'] ?? [];

            // Define the date format to parse
            final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
            final DateTime now = DateTime.now();
            final DateTime todayStart = DateTime(now.year, now.month, now.day); // Start of today
            final DateTime todayEnd = todayStart.add(Duration(days: 1)); // End of today (start of tomorrow)

            // Filter the results to include only today's and upcoming appointments
            final List<dynamic> filteredResult = result.where((appointment) {
              try {
                final DateTime appointmentDate = dateFormat.parse(appointment['date']);
                return appointmentDate.isAfter(todayStart.subtract(Duration(seconds: 1))) || appointmentDate.isAtSameMomentAs(todayStart);
              } catch (e) {
                // Handle the parsing error if needed
                return false;
              }
            }).toList();

            emit(ScheduleflowLoaded(filteredResult));
          } else {
            final errorData = jsonDecode(response.body);
            emit(ScheduleflowError(errorData['responseMessage'] ?? 'Unknown error occurred'));
          }
        } catch (e) {
          emit(ScheduleflowError(e.toString()));
        }
      } else {
        emit(CheckNetworkConnection() as ScheduleState);
      }
    });


    on<ScheduleCancelBooking>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ScheduleCancelLoading());

        try {
          Map<String, dynamic> reqData = {
            'bookingId': event.bookingId, // Booking ID in body
          };
          final url = Uri.parse(APIEndPoints.cancelBookingById); // Replace with your API endpoint
          final response = await http.post(
            url,
            headers: {
              'token': PrefUtils.getUserLoginToken(),
            },
            body: reqData,
          );

          if (response.statusCode == 200) {
            emit(ScheduleCancelSuccess());
          } else {
            final errorData = jsonDecode(response.body);
            emit(ScheduleCancelFailure(errorData['responseMessage'] ?? 'Unknown error occurred'));
          }
        } catch (e) {
          emit(ScheduleCancelFailure(e.toString()));
        }
      } else {
        emit(CheckNetworkConnection() as ScheduleState);
      }
    });
  }
}

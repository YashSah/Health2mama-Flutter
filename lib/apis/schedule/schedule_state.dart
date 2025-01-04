part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

// Fetch Schedule Booking
class ScheduleflowLoading extends ScheduleState {}

class ScheduleflowLoaded extends ScheduleState {
 List<dynamic> bookings;
  ScheduleflowLoaded(this.bookings);
}

class ScheduleflowError extends ScheduleState {
  final String errorMessage;
  ScheduleflowError(this.errorMessage);
}


// Fetch Schedule Cancel Booking

class ScheduleCancelLoading extends ScheduleState {}

class ScheduleCancelSuccess extends ScheduleState {}

class ScheduleCancelFailure extends ScheduleState {
  final String error;

  ScheduleCancelFailure(this.error);
}

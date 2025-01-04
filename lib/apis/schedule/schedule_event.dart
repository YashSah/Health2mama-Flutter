part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleEvent {}

class ScheduleBooking extends ScheduleEvent {
  ScheduleBooking();
}

class ScheduleCancelBooking extends ScheduleEvent {
  final String bookingId;

  ScheduleCancelBooking(this.bookingId);
}
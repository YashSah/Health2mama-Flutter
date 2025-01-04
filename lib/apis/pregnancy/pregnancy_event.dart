part of 'pregnancy_bloc.dart';

@immutable
sealed class PregnancyEvent {}

final class FetchTrimesterData extends PregnancyEvent {}


final class FetchWeekByTrimester extends PregnancyEvent {
  final String trimesterId;
  FetchWeekByTrimester({required this.trimesterId});
}

final class DueDateCalculator extends PregnancyEvent {
  final String dueDate;
  DueDateCalculator(this.dueDate);
}

final class ViewWeekByTrimester extends PregnancyEvent {
  final String weekNumber;
  ViewWeekByTrimester({required this.weekNumber});
}

class LoadUserProfile extends PregnancyEvent {}
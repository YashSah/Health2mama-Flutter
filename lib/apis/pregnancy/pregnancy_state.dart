part of 'pregnancy_bloc.dart';

@immutable
sealed class PregnancyState {}

final class PregnancyInitial extends PregnancyState {}

final class PregnancyLoading extends PregnancyState {}

class PregnancyLoaded extends PregnancyState {
  final List<dynamic> trimesters;
  final Map<String, List<dynamic>> trimesterWeeks; // Map of trimester ID to weeks data

  PregnancyLoaded({
    required this.trimesters,
    required this.trimesterWeeks,
  });
}

class WeekByTrimesterLoaded extends PregnancyState {
  final String trimesterId;
  final List<dynamic> weeks;

  WeekByTrimesterLoaded({
    required this.trimesterId,
    required this.weeks,
  });
}


final class PregnancyError extends PregnancyState {
  final String error;

  PregnancyError({required this.error});
}

class DueDateLoading extends PregnancyState {}

class DueDateSuccess extends PregnancyState {}

class DueDateFailure extends PregnancyState {
  final String error;

  DueDateFailure(this.error);
}


final class ViewWeekLoading extends PregnancyState {}

class ViewWeekLoaded extends PregnancyState {
  Map<String, dynamic> weekData; // Map of trimester ID to weeks data

  ViewWeekLoaded(this.weekData);
}

final class ViewWeekError extends PregnancyState {
  final String error;

  ViewWeekError({required this.error});
}

// Get User Profile API
class UserProfileLoading extends PregnancyState {}

class UserProfileLoaded extends PregnancyState {
  Map<String,dynamic> successResponse;
  UserProfileLoaded(this.successResponse);
}

class UserProfileError extends PregnancyState {
  Map<String,dynamic> failureResponse;
  UserProfileError(this.failureResponse);
}
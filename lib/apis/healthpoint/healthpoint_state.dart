part of 'healthpoint_bloc.dart';

@immutable
sealed class HealthpointState {}

final class HealthpointInitial extends HealthpointState {}


// Get Weekly Points GET API
class WeeklyPointsLoading extends HealthpointState {}

class WeeklyPointsLoaded extends HealthpointState {
  Map<String,dynamic> successResponse;
  WeeklyPointsLoaded(this.successResponse);
}

class WeeklyPointsError extends HealthpointState {
  Map<String, dynamic> failureResponse;
  WeeklyPointsError(this.failureResponse);
}

// Get Weekly Goal GET API
class WeeklyGoalLoading extends HealthpointState {}

class WeeklyGoalLoaded extends HealthpointState {
  Map<String,dynamic> successResponse;
  WeeklyGoalLoaded(this.successResponse);
}

class WeeklyGoalError extends HealthpointState {
  Map<String, dynamic> failureResponse;
  WeeklyGoalError(this.failureResponse);
}


// Create Weekly Goal POST API
class CreateWeeklyGoalLoading extends HealthpointState {}

class CreateWeeklyGoalLoaded extends HealthpointState{
  Map<String,dynamic> successResponse;
  CreateWeeklyGoalLoaded(this.successResponse);
}

class CreateWeeklyGoalError extends HealthpointState{
  Map<String,dynamic> failureResponse;
  CreateWeeklyGoalError(this.failureResponse);
}

class CommonServerFailure extends HealthpointState {
  final String error;
  CommonServerFailure(this.error);

}

class CheckNetworkConnection extends HealthpointState {
}
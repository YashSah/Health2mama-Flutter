part of 'healthpoint_bloc.dart';

@immutable
sealed class HealthpointEvent {}

// Fetch Weekly Points GET API
class FetchWeeklyPoints extends HealthpointEvent {}

// Fetch Weekly Goal GET API
class FetchWeeklyGoalEvent extends HealthpointEvent {}

// Create Weekly Goal POST API
class CreateWeeklyGoalEvent extends HealthpointEvent {
  final int weeklyGoal;
  CreateWeeklyGoalEvent(this.weeklyGoal);
}
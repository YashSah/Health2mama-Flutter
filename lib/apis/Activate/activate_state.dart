
// Define the states for the BLoC
abstract class LearnHowToActivateState {}

// Learn How To Activate Get API
class LearnHowToActivateInitial extends LearnHowToActivateState {}

class LearnHowToActivateLoading extends LearnHowToActivateState {}

class LearnHowToActivateLoaded extends LearnHowToActivateState {
 final Map<String,dynamic> successResponse;
  LearnHowToActivateLoaded(this.successResponse);
}

class LearnHowToActivateError extends LearnHowToActivateState {
  final Map<String,dynamic> failureResponse;
  LearnHowToActivateError(this.failureResponse);
}

// Set Reminder Post API
final class SetReminderLoading extends LearnHowToActivateState {}

final class SetReminderSuccess extends LearnHowToActivateState {
  final Map<String, dynamic> SuccessResponse;
  SetReminderSuccess(this.SuccessResponse);
}

final class SetReminderFailure extends LearnHowToActivateState {
  final Map<String, dynamic> FailureResponse;
  SetReminderFailure(this.FailureResponse);
}

// Loading state
final class getReminderLoading extends LearnHowToActivateState {}

// Success state
final class getReminderSuccess extends LearnHowToActivateState {
  final List<dynamic> reminders; // Changed to List<dynamic> to hold reminder items
  final String responseMessage; // To hold the response message
  final int responseCode; // To hold the response code

  getReminderSuccess({
    required this.reminders,
    required this.responseMessage,
    required this.responseCode,
  });
}

// Failure state
final class getReminderFailure extends LearnHowToActivateState {
  final Map<String, dynamic> failureResponse; // Maintain the same type for the failure response

  getReminderFailure(this.failureResponse);
}


class ExerciseRecordLoading extends LearnHowToActivateState {}

class ExerciseRecordSuccess extends LearnHowToActivateState {
  final Map<String, dynamic> response;

  ExerciseRecordSuccess(this.response);
}

class ExerciseRecordFailure extends LearnHowToActivateState {
  final String errorMessage;

  ExerciseRecordFailure(this.errorMessage);
}


class AddPointsToUserLoading extends LearnHowToActivateState {}

class AddPointsToUserSuccess extends LearnHowToActivateState {
  final Map<String, dynamic> response;

  AddPointsToUserSuccess(this.response);
}

class AddPointsToUserFailure extends LearnHowToActivateState {
  final String errorMessage;

  AddPointsToUserFailure(this.errorMessage);
}


class GetExerciseRecordLoading extends LearnHowToActivateState {}

class GetExerciseRecordLoaded extends LearnHowToActivateState {
  final List<dynamic> result;
  final int totalPoints;
  GetExerciseRecordLoaded(this.result,this.totalPoints);
}

class GetExerciseRecordError extends LearnHowToActivateState {
  final Map<String,dynamic> failureResponse;
  GetExerciseRecordError(this.failureResponse);
}


class CommonServerFailure extends LearnHowToActivateState {
  final String error;
  CommonServerFailure(this.error);

}

class CheckNetworkConnection extends LearnHowToActivateState {
}

// Delete Reminder Post API
final class DeleteReminderLoading extends LearnHowToActivateState {}

class DeleteReminderSuccess extends LearnHowToActivateState {
  final dynamic result;
  final int index; // Add index parameter

  DeleteReminderSuccess(this.result, this.index);
}

final class DeleteReminderFailure extends LearnHowToActivateState {
  final Map<String, dynamic> FailureResponse;
  DeleteReminderFailure(this.FailureResponse);
}
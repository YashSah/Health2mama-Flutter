// Define the events for the BLoC
abstract class LearnHowToActivateEvent {}

class FetchLearnHowToActivate extends LearnHowToActivateEvent {}

// Set Reminder Post API
class SetReminderRequested extends LearnHowToActivateEvent {
  final String userId;
  final String time;
  final String reminderId;

  SetReminderRequested({
    required this.userId,
    required this.time,
    required this.reminderId,
  });
}

class getReminderRequested extends LearnHowToActivateEvent {}

class PostExerciseRecord extends LearnHowToActivateEvent {
  final String stage;
  final int points;
  final bool completed;

  PostExerciseRecord({
    required this.stage,
    required this.points,
    required this.completed,
  });
}

class AddPointsToUserWallet extends LearnHowToActivateEvent {
  final int points;
  AddPointsToUserWallet({
    required this.points
  });
}

class getExerciseRecord extends LearnHowToActivateEvent {}

// Set Reminder Post API
class DeleteReminderRequested extends LearnHowToActivateEvent {
  final String reminderId;
  final int index; // Add index here

  DeleteReminderRequested({required this.reminderId, required this.index});
}
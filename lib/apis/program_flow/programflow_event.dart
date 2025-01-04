part of 'programflow_bloc.dart';

sealed class ProgramflowEvent {}

// Fetch Category By User Preference GET API
class FetchCategoriesEvent extends ProgramflowEvent {}

// FetchProgramByCategory GET API
class FetchProgramEvent extends ProgramflowEvent {
  final String categoryId;
  FetchProgramEvent(this.categoryId);
}

// Fetch Topic GET API
class FetchTopics extends ProgramflowEvent {
  final String programId;
  FetchTopics(this.programId);
}

// View Topic GET API
class ViewTopic extends ProgramflowEvent {
  final String topicId;
  ViewTopic(this.topicId);
}

// Save Unsave POST API
class SaveUnsaveItemEvent extends ProgramflowEvent {
  final String itemName;
  final String itemId;
  final String categoryId; // Expect a JSON string
  final String isCompleted;
  final String isSaved;

  SaveUnsaveItemEvent({
    required this.itemName,
    required this.itemId,
    required this.categoryId, // This should be a JSON string
    this.isCompleted = 'false',
    this.isSaved = 'false',
  });

  Map<String, dynamic> toJson() => {
        'itemName': itemName,
        'itemId': itemId,
        'categoryId': categoryId, // JSON string
        'isCompleted': isCompleted,
        'isSaved': isSaved,
      };
}

// Fetch Save Unsave Status GET API
class FetchSaveUnsaveStatus extends ProgramflowEvent {
  final String itemId;
  final String categoryId;
  FetchSaveUnsaveStatus({required this.itemId, required this.categoryId});
}

// Add Points To Wallet POST API
class AddPointsToWalletEvent extends ProgramflowEvent {
  final int points;
  AddPointsToWalletEvent(this.points);
}

// Get All Recipes GET API
class FetchRecipesEvent extends ProgramflowEvent {
  final List<String> dietaryIds;
  final List<String> cuisineIds;
  final List<String> dietIds;
  final int page;
  final int limit;

  FetchRecipesEvent({
    this.dietaryIds = const [],
    this.cuisineIds = const [],
    this.dietIds = const [],
    required this.page,
    required this.limit
  });
}

// Get Recipe Filter Data GET API
class FilterRecipeEvent extends ProgramflowEvent {
  final String stage;
  FilterRecipeEvent(this.stage);
}

// Fetch Saved Topics GET API
class FetchSavedTopicsEvent extends ProgramflowEvent {
  final String categoryId;
  FetchSavedTopicsEvent(this.categoryId);
}

// Get All Workout Category GET API

class FetchWorkoutCategories extends ProgramflowEvent {
  final int page;
  final int limit;
  FetchWorkoutCategories({required this.page, required this.limit});
}

// Fetch Workout SubCategory GET API

class FetchWorkoutSubcategoryEvent extends ProgramflowEvent {
  final String id;
  final String stage;
  FetchWorkoutSubcategoryEvent({required this.id, required this.stage});
}

// Program Percentage Calculation
class FetchProgramPercentageEvent extends ProgramflowEvent {
  final String categoryId;
  FetchProgramPercentageEvent(this.categoryId);
}

// Get All Notification GET API
class GetAllNotifications extends ProgramflowEvent {
  final String receiverId;
  GetAllNotifications({required this.receiverId});
}

// Delete One Notification DELETE API
class DeleteNotificationEvent extends ProgramflowEvent {
  final String notificationId;
  DeleteNotificationEvent(this.notificationId);
}

// Delete All Notification DELETE API
class DeleteAllNotificationsEvent extends ProgramflowEvent {
  final String receiverId;
  DeleteAllNotificationsEvent(this.receiverId);
}


class FetchQuizEvent extends ProgramflowEvent {}
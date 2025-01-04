import '../../Model/quiz_question.dart';

sealed class ProgramflowState {}

final class ProgramflowInitial extends ProgramflowState {}

// Fetch Category By User Preference GET API
class UserCategoryLoading extends ProgramflowState {}

class UserCategoryLoaded extends ProgramflowState {
  final Map<String, dynamic> successResponse;
  UserCategoryLoaded(this.successResponse);
}

class UserCategoryError extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  UserCategoryError(this.failureResponse);
}

// Fetch Program GET API
class ProgramflowLoading extends ProgramflowState {}

class ProgramflowLoaded extends ProgramflowState {
  final List<dynamic> programs;
  ProgramflowLoaded(this.programs);
}

class ProgramflowError extends ProgramflowState {
  Map<String, dynamic> failureResponse;
  ProgramflowError(this.failureResponse);
}

// Fetch Topic GET API
class TopicLoading extends ProgramflowState {}

class TopicLoaded extends ProgramflowState {
  final Map<String, dynamic> topicsuccessResponse;
  TopicLoaded(this.topicsuccessResponse);
}

class TopicError extends ProgramflowState {
  final Map<String, dynamic> topicfailureResponse;
  TopicError(this.topicfailureResponse);
}

// View Topic GET API
class ViewTopicLoading extends ProgramflowState {}

class ViewTopicLoaded extends ProgramflowState {
  final Map<String, dynamic> viewtopicResponse;

  ViewTopicLoaded(this.viewtopicResponse);
}

class ViewTopicError extends ProgramflowState {
  final Map<String, dynamic> viewtopicfailureResponse;
  ViewTopicError(this.viewtopicfailureResponse);
}

// SaveUnsave Item POST API
class SaveUnsaveItemInitial extends ProgramflowState {}

class SaveUnsaveItemLoading extends ProgramflowState {}

class SaveUnsaveItemSuccess extends ProgramflowState {
  final Map<String, dynamic> successresponse;
  SaveUnsaveItemSuccess(this.successresponse);
}

class SaveUnsaveItemFailure extends ProgramflowState {
  final Map<String, dynamic> failureresponse;
  SaveUnsaveItemFailure(this.failureresponse);
}

// Fetch Save Unsave Status GET API
class SaveUnsaveStatusLoading extends ProgramflowState {}

// Loaded State
class SaveUnsaveStatusLoaded extends ProgramflowState {
  final bool isSaved;
  final bool isCompleted;

  SaveUnsaveStatusLoaded({
    required this.isSaved,
    required this.isCompleted,
  });
}

// Error State
class SaveUnsaveStatusError extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  SaveUnsaveStatusError(this.failureResponse);
}

// Add Points To Wallet POST API
class AddPointsToWalletLoading extends ProgramflowState {}

class AddPointsToWalletSuccess extends ProgramflowState {
  final Map<String, dynamic> successResponse;
  AddPointsToWalletSuccess(this.successResponse);
}

class AddPointsToWalletFailure extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  AddPointsToWalletFailure(this.failureResponse);
}

// Get All Workout Category GET API

class WorkoutCategoryLoading extends ProgramflowState {}

class WorkoutCategoryLoaded extends ProgramflowState {
  final List<dynamic> workoutCategories;
  final Map<String, dynamic> pagination;

  WorkoutCategoryLoaded({
    required this.workoutCategories,
    required this.pagination,
  });
}

class WorkoutCategoryError extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  WorkoutCategoryError(this.failureResponse);
}

// Get Workout SubCategory GET API

class SubWorkoutLoading extends ProgramflowState {}

class SubWorkoutLoaded extends ProgramflowState {
  final Map<String, dynamic> successResponse;
  SubWorkoutLoaded(this.successResponse);
}

class SubWorkoutError extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  SubWorkoutError(this.failureResponse);
}

// Get All Recipes By Type GET API

class RecipeLoading extends ProgramflowState {}

class RecipeLoaded extends ProgramflowState {
  final List<dynamic> successResponse; // Change to List instead of Map
  final Map<String, dynamic> pagination;
  RecipeLoaded({
    required this.successResponse,
    required this.pagination,
  });
}

class RecipeError extends ProgramflowState {
  final Map<String, dynamic> failureResponse; // Change to Map instead of List
  RecipeError(this.failureResponse);
}

// Get Recipe Filter Data GET API

class FilterRecipeLoading extends ProgramflowState {}

class FilterRecipeLoaded extends ProgramflowState {
  final List<String> allDietary;
  final List<String> allDiets;
  final List<String> allCuisines;
  final List<String> dietaryIds;
  final List<String> dietIds;
  final List<String> cuisineIds;

  FilterRecipeLoaded({
    required this.allDietary,
    required this.allDiets,
    required this.allCuisines,
    required this.cuisineIds,
    required this.dietaryIds,
    required this.dietIds,
  });
}

class FilterRecipeError extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  FilterRecipeError(this.failureResponse);
}

// Fetch Saved Topics GET API
class SavedTopicsLoading extends ProgramflowState {}

class SavedTopicsLoaded extends ProgramflowState {
  final List<Map<String, dynamic>> savedTopics;
  final String responseMessage;
  SavedTopicsLoaded(this.savedTopics, this.responseMessage);
}

class SavedTopicsError extends ProgramflowState {
  final String message;
  SavedTopicsError(this.message);
}

// Fetch Program Percentage GET API

class ProgramPercentageLoading extends ProgramflowState {}

class ProgramPercentageLoaded extends ProgramflowState {
  final List<Map<String, dynamic>> percentages;
  ProgramPercentageLoaded(this.percentages);
}

class ProgramPercentageError extends ProgramflowState {
  final String message;
  ProgramPercentageError(this.message);
}

// Get All Notification GET API
class NotificationLoading extends ProgramflowState {}

class NotificationLoaded extends ProgramflowState {
  final List<dynamic> notifications;
  NotificationLoaded(this.notifications);
}

class NotificationError extends ProgramflowState {
  final String message;
  NotificationError(this.message);
}

// Delete One Notification DELETE API
class NotificationDeleteLoading extends ProgramflowState {}

class NotificationDeleteSuccess extends ProgramflowState {
  final Map<String, dynamic> successResponse;
  NotificationDeleteSuccess(this.successResponse);
}

class NotificationDeleteFailure extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  NotificationDeleteFailure(this.failureResponse);
}

// Delete All Notification DELETE API
class NotificationLoadingState extends ProgramflowState {}

class NotificationDeletedState extends ProgramflowState {
  final Map<String, dynamic> successResponse;
  NotificationDeletedState(this.successResponse);
}

class NotificationErrorState extends ProgramflowState {
  final Map<String, dynamic> failureResponse;
  NotificationErrorState(this.failureResponse);
}

// State representing a server failure
class CommonServerFailure extends ProgramflowState {
  final String error;
  CommonServerFailure(this.error);
}

// State representing no network connection
class CheckNetworkConnection extends ProgramflowState {}


// Fetch Program GET API
class QuizLoading extends ProgramflowState {}

class QuizLoaded extends ProgramflowState {
  final List<QuizQuestion> quizQuestions;

  QuizLoaded(this.quizQuestions);
}

class QuizError extends ProgramflowState {
  final String errorMessage;
  QuizError(this.errorMessage);
}
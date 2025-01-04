part of 'drawer_bloc.dart';

@immutable
sealed class DrawerState {}

final class DrawerInitial extends DrawerState {}

// Get User Profile API
class UserProfileLoading extends DrawerState {}

class UserProfileLoaded extends DrawerState {
 Map<String,dynamic> successResponse;
 UserProfileLoaded(this.successResponse);
}

class UserProfileError extends DrawerState {
  Map<String,dynamic> failureResponse;
  UserProfileError(this.failureResponse);
}

// Change Password Post API
class ChangePasswordLoading extends DrawerState {}

class ChangePasswordLoaded extends DrawerState {
  Map<String,dynamic> successResponse;
  ChangePasswordLoaded(this.successResponse);
}

class ChangePasswordError extends DrawerState {
  Map<String,dynamic> failureResponse;
  ChangePasswordError(this.failureResponse);
}


// Update User Profile PUT API
class UpdateProfileLoading extends DrawerState {}

class UpdateProfileLoaded extends DrawerState {
  Map<String,dynamic> successResponse;
  UpdateProfileLoaded(this.successResponse);
}

class UpdateProfileError extends DrawerState {
  Map<String,dynamic> failureResponse;
  UpdateProfileError(this.failureResponse);
}

class OptionsDataLoading extends DrawerState {}

class OptionsDataLoaded extends DrawerState {
  final Map<String, List<String>> optionsData;
  OptionsDataLoaded(this.optionsData);
}

class OptionsDataError extends DrawerState {
  final String message;
  OptionsDataError(this.message);
}

class CommonServerFailure extends DrawerState {
  final String error;
  CommonServerFailure(this.error);

}

class CheckNetworkConnection extends DrawerState {
}
part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

// User SignUp API
final class SignupLoadingState extends AuthenticationState {}

final class SignupSuccess extends AuthenticationState {
  final Map<String, dynamic> SignupSuccessResponse;
  SignupSuccess(this.SignupSuccessResponse);
}

final class SignupFailure extends AuthenticationState {
  final Map<String, dynamic> SignupFailureResponse;
  SignupFailure(this.SignupFailureResponse);
}

// User SignIn API
final class SignInLoadingState extends AuthenticationState {}

final class SignInSuccess extends AuthenticationState {
  final Map<String, dynamic> SignInSuccessResponse;
  SignInSuccess(this.SignInSuccessResponse);
}

final class SignInFailure extends AuthenticationState {
  final Map<String, dynamic> SignInFailureResponse;
  SignInFailure(this.SignInFailureResponse);
}

class GetAllCountriesSuccess extends AuthenticationState {
  final Map<String,dynamic> countries;
  GetAllCountriesSuccess(this.countries);
}



// Location API
class LocationLoading extends AuthenticationState {}

class LocationLoaded extends AuthenticationState {
  final Map<String, dynamic> location;
  LocationLoaded(this.location);
}

class LocationError extends AuthenticationState {
  final Map<String, dynamic> error;
  LocationError(this.error);
}

// Reset Password API
final class ResetLoading extends AuthenticationState {}

final class ResetSuccess extends AuthenticationState {
  final Map<String, dynamic> ResetSuccessResponse;
  ResetSuccess(this.ResetSuccessResponse);
}

final class ResetFailure extends AuthenticationState {
  final Map<String, dynamic> ResetFailureResponse;
  ResetFailure(this.ResetFailureResponse);
}

// Send OTP API
final class SendOTPLoading extends AuthenticationState {}

final class SendOTPSuccess extends AuthenticationState {
  final Map<String, dynamic> SendOTPResponse;
  SendOTPSuccess(this.SendOTPResponse);
}

final class SendOTPFailure extends AuthenticationState {
  final Map<String, dynamic> SendOTPFailureResponse;
  SendOTPFailure(this.SendOTPFailureResponse);
}

// Verify OTP API
final class VerifyOTPLoading extends AuthenticationState {}

final class VerifyOTPSuccess extends AuthenticationState {
  final Map<String, dynamic> VerifyOTPResponse;
  VerifyOTPSuccess(this.VerifyOTPResponse);
}

final class VerifyOTPFailure extends AuthenticationState {
  final Map<String, dynamic> VerifyOTPFailureResponse;
  VerifyOTPFailure(this.VerifyOTPFailureResponse);
}

// Select Stage  API
final class SelectStageLoading extends AuthenticationState {}

final class SelectStageSuccess extends AuthenticationState {
  final Map<String, dynamic> SelectStageResponse;
  SelectStageSuccess(this.SelectStageResponse);
}

final class SelectStageFailure extends AuthenticationState {
  final Map<String, dynamic> SelectStageFailureResponse;
  SelectStageFailure(this.SelectStageFailureResponse);
}

// Global Search  API
final class GlobalSearchLoading extends AuthenticationState {}

final class GlobalSearchSuccess extends AuthenticationState {
  final Map<String, dynamic> GlobalSearchResponse;
  GlobalSearchSuccess(this.GlobalSearchResponse);
}

final class GlobalSearchFailure extends AuthenticationState {
  final Map<String, dynamic> GlobalSearchFailureResponse;
  GlobalSearchFailure(this.GlobalSearchFailureResponse);
}

// Update Preference API
final class UpdatePreferenceInitial extends AuthenticationState {}

final class UpdatePreferenceLoading extends AuthenticationState {}

final class UpdatePreferenceSuccess extends AuthenticationState {
  final Map<String, dynamic> updatePreferenceResponse;
  UpdatePreferenceSuccess(this.updatePreferenceResponse);
}

final class UpdatePreferenceFailure extends AuthenticationState {
  final Map<String, dynamic> updatePreferenceFailureResponse;
  UpdatePreferenceFailure(this.updatePreferenceFailureResponse);
}

class CommonServerFailure extends AuthenticationState {
  final String error;
  CommonServerFailure(this.error);

}

class CheckNetworkConnection extends AuthenticationState {
}



import 'package:flutter/cupertino.dart';

@immutable
sealed class AuthenticationEvent {}

// Sign up Post Event
class SignupRequested extends AuthenticationEvent {
  final String fullName;
  final String country;
  final String countryCode;
  final String phoneNumber;
  final String email;
  final String password;
  final String? deviceToken;
  final String? deviceType;

  SignupRequested(
      {required this.fullName,
      required this.country,
      required this.countryCode,
      required this.phoneNumber,
      required this.email,
      required this.password,
      this.deviceToken,
      this.deviceType});
}

// Sign in Post Event
class SignInRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final String? deviceToken;
  final String? deviceType;

  SignInRequested(
      {required this.email,
      required this.password,
      this.deviceToken,
      this.deviceType});
}

// Location Put API
class LocationRequested extends AuthenticationEvent {
  final String token;
  final double longitude;
  final double latitude;

  LocationRequested({
    required this.token,
    required this.longitude,
    required this.latitude,
  });
}

// Reset Password
class ResetPasswordRequested extends AuthenticationEvent {
  final String email;
  final String newPassword;

  ResetPasswordRequested({
    required this.email,
    required this.newPassword,
  });
}

// Send OTP
class SendOTPRequested extends AuthenticationEvent {
  final String email;

  SendOTPRequested({
    required this.email,
  });
}

// Verify OTP
class VerifyOTPRequested extends AuthenticationEvent {
  final String email;
  final String otp;

  VerifyOTPRequested({
    required this.email,
    required this.otp,
  });
}

// Select Stage API
class SelectStageRequested extends AuthenticationEvent {
  final String stage;

  SelectStageRequested({
    required this.stage,
  });
}

// Global Search API
class GlobalSearchEvent extends AuthenticationEvent {
  final String search;
  final int page;
  final int limit;

  GlobalSearchEvent({
    required this.search,
    required this.page,
    required this.limit,
  });
}

// Update Preference POST API
class UpdatePreferenceRequested extends AuthenticationEvent {
  final String stage;
  final List<String> categoryIds;

  UpdatePreferenceRequested({
    required this.stage,
    required this.categoryIds,
  });
}

// Get All Countries API
class GetAllCountriesEvent extends AuthenticationEvent {}

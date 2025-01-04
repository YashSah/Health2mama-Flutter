part of 'social_login_bloc.dart';

@immutable
sealed class SocialLoginEvent {}
class GoogleLoginEventHandler extends SocialLoginEvent {}

class FacebookLoginEventHandler extends SocialLoginEvent {}

class AppleLoginEventHandler extends SocialLoginEvent {}

class NodeGoogleLoginEvent extends SocialLoginEvent {
  final String socialId;
  final String email;
  final String socialType;
  final String firstName;
  final String lastName;
  final String? deviceToken;
  final String? deviceType;
  NodeGoogleLoginEvent(this.socialId,this.email,this.socialType, this.firstName, this.lastName,this.deviceToken,this.deviceType);
}

class NodeAppleLoginEvent extends SocialLoginEvent {
  final String socialId;
  final String email;
  final String? firstName;
  final String socialType;
  final String? deviceToken;
  final String? deviceType;
  NodeAppleLoginEvent(this.socialId,this.email,this.socialType,this.deviceToken,this.deviceType, this.firstName);
}





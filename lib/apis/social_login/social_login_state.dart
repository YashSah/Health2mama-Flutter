part of 'social_login_bloc.dart';

@immutable
sealed class SocialLoginState {}

final class SocialLoginInitial extends SocialLoginState {}

class GoogleLoginLoading extends SocialLoginState {}

class GoogleLoginSuccess extends SocialLoginState {
  final String name;
  final String email;
  final String image;
  final String id;
  GoogleLoginSuccess(this.name, this.email, this.image, this.id);

}
class GoogleLoginFailure extends SocialLoginState {
  final Map<String,dynamic>  errorMessage;
  GoogleLoginFailure(this.errorMessage);
}

class AppleLoginLoading extends SocialLoginState {}

class AppleLoginSuccess extends SocialLoginState {
  final String name;
  final String email;
  final String image;
  final String id;
  AppleLoginSuccess(this.name, this.email, this.image, this.id);
}

class AppleLoginError extends SocialLoginState {
  final Map<String,dynamic>  errorMessage;
  AppleLoginError(this.errorMessage);
}

class FacebookLoginLoading extends SocialLoginState {}

class FacebookLoginSuccess extends SocialLoginState {
  final String name;
  String email='';
  final String image;
  final String id;
  FacebookLoginSuccess(this.name, this.email, this.image, this.id);
}

class FacebookLoginFailure extends SocialLoginState {
  final Map<String, dynamic> errorMessage;
  FacebookLoginFailure(this.errorMessage);
}


final class NodeGoogleLoginLoading extends SocialLoginState {}

class NodeGoogleLoginSuccess extends SocialLoginState {
  final Map<String,dynamic> successResponse;
  NodeGoogleLoginSuccess(this.successResponse);

}
class NodeGoogleLoginFailure extends SocialLoginState {
  final Map<String,dynamic>  failureMessage;
  NodeGoogleLoginFailure(this.failureMessage);
}


final class NodeAppleLoginLoading extends SocialLoginState {}

class NodeAppleLoginSuccess extends SocialLoginState {
  final Map<String,dynamic> successResponse;
  NodeAppleLoginSuccess(this.successResponse);

}
class NodeAppleLoginFailure extends SocialLoginState {
  final Map<String,dynamic>  failureMessage;
  NodeAppleLoginFailure(this.failureMessage);
}


class CommonServerFailure extends SocialLoginState {
  final String error;
  CommonServerFailure(this.error);

}

class CheckNetworkConnection extends SocialLoginState {
}

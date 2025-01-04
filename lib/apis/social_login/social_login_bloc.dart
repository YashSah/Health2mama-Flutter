import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../Utils/pref_utils.dart';
import '../../Utils/api_constant.dart';
import '../../Utils/connectivity_service.dart';
part 'social_login_event.dart';
part 'social_login_state.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {
  SocialLoginBloc() : super(SocialLoginInitial()) {

    // Google login event handler
    on<GoogleLoginEventHandler>((event, emit) async {
      var googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount;
      try {
        await googleSignIn.signOut();
        googleSignInAccount = await googleSignIn.signIn();
        emit(GoogleLoginSuccess(
          googleSignInAccount!.displayName.toString(),
          googleSignInAccount.email,
          googleSignInAccount.photoUrl.toString(),
          googleSignInAccount.id.toString(),
        ));
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    });

    // Apple login event handler
    on<AppleLoginEventHandler>((event, emit) async {
      try {
        emit(AppleLoginLoading());
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);

        // Request credential for the currently signed-in Apple account.
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        // Create OAuthCredential from the credential returned by Apple.
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
          rawNonce: rawNonce,
        );


        // Sign in to Firebase with the Apple credential.
        final jsonResponse = await FirebaseAuth.instance.signInWithCredential(
          oauthCredential,
        );

        final user = jsonResponse.user;

        // Handle first-time sign-in or if email is provided
        String? email = user?.email ?? appleCredential.email; // Prefer Firebase email if available
        String? displayName = user?.displayName ?? appleCredential.givenName ?? appleCredential.familyName;

        if (email == null) {
          // Prompt user to manually provide their email, or handle accordingly
          email = "Unknown";
        }

        if (user != null) {
          emit(AppleLoginSuccess(
            displayName ?? "",
            email,
            user.photoURL ?? "",
            user.uid,
          ));
        } else {
          emit(AppleLoginError({"error": "User authentication failed"}));
        }
      } catch (e) {
        // Handle errors during sign-in
        Map<String, dynamic> errorDetails = {
          "error": e.toString(),
          "stackTrace": e is Error ? e.stackTrace.toString() : null,
        };

        if (kDebugMode) {
          print("Apple Login Error: $errorDetails");
        }

        emit(AppleLoginError(errorDetails));
      }
    });

    // Facebook login event handler
    on<FacebookLoginEventHandler>((event, emit) async {
      try {
        final FacebookAuth _facebookAuth = FacebookAuth.instance;

        // Check if the user is already logged in
        final AccessToken? currentAccessToken = await _facebookAuth.accessToken;

        if (currentAccessToken != null) {
          // The user is already logged in; you can use the currentAccessToken for further operations.
        }
        else {
          // The user is not logged in; show the Facebook login popup.
          final LoginResult result = await _facebookAuth.login(
            permissions: ['email', 'public_profile'],
          );

          if (result.status == LoginStatus.success) {
            final requestData = await _facebookAuth.getUserData(
              fields: "name,email,picture.width(200),birthday,friends,gender,link",
            );


            final AccessToken accessToken = result.accessToken!;
            // Use the accessToken for further operations.

             developer.log('FacebookLoginEventHandler$requestData');
            // Emit your success event with the user data.
            emit(FacebookLoginSuccess(
                requestData["name"] ?? '',
                requestData["email"] ?? '',
                requestData["picture"]["data"]["url"] ?? "",
                requestData["id"] ?? ''
            ));
          } else if (result.status == LoginStatus.cancelled) {
            // Handle user cancellation.
            // You might want to emit an event or show an error message to the user.
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    });


    // Node Google login event handler
    on<NodeGoogleLoginEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(NodeGoogleLoginLoading());
        try {
          final requestData = json.encode({
            "socialId": event.socialId,
            "email": event.email.contains("@") ? event.email : "",
            "socialType": event.socialType,
            "firstName":event.firstName,
            "lastName":event.lastName,
            "deviceToken":event.deviceToken,
            "deviceType":event.deviceType,
          });

          developer.log("Request URL: ${Uri.parse(APIEndPoints.socialLogin)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.socialLogin),
            headers: {'Content-Type': 'application/json'},
            body: requestData,
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final token = responseData['result']['token'] ?? '';
            final userEmail = responseData['result']['email'] ?? '';
            final userStage = responseData['result']['stage'] ?? '';
            final userId = responseData['result']['id'] ?? '';

            PrefUtils.setUserLoginToken(token);
            PrefUtils.setUserEmail(userEmail);
            PrefUtils.setUserStage(userStage);
            PrefUtils.setUserId(userId);

            developer.log("Social User Login Token Is :${PrefUtils.getUserLoginToken()}");
            developer.log("Raw Response Data: $responseData");

            emit(NodeGoogleLoginSuccess(responseData));
          } else {
            emit(NodeGoogleLoginFailure({
              'error': 'Unexpected response structure',
            }));
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception occurred: $e", name: 'SignInRequested');
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });


    // Node Google login event handler
    on<NodeAppleLoginEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(NodeGoogleLoginLoading());
        try {
          final requestData = json.encode({
            "socialId": event.socialId,
            "email": event.email.contains("@") ? event.email : "",
            "firstName":event.firstName,
            "socialType": event.socialType,
            "deviceToken":event.deviceToken,
            "deviceType":event.deviceType,
          });

          developer.log("Request URL: ${Uri.parse(APIEndPoints.socialLogin)}");
          developer.log("Request Data: $requestData");

          var response = await http.post(
            Uri.parse(APIEndPoints.socialLogin),
            headers: {'Content-Type': 'application/json'},
            body: requestData,
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final token = responseData['result']['token'] ?? '';
            final userEmail = responseData['result']['email'] ?? '';
            final userStage = responseData['result']['stage'] ?? '';
            final userId = responseData['result']['id'] ?? '';

            PrefUtils.setUserLoginToken(token);
            PrefUtils.setUserEmail(userEmail);
            PrefUtils.setUserStage(userStage);
            PrefUtils.setUserId(userId);

            developer.log("Social User Login Token Is :${PrefUtils.getUserLoginToken()}");
            developer.log("Raw Response Data: $responseData");

            emit(NodeGoogleLoginSuccess(responseData));
          } else {
            emit(NodeGoogleLoginFailure({
              'error': 'Unexpected response structure',
            }));
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception occurred: $e", name: 'SignInRequested');
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

  }

  // Helper methods for generating nonce and SHA256 hash.
  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/Auth_flow/userSetUpScreen.dart';
import 'package:health2mama/Screen/auth_flow/userLocation.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/connectivity_service.dart';
import 'package:health2mama/Utils/firebasefunctions.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import 'package:health2mama/apis/social_login/social_login_bloc.dart';
import 'package:health2mama/main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/Auth_flow/create_screen.dart';
import 'package:health2mama/Screen/Auth_flow/forgotPassword.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:health2mama/Utils/constant.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import '../../Utils/flutter_text_form_fields_style.dart';
import '../../Utils/no_space_input_formatter_class.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    ConnectivityService.requestLocationPermission();
    registerFcmToken(); // Register and print the FCM token here
    _loadStoredCredentials();
  }

  void _loadStoredCredentials() async {
    final email = await PrefUtils.getUserEmail();
    final password = await PrefUtils.getUserPassword();


    if (email != null) {
      setState(() {
        _email.text = email;
      });
    }

    if (password != null) {
      setState(() {
        _password.text = password;
      });
    }
  }

  void navigateBasedOnCondition(
      BuildContext context, Map<String, dynamic> successResponse) {
    // Check if setUserStage is null
    if (successResponse['result'].containsKey('stage')) {
      if (successResponse['result']['stage'].isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const UserLocationScreen(isSignup: false)),
        );
      }
    } else {
      // Navigate to UserSetupScreen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserLocationScreen(isSignup: true)),
      );
    }
  }

  final animationsMap = {
    'columnOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'imageOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(40.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool checkboxChecked = false;
  bool isLoading = false; // Loading state
  bool isLoading1 = false; // Loading state
  bool isButtonEnabled = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  bool isEmailFieldFocused = false;
  bool isPasswordFieldFocused = false;
  String? emailErrorText;
  String? passwordErrorText;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  bool isValidEmail(String email) {
    if (email.length > 254) {
      return false; // email address too long
    }

    final RegExp regex = RegExp(
      r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
    );

    if (!regex.hasMatch(email)) {
      return false; // invalid email format
    }

    List<String> parts = email.split('@');

    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return false; // email should contain one @ symbol and non-empty parts
    }

    if (parts[0].length > 64) {
      return false; // local part before @ should not exceed 64 characters
    }

    if (parts[1].length > 255) {
      return false; // domain part after @ should not exceed 255 characters
    }

    return true;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.nullEmailField; // "Email field cannot be empty."
    }

    if (!isValidEmail(value)) {
      return Constants.wrongEmailFormat; // "Invalid email format."
    }

    return null;
  }

  String? isValidPass(String pass) {
    if (pass.isEmpty) {
      return "Please enter password."; // Validation for empty password
    }
    if (pass.length < 8 || pass.length > 16) {
      return "Password must be between 8 and 16 characters."; // Validation for length
    }
    return null; // Valid password
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is SignInSuccess) {
                  setState(() {
                    isLoading = false;
                  });
                  PrefUtils.setUserName(
                      state.SignInSuccessResponse['result']['fullName']);
                  PrefUtils.setUserLoginToken(
                      state.SignInSuccessResponse['result']['token']);
                  PrefUtils.setUserEmail(
                      state.SignInSuccessResponse['result']['email']);
                  PrefUtils.setUserStage(
                      state.SignInSuccessResponse['result']['stage']);
                  PrefUtils.setUserId(
                      state.SignInSuccessResponse['result']['id']);

                  // Navigate to LoginScreen
                  if (state.SignInSuccessResponse["responseCode"] == 200) {
                    setState(() {
                      PrefUtils.setIsLogin(true);
                      print(PrefUtils.getIsLogin());
                      PrefUtils.setIsSocialLogin(false);
                    });
                  }
                  navigateBasedOnCondition(
                      context, state.SignInSuccessResponse);
                }
                else if (state is SignInFailure) {
                  setState(() {
                    isLoading = false;
                  });
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(state.SignInFailureResponse['responseMessage']),
                    ),
                  );
                }
                else if (state is SignInLoadingState) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
            ),
            BlocListener<SocialLoginBloc, SocialLoginState>(
              listener: (context, state) async {
                if (state is GoogleLoginLoading) {
                  setState(() {
                    isLoading1 = true; // Show the loader
                  });
                }
                else if (state is GoogleLoginSuccess) {
                  setState(() {
                    isLoading1 = false; // Show the loader
                  });
                  var socialID = state.id;
                  var name = state.name;
                  var email = state.email;
                  var image = state.image;

                  print('User Social ID Is :${socialID}');
                  print('User Name Is :${name}');
                  PrefUtils.setUserEmail(state.email);
                  print('User Email Is :${PrefUtils.getUserEmail()}');
                  // Split the full name into firstName and lastName
                  var nameParts = name.split(' ');
                  var firstName = nameParts[0]; // First part is the first name
                  var lastName = nameParts.length > 1
                      ? nameParts.last
                      : ''; // Last part is the last name, if it exists

                  print('First Name: $firstName');
                  print('Last Name: $lastName');
                  print('User Social ID Is :${socialID}');
                  print('User Name Is :${name}');
                  PrefUtils.setUserEmail(state.email);
                  print('User Email Is :${PrefUtils.getUserEmail()}');
                  // Get the device type asynchronously
                  String deviceType = await getDeviceInfo(
                      context); // Ensure this method is defined and returns the device type

                  // Dispatch the NodeGoogleLoginEvent with the split firstName and lastName
                  BlocProvider.of<SocialLoginBloc>(context).add(
                    NodeGoogleLoginEvent(
                      socialID,
                      email,
                      'google',
                      firstName,
                      lastName,
                      PrefUtils.getDeviceToken(),
                      deviceType, // Pass the retrieved device type
                    ),
                  );
                }
                else if (state is NodeGoogleLoginLoading){
                  setState(() {
                    isLoading1 = true; // Show the loader
                  });
                }
                else if (state is NodeGoogleLoginSuccess) {
                  PrefUtils.setIsSocialLogin(true);
                  PrefUtils.setIsLogin(true);
                  print("state.successResponse>>>> ${state.successResponse}");
                  navigateBasedOnCondition(context, state.successResponse);
                  setState(() {
                    isLoading1 = false; // Show the loader
                  });
                }
                else if (state is NodeGoogleLoginFailure) {
                  setState(() {
                    isLoading1 = false; // Show the loader
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('${state.failureMessage['responseMessage']}')));
                }
                else if (state is GoogleLoginFailure) {
                  setState(() {
                    isLoading1 = false; // Show the loader
                  });
                  // Dismiss the loading dialog if it's open
                  Navigator.pop(context);
                  CommonPopups.showCustomPopup(
                      context, state.errorMessage['responseMessage']);
                }
                //apple login

                if (state is AppleLoginLoading) {
                  setState(() {
                    isLoading1 = true; // Show the loader
                  });
                }
                else if (state is AppleLoginSuccess) {
                  setState(() {
                    isLoading1 = false; // Hide the loader when the login is successful
                  });
                  try {
                    // Get the device type asynchronously
                    String deviceType = await getDeviceInfo(context);

                    // Dispatch the NodeAppleLoginEvent to the SocialLoginBloc
                    BlocProvider.of<SocialLoginBloc>(context).add(
                      NodeAppleLoginEvent(
                        state.id,
                        state.email,
                        'apple',
                        PrefUtils.getDeviceToken(),
                        deviceType,
                        state.name
                      ),
                    );
                  } catch (e) {
                    setState(() {
                      isLoading1 = false; // Hide the loader in case of an error
                    });
                    print('Error in AppleLoginSuccess processing: $e');
                    CommonPopups.showCustomPopup(
                        context, "An error occurred while processing login.");
                  }
                }
                else if (state is AppleLoginError) {
                  setState(() {
                    isLoading1 = false; // Hide the loader on error
                  });
                  final errorMessage = state.errorMessage['responseMessage'] ??
                      "An unknown error occurred.";
                  CommonPopups.showCustomPopup(context, errorMessage);
                }
              },
            ),
          ],
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 15.h
                        : 15.0),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(
                      top: (displayType == 'desktop' || displayType == 'tablet')
                          ? 10.h
                          : 50,
                      bottom:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 50.h
                              : 50),
                  child: Image.asset(
                    'assets/Images/app_logo.png',
                    width: (displayType == 'desktop' || displayType == 'tablet')
                        ? 180.w
                        : 180,
                    height:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 75.h
                            : 75,
                  ),
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(
                      vertical:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 20.h
                              : 20),
                  margin: EdgeInsets.symmetric(
                      horizontal:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 60.h
                              : 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0.0, 0.0),
                        color: Colors.grey, // Adjust opacity as needed
                        blurRadius: 8.0,
                        spreadRadius: 0.03,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.cardBack, // Set the border color here
                      width: 1.0, // Set the border width as desired
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: Text(
                            Constants.loginHeading,
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.loginTitleStyleTablet
                                : FTextStyle.loginTitleStyle,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          color: AppColors.editTextBorderColor,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          onChanged: () {
                            setState(() {
                              // Validate email and password fields if they are focused
                              if (isEmailFieldFocused) {
                                emailErrorText = emailValidator(_email.text); // Validate email on change
                              }
                              if (isPasswordFieldFocused) {
                                passwordErrorText = isValidPass(_password.text); // Validate password on change
                              }

                              // Enable the button only if both email and password are valid, non-empty, and the checkbox is checked
                              isButtonEnabled =
                                  _email.text.isNotEmpty &&
                                      _password.text.isNotEmpty &&
                                      emailErrorText == null &&
                                      passwordErrorText == null;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email Field Heading
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                                child: Text(
                                  Constants.loginEmailFieldHeading,
                                  style: (displayType == 'desktop' || displayType == 'tablet')
                                      ? FTextStyle.loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ),
                              ),

                              // Email Field
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: TextFormField(
                                  key: _emailKey,
                                  focusNode: _emailFocusNode,
                                  cursorColor: AppColors.authScreensHeading,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: TextFormFieldStyle.defaultemailInputDecoration(displayType),
                                  inputFormatters: [
                                    NoSpaceFormatter(),
                                    LengthLimitingTextInputFormatter(254),
                                  ],
                                  controller: _email,
                                  // Real-time validation for email
                                  onChanged: (value) {
                                    setState(() {
                                      emailErrorText = emailValidator(value); // Validate email on change
                                      isEmailFieldFocused = true;
                                      isPasswordFieldFocused = false;
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      isEmailFieldFocused = true;
                                      isPasswordFieldFocused = false;
                                    });
                                  },
                                ),
                              ),

                              // Email Error Message
                              if (isLoading1)
                                Center(child: CircularProgressIndicator(color: AppColors.pink))
                              else if (emailErrorText != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                                  child: Text(
                                    emailErrorText ?? '',
                                    style: FTextStyle.formFieldErrorTxtStyle,
                                  ),
                                ),

                              // Password Field Heading
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15, top: 5),
                                child: Text(
                                  "Password*",
                                  style: (displayType == 'desktop' || displayType == 'tablet')
                                      ? FTextStyle.loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ),
                              ),

                              // Password Field
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: TextFormField(
                                  key: _passwordKey,
                                  focusNode: _passwordFocusNode,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(color: AppColors.editTextBorderColorenabled),
                                    ),
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(color: AppColors.editTextBorderColorenabled),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(color: AppColors.editTextBorderColorfocused),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(color: AppColors.errorColor),
                                    ),
                                    focusedErrorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(color: AppColors.errorColor),
                                    ),
                                    hintText: Constants.loginPasswordFieldHintText,
                                    hintStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.formFieldErrorTxtStyleTablet
                                        : FTextStyle.formFieldErrorTxtStyle,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: AppColors.authScreensHeading,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  cursorColor: AppColors.authScreensHeading,
                                  keyboardType: TextInputType.text,
                                  controller: _password,
                                  obscureText: !passwordVisible, // Changed to !passwordVisible for clarity
                                  inputFormatters: [
                                    NoSpaceFormatter(),
                                    LengthLimitingTextInputFormatter(16),
                                  ],
                                  // Real-time validation for password
                                  onChanged: (value) {
                                    setState(() {
                                      passwordErrorText = isValidPass(value); // Validate password on change
                                      isPasswordFieldFocused = true;
                                      isEmailFieldFocused = false;
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      isPasswordFieldFocused = true;
                                      isEmailFieldFocused = false;
                                    });
                                  },
                                ),
                              ),

                              // Password Error Message
                              if (passwordErrorText != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                                  child: Text(
                                    passwordErrorText ?? '',
                                    style: FTextStyle.formFieldErrorTxtStyle,
                                  ),
                                ),
                            ],
                          ),
                        ),

                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Row(
                              children: [
                              GestureDetector(
                              onTap: () {
                            setState(() {
                            checkboxChecked = !checkboxChecked; // Toggle the checkbox state
                            });
                            },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: IconTheme(
                                  data: const IconThemeData(
                                    color: AppColors.primaryColorPink,
                                    size: 20,
                                  ),
                                  child: Icon(
                                    checkboxChecked ? Icons.check_box : Icons.check_box_outline_blank,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              Constants.rememberMeTxt,
                              style: (displayType == 'desktop' || displayType == 'tablet')
                                  ? FTextStyle.rememberMeTextStyleTablet
                                  : FTextStyle.rememberMeTextStyle,
                            ),
                          ],
                        ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPasswordScreen()));
                                    },
                                    child: Text(
                                      Constants.forgotPassTxt,
                                      style: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle.forgotPassStyleTablet
                                          : FTextStyle.forgotPassStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width: width,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: isButtonEnabled
                                      ? () async {
                                          // Check if the checkbox is checked and save or clear credentials
                                          if (checkboxChecked) {
                                            await PrefUtils.saveCredentials(
                                                _email.text, _password.text);
                                          } else {
                                            await PrefUtils.clearCredentials();
                                          }
                                          // Get the device type asynchronously
                                          String deviceType =
                                              await getDeviceInfo(context);

                                          // Add the SignInRequested event to the bloc
                                          BlocProvider.of<AuthenticationBloc>(
                                                  context)
                                              .add(
                                            SignInRequested(
                                              email: _email.text,
                                              password: _password.text,
                                              deviceToken:
                                                  PrefUtils.getDeviceToken(),
                                              deviceType:
                                                  deviceType, // Send the retrieved device type
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: isButtonEnabled
                                        ? AppColors.primaryColorPink
                                        : AppColors
                                            .primaryColorPinkdisable, // Use color1 if true, color2 if false
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          Constants.loginBtnTxt,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle.loginBtnStyleTablet
                                              : FTextStyle.loginBtnStyle,
                                        ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Constants.notMemberTxt,
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle
                                                .rememberMeTextStyleTablet
                                            : FTextStyle.rememberMeTextStyle,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CreateAccountScreen()));
                                        },
                                        child: Text(
                                          Constants.getStartedTxt,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .getStartedTxtStyleTablet
                                              : FTextStyle.getStartedTxtStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      Constants.orTxt,
                                      style: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle.subtitleTxtStyleTablet
                                          : FTextStyle.subtitleTxtStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      signInWithFacebook();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15, // Adjust width dynamically
                                      height:
                                      MediaQuery.of(context).size.width *
                                          0.15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.cardBack,
                                      ),
                                      child: Image.asset(
                                        'assets/Images/fb.png',
                                        fit: BoxFit
                                            .fill, // Ensure the image fills the box
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Visibility(
                                  visible: Platform.isIOS,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        BlocProvider.of<SocialLoginBloc>(context)
                                            .add(AppleLoginEventHandler());
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.15, // Adjust width dynamically
                                        height:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.cardBack,
                                        ),
                                        child: Image.asset(
                                          'assets/Images/appleaa.png',
                                          fit: BoxFit
                                              .fill, // Ensure the image fits within the box
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<SocialLoginBloc>(context)
                                          .add(GoogleLoginEventHandler());
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15, // Adjust width dynamically
                                      height:
                                      MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Image.asset(
                                        'assets/Images/gg.png',
                                        fit: BoxFit
                                            .fill, // Ensure the image fills the box
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

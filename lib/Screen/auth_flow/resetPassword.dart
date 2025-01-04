import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/Auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import '../../Utils/constant.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../Utils/no_space_input_formatter_class.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool passwordVisible = true;
  bool confirmpasswordVisible = true;
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
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isButtonEnabled = false;
  String? PasswordError;
  String? ConfirmPasswordError;

  bool isValidconfirmpass(String pass, String confirmPass) {
    if (confirmPass.length == 0 || pass != confirmPass) {
      return false;
    }
    return true;
  }

  GlobalKey<FormFieldState<String>> _passwordKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _confirmPasswordKey = GlobalKey<FormFieldState<String>>();

  bool isPasswordFieldFocused = false;
  bool isConfirmpasswordFieldFocused = false;

  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

  bool isValidPass(String value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    // Password length validation
    if (value.length < 8) {
      return false;
    }
    // Password contains at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    // Password contains at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    // Password contains at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    // Password contains at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }
    // Password meets all criteria
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.90),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: (displayType == 'desktop' || displayType == 'tablet')
                      ? 15.h
                      : 15,
                  top: (displayType == 'desktop' || displayType == 'tablet')
                      ? 3.h
                      : 3),
              child: Image.asset(
                'assets/Images/back.png', // Replace with your image path
                width: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.w
                    : 35, // Set width as needed
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.h
                    : 35, // Set height as needed
              ),
            ),
          ),
        ),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is ResetSuccess) {

              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.ResetSuccessResponse['responseMessage']),
                ),
              );
              // Navigate to LoginScreen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const LoginScreen()));
            } else if (state is ResetFailure) {
              // Dismiss the loading dialog if it's open
              Navigator.pop(context);

              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.ResetFailureResponse['responseMessage']),
                ),
              );
            } else if (state is ResetLoading) {
              // Show a loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator(color: AppColors.pink)),
              );
            }
          },
  child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: (displayType == 'desktop' || displayType == 'tablet')
                  ? 15.h
                  : 15.0),
          child: ListView(
            //physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    top: (displayType == 'desktop' || displayType == 'tablet')
                        ? 10.h
                        : 10,
                    bottom:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 50.h
                        : 50),
                child: Image.asset(
                  'assets/Images/app_logo.png',
                  width: (displayType == 'desktop' || displayType == 'tablet')
                      ? 180.w
                      : 180,
                  height: (displayType == 'desktop' || displayType == 'tablet')
                      ? 75.h
                      : 75,
                ),
              ),
              Container(
                width: double.infinity,
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
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            Constants.resetPasswordHeadingTxt,
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle.loginTitleStyleTablet
                                : FTextStyle.loginTitleStyle,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: AppColors.editTextBorderColor,
                        height: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 30),
                        child: Form(
                          onChanged: () {
                            if (isValidconfirmpass(_password.text.toString(),
                                    _confirmPassword.text.toString()) &&
                                isValidPass(_password.text.toString())) {
                              setState(() {
                                isButtonEnabled = true;
                              });
                            } else {
                              setState(() {
                                isButtonEnabled = false;
                              });
                            }

                            if (isPasswordFieldFocused == true) {
                              _passwordKey.currentState!.validate();
                            }
                            if (isConfirmpasswordFieldFocused == true) {
                              _confirmPasswordKey.currentState!.validate();
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  Constants.loginPasswordFieldHeading,
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle.loginEmailFieldHeadingStyleTablet
                                      :  FTextStyle.loginEmailFieldHeadingStyle,
                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  key: _passwordKey,
                                  focusNode: _passwordFocusNode,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.editTextBorderColorenabled,
                                        )),
                                    disabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.editTextBorderColorenabled,
                                        )),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.editTextBorderColorfocused,
                                        )),
                                    errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        )),
                                    focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        )),
                                    hintText: Constants.loginPasswordFieldHintText,
                                    hintStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.formFieldErrorTxtStyleTablet
                                        : FTextStyle.formFieldErrorTxtStyle,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible ? Icons.visibility_off : Icons.visibility,
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
                                  obscureText: passwordVisible,
                                  inputFormatters: [NoSpaceFormatter(), LengthLimitingTextInputFormatter(60)],

                                  // Validate password in onChanged method and update PasswordError
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        PasswordError = Constants.nullField;
                                      } else if (value.length < 8) {
                                        PasswordError = Constants.lengtherror;
                                      } else if (!value.contains(RegExp(r'[A-Z]'))) {
                                        PasswordError = Constants.uppercaseError;
                                      } else if (!value.contains(RegExp(r'[a-z]'))) {
                                        PasswordError = Constants.lowercaseError;
                                      } else if (!value.contains(RegExp(r'[0-9]'))) {
                                        PasswordError = Constants.numberError;
                                      } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                        PasswordError = Constants.specialChaacterError;
                                      } else {
                                        PasswordError = null; // No error
                                      }
                                    });
                                  },

                                  onTap: () {
                                    setState(() {
                                      isConfirmpasswordFieldFocused = false;
                                      isPasswordFieldFocused = true;
                                    });
                                  },
                                ),
                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),

// Conditionally displaying the PasswordError
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Visibility(
                                  visible: PasswordError != null && PasswordError!.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      PasswordError ?? '',
                                      style: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(bottom: 5,top: 10),
                                child: Text(
                                  Constants.confirmPasswordText,
                                  style: FTextStyle.loginEmailFieldHeadingStyle,
                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  key: _confirmPasswordKey,
                                  focusNode: _confirmPasswordFocusNode,
                                  cursorColor: AppColors.authScreensHeading,
                                  keyboardType: TextInputType.text,
                                  obscureText: confirmpasswordVisible,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.editTextBorderColorenabled,
                                        )),
                                    disabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.editTextBorderColorenabled,
                                        )),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.editTextBorderColorfocused,
                                        )),
                                    errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        )),
                                    focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        )),
                                    hintText: Constants.loginPasswordFieldHintText,
                                    hintStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.formFieldErrorTxtStyleTablet
                                        : FTextStyle.formFieldErrorTxtStyle,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        confirmpasswordVisible ? Icons.visibility_off : Icons.visibility,
                                        color: AppColors.authScreensHeading,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          confirmpasswordVisible = !confirmpasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  controller: _confirmPassword,
                                  inputFormatters: [NoSpaceFormatter(), LengthLimitingTextInputFormatter(60)],
                                  textAlign: TextAlign.start,

                                  // Remove the validator and handle validation in the onChanged method
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        ConfirmPasswordError = Constants.confirmnullField;
                                      } else if (_confirmPassword.text != _password.text) {
                                        ConfirmPasswordError = Constants.confirmPassError;
                                      } else {
                                        ConfirmPasswordError = null; // No error
                                      }
                                    });
                                  },

                                  onTap: () {
                                    setState(() {
                                      isConfirmpasswordFieldFocused = true;
                                      isPasswordFieldFocused = false;
                                    });
                                  },
                                ),
                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),

// Conditionally display the ConfirmPasswordError
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Visibility(
                                  visible: ConfirmPasswordError != null && ConfirmPasswordError!.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      ConfirmPasswordError ?? '',
                                      style: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: 330,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () {
                              BlocProvider.of<AuthenticationBloc>(
                                  context)
                                  .add(
                                ResetPasswordRequested(
                                  email: PrefUtils.getUserEmail(),
                                  newPassword: _password.text,
                                ),
                              );
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => const LoginScreen()));
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: isButtonEnabled
                                  ? AppColors.primaryColorPink
                                  : AppColors
                                      .primaryColorPinkdisable, // Use color1 if true, color2 if false
                            ),
                            child: Text(
                              Constants.continueBtnTxt,
                              style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                                  ? FTextStyle.loginBtnStyleTablet
                                  : FTextStyle.loginBtnStyle,
                            ),
                          ),
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
),
      ),
    );
  }
}

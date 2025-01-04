import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/drawer/drawer_bloc.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? _oldPassError;
  String? _newPassError;
  String? _confirmPassError;
  final int minPasswordLength = 8;
  final int maxPasswordLength = 32;
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;

  bool _isButtonEnabled() {
    final oldPassValid =
        _oldPasswordController.text.length >= minPasswordLength;
    final newPassValid =
        _newPasswordController.text.length >= minPasswordLength &&
            _containsSpecialCharacter(_newPasswordController.text);
    final confirmPassValid =
        _confirmPasswordController.text.length >= minPasswordLength &&
            _confirmPasswordController.text == _newPasswordController.text;
    return oldPassValid && newPassValid && confirmPassValid;
  }

  bool _containsSpecialCharacter(String value) {
    // Define a list of special characters you want to check for
    final specialCharacters = r'!@#$%^&*()_-+={}[]|:;<>,.?/~';

    for (var char in specialCharacters.runes) {
      if (value.contains(String.fromCharCode(char))) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Change Password",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
        body: BlocListener<DrawerBloc, DrawerState>(
          listener: (context, state) {
            if (state is ChangePasswordLoaded) {
              _oldPasswordController.text = '';
              _newPasswordController.text = '';
              _confirmPasswordController.text = '';
              CommonPopups.showCustomPopup(context, state.successResponse['responseMessage']);
            } else if (state is ChangePasswordError) {
              CommonPopups.showCustomPopup(context, state.failureResponse['responseMessage']);
            }
            else if (state is ChangePasswordLoading)
              {
                Center(child: CircularProgressIndicator(color: AppColors.pink));
              }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: screenHeight * 0.0012,
                    color: const Color(0XFFF6F6F6),
                  ), //Separator line
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Old Password',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.loginEmailFieldHeadingStyleTablet
                              : FTextStyle.loginEmailFieldHeadingStyle,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.00625),
                        Container(
                          height: screenHeight * 0.07,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.0325),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: const Color(0XFFEFEFF4)),
                          ),
                          child: Center(
                            child: TextFormField(
                              style: FTextStyle.ForumsTextField,
                              controller: _oldPasswordController,
                              maxLines: 1,
                              maxLength: maxPasswordLength,
                              // Set max length for password
                              onChanged: (_) {
                                setState(() {
                                  if (_oldPasswordController.text.length <
                                      minPasswordLength) {
                                    _oldPassError =
                                        '*Password must be at least $minPasswordLength characters';
                                  } else {
                                    _oldPassError = null;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                // To hide the default counter text
                                border: InputBorder.none,
                                hintText: 'Enter old password',
                                hintStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.loginFieldHintTextStyleTablet
                                    : FTextStyle.loginFieldHintTextStyle,
                                errorStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.formFieldErrorTxtStyleTablet
                                    : FTextStyle.formFieldErrorTxtStyle,
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                          ),
                        ),
                        if (_oldPassError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2),
                            child: Text(
                              _oldPassError!,
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.formFieldErrorTxtStyleTablet
                                  : FTextStyle.formFieldErrorTxtStyle,
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.025),
                        Text(
                          'New Password',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.loginEmailFieldHeadingStyleTablet
                              : FTextStyle.loginEmailFieldHeadingStyle,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.00625),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              height: screenHeight * 0.07,
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.0325, right: 40.0),
                              // Adjusted padding
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border:
                                    Border.all(color: const Color(0XFFEFEFF4)),
                              ),
                              child: Center(
                                child: TextFormField(
                                  style: FTextStyle.ForumsTextField,
                                  controller: _newPasswordController,
                                  maxLines: 1,
                                  maxLength: maxPasswordLength,
                                  // Set max length for password
                                  obscureText: _isObscureNewPassword,
                                  onChanged: (_) {
                                    setState(() {
                                      if (_newPasswordController.text.length <
                                          minPasswordLength) {
                                        _newPassError =
                                            '*Password must be at least $minPasswordLength characters';
                                      } else if (!_containsSpecialCharacter(
                                          _newPasswordController.text)) {
                                        _newPassError =
                                            '*Password must contain at least one special character';
                                      } else {
                                        _newPassError = null;
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    // To hide the default counter text
                                    border: InputBorder.none,
                                    hintText: 'Enter new password',
                                    hintStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .formFieldErrorTxtStyleTablet
                                        : FTextStyle.formFieldErrorTxtStyle,
                                  ),
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscureNewPassword =
                                      !_isObscureNewPassword;
                                });
                              },
                              icon: Icon(
                                _isObscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (_newPassError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2),
                            child: Text(
                              _newPassError!,
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.formFieldErrorTxtStyleTablet
                                  : FTextStyle.formFieldErrorTxtStyle,
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.025),
                        Text(
                          'Confirm Password',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.loginEmailFieldHeadingStyleTablet
                              : FTextStyle.loginEmailFieldHeadingStyle,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.00625),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              height: screenHeight * 0.07,
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.0325, right: 40.0),
                              // Adjusted padding
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border:
                                    Border.all(color: const Color(0XFFEFEFF4)),
                              ),
                              child: Center(
                                child: TextFormField(
                                  style: FTextStyle.ForumsTextField,
                                  controller: _confirmPasswordController,
                                  maxLines: 1,
                                  maxLength: maxPasswordLength,
                                  // Set max length for password
                                  obscureText: _isObscureConfirmPassword,

                                  onChanged: (_) {
                                    setState(() {
                                      if (_confirmPasswordController
                                              .text.length <
                                          minPasswordLength) {
                                        _confirmPassError =
                                            '*Password must be at least $minPasswordLength characters';
                                      } else if (_confirmPasswordController
                                              .text !=
                                          _newPasswordController.text) {
                                        _confirmPassError =
                                            '*Password did not match.';
                                      } else {
                                        _confirmPassError = null;
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    // To hide the default counter text
                                    border: InputBorder.none,
                                    hintText: 'Confirm new password',
                                    hintStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .formFieldErrorTxtStyleTablet
                                        : FTextStyle.formFieldErrorTxtStyle,
                                  ),
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscureConfirmPassword =
                                      !_isObscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _isObscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (_confirmPassError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 2),
                            child: Text(
                              _confirmPassError!,
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.formFieldErrorTxtStyleTablet
                                  : FTextStyle.formFieldErrorTxtStyle,
                            ),
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.025),
                        Container(
                          height: screenHeight * 0.065,
                          width: screenWidth * 0.30,
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled()
                                ? () {
                              BlocProvider.of<DrawerBloc>(
                                  context)
                                  .add(
                                  ChangePasswordRequested(
                                   currentPassword: _oldPasswordController.text,
                                    newPassword: _newPasswordController.text,
                                      )
                                  );
                                  }
                                : null,
                            child: Text(
                              'Save',
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.tabToStartButtonTablet
                                  : FTextStyle.ForumsButtonStyling,
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: _isButtonEnabled()
                                  ? AppColors.blue1
                                  : AppColors.blue2,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.025),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

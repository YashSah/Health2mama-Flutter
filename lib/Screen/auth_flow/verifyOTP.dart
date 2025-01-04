import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/Auth_flow/resetPassword.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/no_space_input_formatter_class.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import '../../Utils/constant.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../Utils/flutter_text_form_fields_style.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
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
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 0.0),
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
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 0.0),
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
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 0.0),
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
          begin: const Offset(40.0, 0.0),
          end: const Offset(0.0, 0.0),
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
  int _secondsRemaining = 180; // 3 minutes = 180 seconds
  late Timer _timer;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  bool _incorrectOtp = false;
  bool _isTimerRunning = false;
  bool isButtonEnabled = false;

  // Define a FocusNode for the first TextFormField
  final FocusNode _firstFocusNode = FocusNode();

  String getEnteredOTP() {
    return _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text +
        _controller5.text +
        _controller6.text;
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    // Inside your build method or state initialization
    _firstFocusNode.requestFocus(); // Initially focus on the first field
  }

  void restartTimer() {
    setState(() {
      _secondsRemaining = 180; // Reset timer to 3 minutes
      _isTimerRunning = true; // Start the timer
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isTimerRunning = false; // Stop the timer
          timer.cancel(); // Cancel the timer
        }
      });
    });
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSecond,
          (Timer timer) {
        if (_secondsRemaining == 0) {
          timer.cancel();
          // Handle timer completion here
        } else {
          setState(() {
            _secondsRemaining--;
          });
        }
      },
    );
  }

  String getFormattedTime() {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');
    return "$formattedMinutes:$formattedSeconds";
  }

  void clearOTPFields() {
    _controller1.clear();
    _controller2.clear();
    _controller3.clear();
    _controller4.clear();
    _controller5.clear();
    _controller6.clear();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.pop(context);
              // Add your action here, if needed
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
            if (state is VerifyOTPSuccess) {
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.VerifyOTPResponse['responseMessage']),
                ),
              );
              // Navigate to LoginScreen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen()));
            } else if (state is VerifyOTPFailure) {
              // Dismiss the loading dialog if it's open
              Navigator.pop(context);
              setState(() {
                _incorrectOtp = true;
                clearOTPFields();
              });
            } else if (state is VerifyOTPLoading) {
              // Show a loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator(color: AppColors.pink)),
              );
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 15.h
                              : 15.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(
                                  top: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? 10.h
                                      : 10,
                                  bottom: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? 50.h
                                      : 50),
                              child: Image.asset(
                                'assets/Images/app_logo.png',
                                width: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? 180.w
                                    : 180,
                                height: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? 75.h
                                    : 75,
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 20.h
                                        : 20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 60.h
                                        : 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    const BoxShadow(
                                      offset: Offset(0.0, 0.0),
                                      color: Colors.grey,
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Text(
                                        Constants.OTPscreenHeading,
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.loginTitleStyleTablet
                                            : FTextStyle.loginTitleStyle,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                    ),
                                    const Divider(
                                      color: AppColors.editTextBorderColor,
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 15),
                                      child: Text(
                                        Constants.OTPscreenSubHeading,
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle
                                                .loginEmailFieldHeadingStyleTablet
                                            : FTextStyle
                                                .loginEmailFieldHeadingStyle,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Form(
                                        key: _formKey,
                                        onChanged: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isButtonEnabled =
                                                  true; // Enable the button if the entire form is valid
                                            });
                                          } else {
                                            setState(() {
                                              isButtonEnabled =
                                                  false; // Disable the button if the entire form is invalid
                                            });
                                          }
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : 40,
                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : 40,
                                                  child: TextFormField(
                                                    enabled: _secondsRemaining > 0,
                                                    onChanged: (value) {
                                                      if (value.length == 0) {
                                                        FocusScope.of(context).previousFocus();
                                                      } else if (value.length == 1) {
                                                        FocusScope.of(context).nextFocus();
                                                      }
                                                    },
                                                    controller: _controller1,
                                                    decoration: TextFormFieldStyle.defaultotpInputDecoration.copyWith(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8.h), // Adjust padding if necessary
                                                    ),
                                                    cursorColor: AppColors.authScreensHeading,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(1),
                                                      NoSpaceFormatter(),
                                                    ],
                                                    style: FTextStyle.loginFormFieldsTextStyle,
                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                                SizedBox(
                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : 40,
                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : 40,
                                                  child: TextFormField(
                                                    enabled: _secondsRemaining > 0,
                                                    onChanged: (value) {
                                                      if (value.length == 0) {
                                                        FocusScope.of(context).previousFocus();
                                                      } else if (value.length == 1) {
                                                        FocusScope.of(context).nextFocus();
                                                      }
                                                    },
                                                    controller: _controller2,
                                                    decoration: TextFormFieldStyle.defaultotpInputDecoration.copyWith(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8.h), // Adjust padding if necessary
                                                    ),
                                                    cursorColor: AppColors.authScreensHeading,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(1),
                                                      NoSpaceFormatter(),
                                                    ],
                                                    style: FTextStyle.loginFormFieldsTextStyle,
                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                                SizedBox(
                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : 40,
                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : 40,
                                                  child: TextFormField(
                                                    enabled: _secondsRemaining > 0,
                                                    onChanged: (value) {
                                                      if (value.length == 0) {
                                                        FocusScope.of(context).previousFocus();
                                                      } else if (value.length == 1) {
                                                        FocusScope.of(context).nextFocus();
                                                      }
                                                    },
                                                    controller: _controller3,
                                                    decoration: TextFormFieldStyle.defaultotpInputDecoration.copyWith(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8.h), // Adjust padding if necessary
                                                    ),
                                                    cursorColor: AppColors.authScreensHeading,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(1),
                                                      NoSpaceFormatter(),
                                                    ],
                                                    style: FTextStyle.loginFormFieldsTextStyle,
                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                                SizedBox(
                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : 40,
                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : 40,
                                                  child: TextFormField(
                                                    enabled: _secondsRemaining > 0,
                                                    onChanged: (value) {
                                                      if (value.length == 0) {
                                                        FocusScope.of(context).previousFocus();
                                                      } else if (value.length == 1) {
                                                        FocusScope.of(context).nextFocus();
                                                      }
                                                    },
                                                    controller: _controller4,
                                                    decoration: TextFormFieldStyle.defaultotpInputDecoration.copyWith(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8.h), // Adjust padding if necessary
                                                    ),
                                                    cursorColor: AppColors.authScreensHeading,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(1),
                                                      NoSpaceFormatter(),
                                                    ],
                                                    style: FTextStyle.loginFormFieldsTextStyle,
                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                                SizedBox(
                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : 40,
                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : 40,
                                                  child: TextFormField(
                                                    enabled: _secondsRemaining > 0,
                                                    onChanged: (value) {
                                                      if (value.length == 0) {
                                                        FocusScope.of(context).previousFocus();
                                                      } else if (value.length == 1) {
                                                        FocusScope.of(context).nextFocus();
                                                      }
                                                    },
                                                    controller: _controller5,
                                                    decoration: TextFormFieldStyle.defaultotpInputDecoration.copyWith(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8.h), // Adjust padding if necessary
                                                    ),
                                                    cursorColor: AppColors.authScreensHeading,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(1),
                                                      NoSpaceFormatter(),
                                                    ],
                                                    style: FTextStyle.loginFormFieldsTextStyle,
                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                                SizedBox(
                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : 40,
                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : 40,
                                                  child: TextFormField(
                                                    enabled: _secondsRemaining > 0,
                                                    onChanged: (value) {
                                                      if (value.length == 0) {
                                                        FocusScope.of(context).previousFocus();
                                                      } else if (value.length == 1) {
                                                        FocusScope.of(context).nextFocus();
                                                      }
                                                    },
                                                    controller: _controller6,
                                                    decoration: TextFormFieldStyle.defaultotpInputDecoration.copyWith(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8.h), // Adjust padding if necessary
                                                    ),
                                                    cursorColor: AppColors.authScreensHeading,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(1),
                                                      NoSpaceFormatter(),
                                                    ],
                                                    style: FTextStyle.loginFormFieldsTextStyle,
                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                              ],
                                      )))),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3,
                                          bottom: 15,
                                          left: 12,
                                          right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Visibility(
                                            visible: _incorrectOtp,
                                            child: Text(
                                              Constants.errorMsgOtpText,
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .otpErrorTxtStyleTablet
                                                  : FTextStyle.otpErrorTxtStyle,
                                            ),
                                          ),
                                          Text(
                                            getFormattedTime(),
                                            style: (displayType == 'desktop' ||
                                                    displayType == 'tablet')
                                                ? FTextStyle
                                                    .otpErrorTxtStyleTablet
                                                : FTextStyle.otpErrorTxtStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: _secondsRemaining ==
                                          0, // Show when timer reaches 0
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 7,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            clearOTPFields();
                                            restartTimer();
                                            // // Request focus explicitly on _firstFocusNode
                                            // FocusScope.of(context)
                                            //     .requestFocus(_firstFocusNode);
                                            BlocProvider.of<AuthenticationBloc>(
                                                    context)
                                                .add(SendOTPRequested(
                                                    email: PrefUtils
                                                        .getUserEmail()));
                                            setState(() {
                                              _incorrectOtp =
                                                  false; // Reset _incorrectOtp to false
                                            });
                                          },
                                          child: Text(
                                            Constants.resentOtpText,
                                            style: (displayType == 'desktop' ||
                                                    displayType == 'tablet')
                                                ? FTextStyle
                                                    .resendOtpTxtStyleTablet
                                                : FTextStyle.resendOtpTxtStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0,vertical: 24),
                                      child: SizedBox(
                                        width: 330,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor: isButtonEnabled
                                                ? AppColors.primaryColorPink
                                                : AppColors
                                                    .lightGreyColor, // Use color1 if true, color2 if false
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            Constants.continueBtnTxt,
                                            style: (displayType == 'desktop' ||
                                                    displayType == 'tablet')
                                                ? FTextStyle.loginBtnStyleTablet
                                                : FTextStyle.loginBtnStyle,
                                          ),
                                          onPressed: () {
                                            print(
                                                'User Email Is :${PrefUtils.getUserEmail()}');
                                            if (_formKey.currentState!
                                                    .validate() &&
                                                isButtonEnabled) {
                                              String enteredOTP =
                                                  getEnteredOTP();
                                              if (enteredOTP.length == 6) {
                                                // Perform OTP verification
                                                BlocProvider.of<
                                                            AuthenticationBloc>(
                                                        context)
                                                    .add(
                                                  VerifyOTPRequested(
                                                    email: PrefUtils
                                                        .getUserEmail(),
                                                    otp:
                                                        enteredOTP, // Pass the concatenated OTP here
                                                  ),
                                                );

                                                setState(() {
                                                  _incorrectOtp =
                                                      false; // Reset _incorrectOtp to false
                                                });
                                              } else {
                                                // OTP length is incorrect
                                                setState(() {
                                                  _incorrectOtp =
                                                      true; // Set _incorrectOtp to true
                                                });
                                              }
                                            } else {
                                              // Validation failed
                                              clearOTPFields();
                                              setState(() {
                                                _incorrectOtp =
                                                    true; // Set _incorrectOtp to true
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/Auth_flow/verifyOTP.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_text_form_fields_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import '../../Utils/constant.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../Utils/no_space_input_formatter_class.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
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
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  bool isButtonEnabled = false;
  String? EmailError;
  bool isValidEmail(String email) {
    if (email.length > 254) {
      return false; // Email address too long
    }

    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    if (!regex.hasMatch(email)) {
      return false; // Invalid email format
    }

    List<String> parts = email.split('@');

    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return false; // Local or domain part is empty or more than one '@'
    }

    if (parts[0].length > 64) {
      return false; // Local part before '@' should not exceed 64 characters
    }

    if (parts[1].length > 255) {
      return false; // Domain part after '@' should not exceed 255 characters
    }

    // Additional domain validation to ensure the domain part is valid
    final domainParts = parts[1].split('.');
    if (domainParts.length < 2) {
      return false; // Domain must have at least one dot
    }

    for (String domainPart in domainParts) {
      if (domainPart.isEmpty || domainPart.length > 63) {
        return false; // Domain labels should not be empty or exceed 63 characters
      }
    }

    return true;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.nullEmailField;
    }

    if (!isValidEmail(value)) {
      return Constants.wrongEmailFormat;
    }

    return null;
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
              ).animateOnPageLoad(animationsMap[
              'imageOnPageLoadAnimation2']!),
            ),
          ),
        ),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is SendOTPSuccess) {
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.SendOTPResponse['responseMessage']),
                ),
              );
              // Navigate to LoginScreen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const OTPVerificationScreen()));
            } else if (state is SendOTPFailure) {

              // Dismiss the loading dialog if it's open
              Navigator.pop(context);
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.SendOTPFailureResponse['responseMessage'])
                ),
              );
            } else if (state is SendOTPLoading) {
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
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),
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
                      color: Colors.grey, // Adjust opacity as needed
                      blurRadius: 8.0,
                      spreadRadius: 0.03,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.cardBack, // Set the border color here
                    width: 1.0, // Set the border width as desired
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            Constants.forgotPasswordHeadingTxt,
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle.loginTitleStyleTablet
                                : FTextStyle.loginTitleStyle,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          color: AppColors.editTextBorderColor,
                          height: 1,
                        ),
                      ),
                       Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 10),
                        child: Text(
                          Constants.forgotPasswordSubHeadingTxt,
                          style: (displayType == 'desktop' ||
                              displayType == 'tablet')
                              ? FTextStyle.loginEmailFieldHeadingStyleTablet
                              :  FTextStyle.loginEmailFieldHeadingStyle,
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 20),
                        child: Form(
                          key: formKey,
                          onChanged: () {
                            if (formKey.currentState!.validate()) {
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  Constants.loginEmailFieldHeading,
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle.loginEmailFieldHeadingStyleTablet
                                      :  FTextStyle.loginEmailFieldHeadingStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  cursorColor: AppColors.authScreensHeading,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: TextFormFieldStyle.defaultemailInputDecoration(displayType),
                                  controller: _email,
                                  inputFormatters: [
                                    NoSpaceFormatter(),
                                    LengthLimitingTextInputFormatter(254),
                                  ],
                                  textAlign: TextAlign.start,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  onChanged: (value) {
                                    setState(() {
                                      EmailError = emailValidator(value); // Update EmailErrorText on change
                                    });
                                  },
                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                              ),

// Conditionally displaying the EmailErrorText
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Visibility(
                                  visible: EmailError != null,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5, top: 2),
                                    child: Text(
                                      EmailError ?? '',  // Show the error text if not null
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
                        padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
                        child: SizedBox(
                          width: 330,
                          height: 45,
                          child: ElevatedButton(
                            onPressed:
                            isButtonEnabled && formKey.currentState!.validate()
                                ? () {
                              PrefUtils.setUserEmail(_email.text);
                              BlocProvider.of<AuthenticationBloc>(
                                  context)
                                  .add(
                                SendOTPRequested(
                                  email: _email.text,
                                ),
                              );
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ),
                      ),
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

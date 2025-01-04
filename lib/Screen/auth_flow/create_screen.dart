import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/auth_flow/userLocation.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import 'package:health2mama/apis/social_login/social_login_bloc.dart';
import 'package:health2mama/main.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/static_screen/privacy_policy.dart';
import 'package:health2mama/Screen/static_screen/terms_and_conditions.dart';
import '../../Model/country.dart';
import '../../Utils/common_popups.dart';
import '../../Utils/constant.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../Utils/flutter_text_form_fields_style.dart';
import '../../Utils/no_space_input_formatter_class.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerFcmToken(); // Register and print the FCM token here
  }

  final formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool confirmpasswordVisible = true;
  bool checkboxChecked = false;
  bool isButtonEnabled = false;
  bool isDropdownVisible = false;
  bool isLoading = false;
  String? passwordError;
  String? developer;
  bool countrySelected = false;
  List<Result> countries = [];
  bool nameFieldFocus = false;
  String yourStage = "";
  String yourId = "";
  String? FullNameError;
  String? EmailError;
  String? PasswordError;
  String? ConfirmPasswordError;
  String? PhoneNumberError;
  String? CountryError;

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
  bool developerError = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  String? getPhoneNumberError(String value) {
    if (value.isEmpty) {
      return "Please enter your phone number.";
    } else if (value.length < 6) {
      return "Phone number must be at least 6 digits.";
    } else if (RegExp(r'^[0]+$').hasMatch(value)) {
      return "Phone number cannot be all zeros."; // Disallow phone numbers that are all zeros
    }
    return null; // Return null if there are no errors
  }


  bool isValidconfirmpass(String pass, String confirmPass) {
    if (confirmPass.length == 0 || pass != confirmPass) {
      return false;
    }
    return true;
  }

  bool isValueSelected() {
    String countryValue = _countryKey.currentState!.value.toString();
    if (countryValue.isEmpty) {
      return false;
    }
    return true;
  }

  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _nameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _confirmPasswordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _phoneKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _countryKey =
      GlobalKey<FormFieldState<String>>();
  bool isEmailFieldFocused = false;
  bool isPasswordFieldFocused = false;
  bool isNameFieldFocused = false;
  bool isConfirmpasswordFieldFocused = false;
  bool isCountryFieldFocused = false;
  bool isPhoneFieldFocused = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();

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
      return Constants.nullEmailField; // "Email field cannot be empty."
    }

    if (!isValidEmail(value)) {
      return Constants.wrongEmailFormat; // "Invalid email format."
    }

    return null;
  }

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
    //
    //
    //
    // meets all criteria
    return true;
  }

  String? getFullNameError(String value) {
    // Check if the value is null or empty
    if (value.isEmpty) {
      return "Please enter your full name.";
    }
    // Check if the length of the value is between 3 and 60 characters
    if (value.length < 3) {
      return "Name must be at least 3 characters.";
    } else if (value.length > 60) {
      return "Name cannot exceed 60 characters.";
    }

    // Check if the value contains only alphabets and spaces
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      return "Name cannot contain numeric & special characters.";
    }

    return null; // Return null if there is no error
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.90),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
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
                ),
              ),
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is SignupSuccess) {
                    isLoading = false;
                    CommonPopups.showCustomPopup(context,
                        state.SignupSuccessResponse['responseMessage']);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserLocationScreen(isSignup: true),
                        ));
                  } else if (state is SignupFailure) {
                    // Dismiss the loading dialog if it's open
                    isLoading = false;
                    Navigator.pop(context);
                    CommonPopups.showCustomPopup(context,
                        state.SignupFailureResponse['responseMessage']);
                  } else if (state is SignupLoadingState) {
                    isLoading = true;
// Show a loading indicator
//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (context) =>
//                           Center(child: CircularProgressIndicator()),
//                     );
                  } else if (state is GetAllCountriesSuccess) {
                    setState(() {
                      countries = (state.countries['result'] as List)
                          .map(
                              (e) => Result.fromJson(e as Map<String, dynamic>))
                          .toList();
                    });
                  }
                },
              ),
              BlocListener<SocialLoginBloc, SocialLoginState>(
                listener: (context, state) async {
                  if (state is GoogleLoginSuccess) {
                    var socialID = state.id;
                    var name = state.name;
                    var email = state.email;
                    var image = state.image;

                    print('User Social ID Is :$socialID');
                    print('User Name Is :$name');

                    // Split the full name into firstName and lastName
                    var nameParts = name.split(' ');
                    var firstName =
                        nameParts[0]; // First part is the first name
                    var lastName = nameParts.length > 1
                        ? nameParts.last
                        : ''; // Last part is the last name, if it exists

                    print('First Name: $firstName');
                    print('Last Name: $lastName');

                    // Get the device type asynchronously
                    String deviceType = await getDeviceInfo(
                        context); // Ensure this method is defined and returns the device type

                    // Dispatch the NodeGoogleLoginEvent with the split firstName, lastName, and deviceType
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
                  } else if (state is NodeGoogleLoginSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${state.successResponse['responseMessage']}')));
                  } else if (state is NodeGoogleLoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${state.failureMessage['responseMessage']}')));
                  } else if (state is GoogleLoginFailure) {
                    // Dismiss the loading dialog if it's open
                    Navigator.pop(context);
                    CommonPopups.showCustomPopup(
                        context, state.errorMessage['responseMessage']);
                  }
                  //apple login
                  if (state is AppleLoginSuccess) {
                    // Get the device type asynchronously
                    String deviceType = await getDeviceInfo(
                        context); // Ensure this method is defined and returns the device type

                    BlocProvider.of<SocialLoginBloc>(context).add(
                      NodeAppleLoginEvent(
                        state.id,
                        state.email,
                        'apple',
                        PrefUtils.getDeviceToken(),
                        deviceType,
                        state.name// Pass the retrieved device type
                      ),
                    );
                  } else if (state is AppleLoginError) {
                    // Dismiss the loading dialog if it's open
                    Navigator.pop(context);
                    CommonPopups.showCustomPopup(
                        context, state.errorMessage['responseMessage']);
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
                      width:
                          (displayType == 'desktop' || displayType == 'tablet')
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: Center(
                                  child: Text(
                                    Constants.createAccountHeading,
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.loginTitleStyleTablet
                                        : FTextStyle.loginTitleStyle,
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                ),
                              ),
                              const Divider(
                                color: AppColors.editTextBorderColor,
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            children: [
                              Form(
                                  onChanged: () {
                                    if (isValidEmail(_email
                                            .text) && // Check if email is valid
                                        getFullNameError(_name.text) ==
                                            null && // Check if there is no name error
                                        getPhoneNumberError(_phone.text) ==
                                            null && // Check if there is no number error
                                        isValueSelected() &&
                                        isValidconfirmpass(
                                            _password.text.toString(),
                                            _confirmPassword.text.toString()) &&
                                        isValidPass(
                                            _password.text.toString())) {
                                      setState(() {
                                        isButtonEnabled = true;
                                      });
                                    } else {
                                      setState(() {
                                        isButtonEnabled = false;
                                      });
                                    }
                                    if (isEmailFieldFocused == true) {
                                      _emailKey.currentState!.validate();
                                    }
                                    if (isPasswordFieldFocused == true) {
                                      _passwordKey.currentState!.validate();
                                    }
                                    if (isConfirmpasswordFieldFocused == true) {
                                      _confirmPasswordKey.currentState!
                                          .validate();
                                    }
                                    if (isNameFieldFocused == true) {
                                      _nameKey.currentState!.validate();
                                    }
                                    if (isPhoneFieldFocused == true) {
                                      _phoneKey.currentState!.validate();
                                    }
                                    if (isCountryFieldFocused == true) {
                                      _countryKey.currentState!.validate();
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 5, top: 2),
                                        child: Text(
                                          Constants.createAccountnameHeading,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .loginEmailFieldHeadingStyleTablet
                                              : FTextStyle
                                                  .loginEmailFieldHeadingStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          key: _nameKey,
                                          focusNode: _nameFocusNode,
                                          cursorColor:
                                              AppColors.authScreensHeading,
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.sentences,
                                          decoration: TextFormFieldStyle
                                              .defaultnameInputDecoration(
                                                  displayType),
                                          controller: _name,
                                          onChanged: (value) {
                                            // Check for leading space and remove it
                                            if (value.isNotEmpty &&
                                                value.startsWith(' ')) {
                                              // Remove leading space only
                                              _name.text = value.substring(
                                                  1); // Remove leading space
                                              // Move the cursor to the end of the text
                                              _name.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset: _name
                                                              .text.length));
                                            } else {
                                              // Update FullNameError without showing validation
                                              FullNameError =
                                                  getFullNameError(value);
                                            }
                                            isNameFieldFocused = true;
                                          },
                                          onTap: () {
                                            setState(() {
                                              isNameFieldFocused = true;
                                            });
                                          },
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Visibility(
                                          visible: FullNameError != null &&
                                              FullNameError!
                                                  .isNotEmpty, // Show only if FullNameError is not null and not empty
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 2),
                                            child: Text(
                                              FullNameError ??
                                                  '', // Display the FullNameError message
                                              style: FTextStyle
                                                  .formFieldErrorTxtStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 4),
                                        child: Text(
                                          Constants.createAccountcountryHeading,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .loginEmailFieldHeadingStyleTablet
                                              : FTextStyle
                                                  .loginEmailFieldHeadingStyle,
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ),
                                      TextFormField(
                                        key: _countryKey,
                                        focusNode: _countryFocusNode,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: isDropdownVisible
                                                  ? AppColors.boarderColour
                                                  : AppColors.boarderColour,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: AppColors
                                                  .boarderColour, // Color when the field is focused
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              borderSide: BorderSide(
                                                color: AppColors.errorColor,
                                              )),
                                          focusedErrorBorder:
                                              const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: AppColors.errorColor,
                                                  )),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: AppColors
                                                  .boarderColour, // Color when the field is not focused
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                          suffixIcon: isDropdownVisible
                                              ? Icon(
                                                  Icons.arrow_drop_up,
                                                  color: Colors.grey,
                                                  size: 30,
                                                )
                                              : Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.grey,
                                                  size: 30,
                                                ),
                                          hintText: "Enter country",
                                          hintStyle: (displayType ==
                                                      'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .loginFieldHintTextStyleTablet
                                              : FTextStyle
                                                  .loginFieldHintTextStyle,
                                          errorStyle: (displayType ==
                                                      'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .formFieldErrorTxtStyleTablet
                                              : FTextStyle
                                                  .formFieldErrorTxtStyle,
                                        ),
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: yourStage),
                                        maxLines: 1,
                                        onTap: () {
                                          BlocProvider.of<AuthenticationBloc>(
                                                  context)
                                              .add(GetAllCountriesEvent());
                                          setState(() {
                                            isDropdownVisible =
                                                !isDropdownVisible;
                                            isNameFieldFocused = false;
                                            isEmailFieldFocused = false;
                                            isCountryFieldFocused = true;
                                            isConfirmpasswordFieldFocused =
                                                false;
                                            isPhoneFieldFocused = false;
                                            isPasswordFieldFocused = false;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return Constants
                                                .chooseAnOptionError;
                                          } else {
                                            return null;
                                          }
                                        },
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Visibility(
                                        visible: isDropdownVisible,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 35),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: AppColors.lightGreyColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5)),
                                          ),
                                          child: SizedBox(
                                            height: 200,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children:
                                                        countries.map((stage) {
                                                      int index = countries.indexOf(
                                                          stage); // Get the index of the current stage
                                                      return Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                yourStage =
                                                                    stage.name!;
                                                                yourId = stage
                                                                    .isoCode!;
                                                                print(
                                                                    "id>>>>>>>$yourId");
                                                                for (var element
                                                                    in countries) {
                                                                  if (element
                                                                          .name ==
                                                                      yourStage) {
                                                                    element.selected =
                                                                        true;
                                                                  } else {
                                                                    element.selected =
                                                                        false;
                                                                  }
                                                                }
                                                              });
                                                              Future.delayed(
                                                                  const Duration(
                                                                      microseconds:
                                                                          1500),
                                                                  () {
                                                                setState(() {
                                                                  isDropdownVisible =
                                                                      !isDropdownVisible;
                                                                });
                                                              });
                                                            },
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      yourStage =
                                                                          stage
                                                                              .name!;
                                                                      yourId = stage
                                                                          .isoCode!;
                                                                      print(
                                                                          "id>>>>>>>$yourId");
                                                                      for (var element
                                                                          in countries) {
                                                                        if (element.name ==
                                                                            yourStage) {
                                                                          element.selected =
                                                                              true;
                                                                        } else {
                                                                          element.selected =
                                                                              false;
                                                                        }
                                                                      }
                                                                    });
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            microseconds:
                                                                                1500),
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        isDropdownVisible =
                                                                            !isDropdownVisible;
                                                                      });
                                                                    });
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          24, // Adjust the width as needed
                                                                      height:
                                                                          24, // Adjust the height as needed
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(3), // Adjust the radius as needed
                                                                        border:
                                                                            Border.all(
                                                                          color: stage.selected == true
                                                                              ? AppColors.primaryColorPink
                                                                              : AppColors.boarderColour,
                                                                          width:
                                                                              1.5, // Adjust the width as needed
                                                                        ),
                                                                        color: stage.selected ==
                                                                                true
                                                                            ? AppColors.primaryColorPink
                                                                            : Colors.white,
                                                                      ),
                                                                      child: stage.selected ==
                                                                              true
                                                                          ? const Icon(
                                                                              Icons.check_box,
                                                                              color: Colors.white,
                                                                              size: 24,
                                                                            )
                                                                          : null, // No icon when unselected
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    stage.name
                                                                        .toString(),
                                                                    maxLines: 3,
                                                                    style: FTextStyle
                                                                        .rememberMeTextStyle,
                                                                  ).animateOnPageLoad(
                                                                      animationsMap[
                                                                          'imageOnPageLoadAnimation2']!),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
// Add divider conditionally except for the last item
                                                          if (index !=
                                                              countries.length -
                                                                  1)
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 15,
                                                                      bottom:
                                                                          10),
                                                              child: Divider(
                                                                color: AppColors
                                                                    .darkGreyColor,
                                                                height: 0.5,
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 10),
                                        child: Text(
                                          Constants.createAccountphoneHeading,
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
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          key: _phoneKey,
                                          focusNode: _phoneFocusNode,
                                          cursorColor:
                                              AppColors.authScreensHeading,
                                          keyboardType: TextInputType.number,
                                          decoration: TextFormFieldStyle
                                              .defaultphoneInputDecoration(
                                                  displayType),
                                          controller: _phone,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                15), // Limit to 15 characters
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Allow only digits
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              PhoneNumberError =
                                                  getPhoneNumberError(
                                                      value); // Update error message
                                              isPhoneFieldFocused =
                                                  true; // Track focus state
                                            });
                                          },
                                          onTap: () {
                                            setState(() {
                                              isNameFieldFocused = false;
                                              isEmailFieldFocused = false;
                                              isCountryFieldFocused = false;
                                              isConfirmpasswordFieldFocused =
                                                  false;
                                              isPhoneFieldFocused = true;
                                              isPasswordFieldFocused = false;
                                            });
                                          },
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Visibility(
                                          visible: PhoneNumberError != null,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 2),
                                            child: Text(
                                              PhoneNumberError ?? '',
                                              style: FTextStyle
                                                  .formFieldErrorTxtStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 4),
                                        child: Text(
                                          Constants.loginEmailFieldHeading,
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
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          key: _emailKey,
                                          focusNode: _emailFocusNode,
                                          cursorColor:
                                              AppColors.authScreensHeading,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: TextFormFieldStyle
                                              .defaultemailInputDecoration(
                                                  displayType),
                                          inputFormatters: [
                                            NoSpaceFormatter(),
                                            LengthLimitingTextInputFormatter(
                                                254),
                                          ],
                                          controller: _email,
                                          onChanged: (value) {
                                            setState(() {
                                              // Perform validation and update EmailError accordingly
                                              if (value.isEmpty) {
                                                EmailError =
                                                    "Please enter your email address.";
                                              } else if (!isValidEmail(value)) {
                                                EmailError =
                                                    "Please enter a valid email address.";
                                              } else {
                                                EmailError = null; // No error
                                              }
                                            });
                                          },
                                          onTap: () {
                                            setState(() {
                                              isNameFieldFocused = false;
                                              isEmailFieldFocused = true;
                                              isCountryFieldFocused = false;
                                              isConfirmpasswordFieldFocused =
                                                  false;
                                              isPhoneFieldFocused = false;
                                              isPasswordFieldFocused = false;
                                            });
                                          },
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Visibility(
                                          visible: EmailError != null,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 2),
                                            child: Text(
                                              EmailError ?? '',
                                              style: FTextStyle
                                                  .formFieldErrorTxtStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 4),
                                        child: Text(
                                          "Password*",
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
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              key: _passwordKey,
                                              focusNode: _passwordFocusNode,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .editTextBorderColorenabled,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .editTextBorderColorenabled,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .editTextBorderColorfocused,
                                                  ),
                                                ),
                                                errorBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors.errorColor,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors.errorColor,
                                                  ),
                                                ),
                                                hintText: Constants
                                                    .loginPasswordFieldHintText,
                                                hintStyle: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .loginFieldHintTextStyleTablet
                                                    : FTextStyle
                                                        .loginFieldHintTextStyle,
                                                errorStyle: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .formFieldErrorTxtStyleTablet
                                                    : FTextStyle
                                                        .formFieldErrorTxtStyle,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      passwordVisible =
                                                          !passwordVisible;
                                                    });
                                                  },
                                                  child: Icon(
                                                    passwordVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: AppColors
                                                        .authScreensHeading,
                                                  ),
                                                ),
                                              ),
                                              cursorColor:
                                                  AppColors.authScreensHeading,
                                              keyboardType: TextInputType.text,
                                              controller: _password,
                                              obscureText:
                                                  !passwordVisible, // Invert to hide the password
                                              inputFormatters: [
                                                NoSpaceFormatter(),
                                                LengthLimitingTextInputFormatter(
                                                    60),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  // Validate and update the error message dynamically based on password conditions
                                                  if (value.isEmpty) {
                                                    passwordError =
                                                        Constants.nullField;
                                                  } else if (value.length < 8) {
                                                    passwordError =
                                                        Constants.lengtherror;
                                                  } else if (!value.contains(
                                                      RegExp(r'[A-Z]'))) {
                                                    passwordError = Constants
                                                        .uppercaseError;
                                                  } else if (!value.contains(
                                                      RegExp(r'[a-z]'))) {
                                                    passwordError = Constants
                                                        .lowercaseError;
                                                  } else if (!value.contains(
                                                      RegExp(r'[0-9]'))) {
                                                    passwordError =
                                                        Constants.numberError;
                                                  } else if (!value.contains(RegExp(
                                                      r'[!@#$%^&*(),.?":{}|<>]'))) {
                                                    passwordError = Constants
                                                        .specialChaacterError;
                                                  } else {
                                                    passwordError =
                                                        null; // No error, clear the message
                                                  }
                                                });
                                              },
                                              onTap: () {
                                                setState(() {
                                                  // Update focus state for different fields as needed
                                                  isNameFieldFocused = false;
                                                  isEmailFieldFocused = false;
                                                  isCountryFieldFocused = false;
                                                  isConfirmpasswordFieldFocused =
                                                      false;
                                                  isPhoneFieldFocused = false;
                                                  isPasswordFieldFocused = true;
                                                });
                                              },
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: Visibility(
                                                visible: passwordError !=
                                                        null &&
                                                    passwordError!.isNotEmpty,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5, top: 5),
                                                  child: Text(
                                                    passwordError ?? '',
                                                    style: FTextStyle
                                                        .formFieldErrorTxtStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 5, top: 4),
                                        child: Text(
                                          Constants.confirmPasswordText,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .loginEmailFieldHeadingStyleTablet
                                              : FTextStyle
                                                  .loginEmailFieldHeadingStyle,
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              key: _confirmPasswordKey,
                                              focusNode:
                                                  _confirmPasswordFocusNode,
                                              cursorColor:
                                                  AppColors.authScreensHeading,
                                              keyboardType: TextInputType.text,
                                              obscureText:
                                                  confirmpasswordVisible,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .editTextBorderColorenabled,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .editTextBorderColorenabled,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .editTextBorderColorfocused,
                                                  ),
                                                ),
                                                errorBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors.errorColor,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                    color: AppColors.errorColor,
                                                  ),
                                                ),
                                                hintText: Constants
                                                    .loginPasswordFieldHintText,
                                                hintStyle: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .loginFieldHintTextStyleTablet
                                                    : FTextStyle
                                                        .loginFieldHintTextStyle,
                                                errorStyle: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .formFieldErrorTxtStyleTablet
                                                    : FTextStyle
                                                        .formFieldErrorTxtStyle,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      confirmpasswordVisible =
                                                          !confirmpasswordVisible;
                                                    });
                                                  },
                                                  child: Icon(
                                                    confirmpasswordVisible
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: AppColors
                                                        .authScreensHeading,
                                                  ),
                                                ),
                                              ),
                                              controller: _confirmPassword,
                                              inputFormatters: [
                                                NoSpaceFormatter(),
                                                LengthLimitingTextInputFormatter(
                                                    60),
                                              ],
                                              textAlign: TextAlign.start,
                                              onChanged: (value) {
                                                setState(() {
                                                  // Validate confirm password
                                                  if (value.isEmpty) {
                                                    ConfirmPasswordError =
                                                        Constants.nullField;
                                                  } else if (value !=
                                                      _password.text) {
                                                    ConfirmPasswordError =
                                                        Constants
                                                            .confirmPassError;
                                                  } else {
                                                    ConfirmPasswordError =
                                                        null; // Clear error if passwords match
                                                  }
                                                });
                                              },
                                              onTap: () {
                                                setState(() {
                                                  isNameFieldFocused = false;
                                                  isEmailFieldFocused = false;
                                                  isCountryFieldFocused = false;
                                                  isConfirmpasswordFieldFocused =
                                                      true;
                                                  isPhoneFieldFocused = false;
                                                  isPasswordFieldFocused =
                                                      false;
                                                });
                                              },
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),

                                            // Error Message Display
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 10),
                                              child: Visibility(
                                                visible: ConfirmPasswordError !=
                                                        null &&
                                                    ConfirmPasswordError!
                                                        .isNotEmpty,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                  child: Text(
                                                    ConfirmPasswordError ?? '',
                                                    style: FTextStyle
                                                        .formFieldErrorTxtStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                    ],
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          checkboxChecked = !checkboxChecked;
                                        });
                                      },
                                      child: IconTheme(
                                          data: const IconThemeData(
                                              color:
                                                  AppColors.primaryColorPink,
                                              weight: 10),
                                          child: Icon(checkboxChecked
                                              ? Icons.check_box
                                              : Icons
                                                  .check_box_outline_blank)),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            Constants.tnc1,
                                            style: (displayType == 'desktop' ||
                                                    displayType == 'tablet')
                                                ? FTextStyle
                                                    .rememberMeTextStyleTablet
                                                : FTextStyle
                                                    .rememberMeTextStyle,
                                          ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TermsCondition()),
                                              );
                                            },
                                            child: Text(
                                              Constants.tnc2,
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .getStartedTxtStyleTablet
                                                  : FTextStyle
                                                      .getStartedTxtStyle,
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                          ),
                                          Text(
                                            Constants.tnc3,
                                            style: (displayType == 'desktop' ||
                                                    displayType == 'tablet')
                                                ? FTextStyle
                                                    .rememberMeTextStyleTablet
                                                : FTextStyle
                                                    .rememberMeTextStyle,
                                          ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PrivacyPolicy()),
                                          );
                                        },
                                        child: Text(
                                          Constants.tnc4,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .getStartedTxtStyleTablet
                                              : FTextStyle.getStartedTxtStyle,
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: SizedBox(
                                    width: width,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: isButtonEnabled &&
                                              checkboxChecked
                                          ? () async {
                                              // Get the device type asynchronously
                                              String deviceType =
                                                  await getDeviceInfo(context);

                                              // Add the SignupRequested event to the bloc
                                              BlocProvider.of<
                                                          AuthenticationBloc>(
                                                      context)
                                                  .add(
                                                SignupRequested(
                                                  fullName: _name.text,
                                                  country: yourStage,
                                                  countryCode: yourId,
                                                  phoneNumber: _phone.text,
                                                  email: _email.text,
                                                  password: _password.text,
                                                  deviceToken: PrefUtils
                                                      .getDeviceToken(),
                                                  deviceType: deviceType,
                                                ),
                                              );
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                              Constants.signupBtnTxt,
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .loginBtnStyleTablet
                                                  : FTextStyle.loginBtnStyle,
                                            ),
                                    )),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Constants
                                                    .alreadyHaveAnAccountTxt,
                                                style: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .rememberMeTextStyleTablet
                                                    : FTextStyle
                                                        .rememberMeTextStyle,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                },
                                                child: Text(
                                                  Constants.login,
                                                  style: (displayType ==
                                                              'desktop' ||
                                                          displayType ==
                                                              'tablet')
                                                      ? FTextStyle
                                                          .getStartedTxtStyleTablet
                                                      : FTextStyle
                                                          .getStartedTxtStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              Constants.orTxt,
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .subtitleTxtStyleTablet
                                                  : FTextStyle.subtitleTxtStyle,
                                            ),
                                          ),
                                        ],
                                      ))
                                  .animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Visibility(
                                    visible: Platform.isIOS,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<SocialLoginBloc>(
                                                  context)
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
                                        BlocProvider.of<SocialLoginBloc>(
                                                context)
                                            .add(GoogleLoginEventHandler());
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
                  )
                ],
              ),
            ),
          )),
    );
  }
}

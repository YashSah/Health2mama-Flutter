import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/constant.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/flutter_text_form_fields_style.dart';
import 'package:health2mama/Utils/no_space_input_formatter_class.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/drawer/drawer_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../Model/country.dart';
import '../../apis/auth_flow/authentication_event.dart';

class EditScreen extends StatefulWidget {
  final String fullName;
  final String country;
  final String phone;
  final String emailAddress;
  final List otherthanmum;
  final List languages;
  final List exercises;
  final List other;
  final String havekids;
  final String ageBracket;
  final String countryCode;
  List<int> profileImage;

  EditScreen({
    super.key,
    required this.fullName,
    required this.country,
    required this.phone,
    required this.emailAddress,
    required this.otherthanmum,
    required this.languages,
    required this.exercises,
    required this.other,
    required this.havekids,
    required this.ageBracket,
    required this.countryCode,
    required this.profileImage,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _countryFocusNode = FocusNode();
  bool passwordVisible = true;
  bool confirmpasswordVisible = true;
  bool checkboxChecked = false;
  bool isDropdownVisible = false;
  bool isDropdownVisible1 = false;
  bool isDropdownVisible2 = false;
  bool isDropdownVisible3 = false;
  bool isDropdownVisible4 = false;
  bool isDropdownVisible5 = false;
  String? FullNameError;
  String? CountryRegionError;
  String? PhoneError;
  File? _image;
  String cameraSelectedImage = '';
  String gallerySelectedImage = '';
  String selectionImageType = '';
  final ImagePicker _imagePicker = ImagePicker();
  String? userImage = '';
  var isRemarkEnabled = true;
  var selfiImgBase64 = '';
  var selfiImg = '';
  var profileUpdate = false;
  List<int> profileImage = [];
  List<int> Images = [];
  String yourStage = "";
  String countryCode = "";
  String yourId = "";
  List<String> selectedothermumOption = [];
  List<String> selectedLanguages = [];
  List<String> selectedexercises = [];
  List<String> selectedOthers = [];
  List<Result> countries = [];
  String selectedAge = '';
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController othermum = TextEditingController();
  final TextEditingController languages = TextEditingController();
  final TextEditingController exercises = TextEditingController();
  final TextEditingController other = TextEditingController();
  final TextEditingController havekids = TextEditingController();
  final TextEditingController ageBracket = TextEditingController();
  late Uint8List _imageBytes; // To store the image bytes
  final formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values from the widget
    _name.text = widget.fullName;
    _phone.text = widget.phone;
    _email.text = widget.emailAddress;
    othermum.text = widget.otherthanmum.join(', ');
    languages.text = widget.languages.join(', ');
    exercises.text = widget.exercises.join(', ');
    other.text = widget.other.join(', ');
    havekids.text = widget.havekids;
    ageBracket.text = widget.ageBracket;
    yourStage = widget.country;
    countryCode = widget.countryCode;
    // Assign the List<int> to _imageBytes
    _imageBytes = Uint8List.fromList(widget.profileImage);

    _imagePath = "assets/Images/editProfile.png";
    BlocProvider.of<DrawerBloc>(context).add(GetOptionsEvent());
    print("Social Login Status Is: ${PrefUtils.getIsSocialLogin()}");
  }

  late String _imagePath;

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
      return "Please enter your email address.";
    }

    if (!isValidEmail(value)) {
      return "Please enter a valid email address.";
    }

    return null;
  }

  bool countrySelected = false;

// Declare a boolean variable to track the focus state of form fields
  bool nameFieldFocus = false;

  bool isValidphone(String value) {
    // Check if the phone number is null or empty
    if (value == null || value.isEmpty) {
      return false;
    }

    // Check if the length of the phone number is at least 8 digits
    if (value.length < 8) {
      return false;
    }

    // Check if the phone number is not made up entirely of zeroes
    if (RegExp(r'^0+$').hasMatch(value)) {
      return false;
    }

    return true;
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
    return true; // Return false if no stage is selected
  }

  GlobalKey<FormFieldState<String>> _emailKey =
  GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _passwordKey =
  GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _nameKey =
  GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _confirmPasswordKey =
  GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _phoneKey =
  GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _countryKey =
  GlobalKey<FormFieldState<String>>();
  bool isEmailFieldFocused = false;
  bool isPasswordFieldFocused = false;
  bool isNameFieldFocused = false;
  bool isConfirmpasswordFieldFocused = false;
  bool isCountryFieldFocused = false;
  bool isPhoneFieldFocused = false;
  int openedDropdownIndex = -1; // -1 indicates no dropdown is open
  bool isLoading = false;
  bool _isButtonEnabled = false;
  void _validateForm() {
    setState(() {
      _isButtonEnabled = _name.text.isNotEmpty &&
          _phone.text.isNotEmpty &&
          countryCode.isNotEmpty &&
          isValidphone(_phone.text) && // Add a phone validation function if needed
          isValidname(_name.text); // Add a name validation function if needed
    });
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
// Password meets all criteria
    return true;
  }

  bool isValidname(String value) {
// Check if the value is null or empty
    if (value == null || value.isEmpty) {
      return false;
    }
// Check if the full name has at least two parts (first name and last name)
    if (value.trim().split(' ').length < 2) {
      return false;
    }
// Check if the length of the full name is between 3 and 60 characters
    if (value.length < 3 || value.length > 60) {
      return false;
    }
// The full name is valid
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Edit Account",
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
                    ? 24.w
                    : 24, // Set width as needed
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 24.h
                    : 24, // Set height as needed
              ),
            ),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is GetAllCountriesSuccess) {
                  setState(() {
                    countries = (state.countries['result'] as List)
                        .map((e) => Result.fromJson(e as Map<String, dynamic>))
                        .toList();
                  });
                }
              },
            ),
            BlocListener<DrawerBloc, DrawerState>(
              listener: (context, state) {
                if (state is UpdateProfileLoading) {
                  Center(child: CircularProgressIndicator(color: AppColors.pink));
                } else if (state is UpdateProfileLoaded) {
                  CommonPopups.showCustomPopup(
                      context, 'Profile updated successfully.');
                } else if (state is UpdateProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.failureResponse['responseMessage'])));
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            child: Padding(
              padding: (displayType == 'desktop' || displayType == 'tablet')
                  ? EdgeInsets.symmetric(
                horizontal: 25.w,
              )
                  : EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    thickness: 1.2,
                    color: Color(0XFFF6F6F6),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 10.w
                            : 0),
                    child: Text(
                      "General Details",
                      style:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? FTextStyle.generalTablet
                          : FTextStyle.general,
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                  ),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 20.0, 0.0, 20.0),
                      child: (profileImage.isNotEmpty && !profileUpdate)
                          ? Stack(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? 70.w
                                    : 100,
                                width: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? 70.w
                                    : 100,
                                child: profileImage.isNotEmpty
                                    ? Image.memory(
                                  Uint8List.fromList(profileImage),
                                  fit: BoxFit
                                      .cover, // Adjust the fit based on your requirements
                                )
                                    : null,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: profileImage.isNotEmpty,
                            child: Positioned(
                              bottom: 0,
                              left: 10,
                              right: 10,
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _image = null;
                                      profileUpdate = true;
                                    });
                                  },
                                  child: Container(
                                    width: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? 20.w
                                        : 75,
                                    height: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? 20.w
                                        : 25,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFB98F),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          color: Colors.black,
                                          size: (displayType ==
                                              'desktop' ||
                                              displayType == 'tablet')
                                              ? 10.w
                                              : 10.0,
                                        ),
                                        Text(
                                          'Remove',
                                          style: TextStyle(
                                              fontSize: (displayType ==
                                                  'desktop' ||
                                                  displayType ==
                                                      'tablet')
                                                  ? 12.sp
                                                  : 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : Stack(
                        children: [
                          Center(
                            child: InkWell(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/Images/editProfile.png",
                                      fit: BoxFit.cover,
                                      height: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? 70.w
                                          : 100,
                                      width: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? 70.w
                                          : 100,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      )),





                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 10.w
                            : 10,
                        horizontal: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 10.w
                            : 15),
                    child: Column(
                      children: [
                        Form(
                            onChanged: () {
                              if (isValidEmail(_email.text) &&
                                  isValidname(_name.text) &&
                                  isValidphone(_phone.text.toString()) &&
                                  isValueSelected()) {
                              } else {}
                              if (isEmailFieldFocused == true) {
                                _emailKey.currentState!.validate();
                              }
                              if (isPasswordFieldFocused == true) {
                                _passwordKey.currentState!.validate();
                              }
                              if (isConfirmpasswordFieldFocused == true) {
                                _confirmPasswordKey.currentState!.validate();
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
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
                                TextFormField(
                                  key: _nameKey,
                                  focusNode: _nameFocusNode,
                                  cursorColor: AppColors.authScreensHeading,
                                  keyboardType: TextInputType.text,
                                  decoration: TextFormFieldStyle.defaultnameInputDecoration(displayType),
                                  controller: _name,
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .tablettextfieldTextStyle
                                      : FTextStyle
                                      .mobileTextFieldStyle,
                                  onChanged: (value) {
                                    _validateForm();
                                    setState(() {
                                      if (value.isEmpty) {
                                        FullNameError = "Please enter your full name.";
                                      } else if (value.length < 3) {
                                        FullNameError = "Name must be at least 3 characters.";
                                      } else if (value.length > 100) {
                                        FullNameError = "Name cannot exceed 100 characters.";
                                      } else {
                                        FullNameError = null; // No error if valid
                                      }
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      isNameFieldFocused = true;
                                      isEmailFieldFocused = false;
                                      isCountryFieldFocused = false;
                                      isConfirmpasswordFieldFocused = false;
                                      isPhoneFieldFocused = false;
                                      isPasswordFieldFocused = false;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5,top: 5),
                                  child: Visibility(
                                    visible: FullNameError != null && FullNameError!.isNotEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5, top: 2),
                                      child: Text(
                                        FullNameError ?? '', // Display the FullNameError message
                                        style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                            ? FTextStyle
                                            .tabletErrorStyle
                                            : FTextStyle
                                            .formFieldErrorTxtStyle,
                                      ),
                                    ),
                                  ),
                                ),



                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    key: _countryKey,
                                    focusNode: _countryFocusNode,
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .tablettextfieldTextStyle
                                        : FTextStyle
                                        .mobileTextFieldStyle,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(color: AppColors.errorColor),
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(color: AppColors.errorColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      suffixIcon: openedDropdownIndex == 0
                                          ? Icon(Icons.arrow_drop_up, color: Colors.grey, size: 24)
                                          : Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                                      hintText: "Enter country",
                                      hintStyle: FTextStyle.loginFieldHintTextStyle,
                                      errorStyle: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                    readOnly: true,
                                    controller: TextEditingController(text: yourStage),
                                    maxLines: 1,
                                    onTap: () {
                                      setState(() {
                                        // If the clicked dropdown is already open, close it; otherwise, open it
                                        if (openedDropdownIndex == 0) {
                                          openedDropdownIndex = -1; // Close
                                        } else {
                                          openedDropdownIndex = 0; // Open this dropdown
                                        }
                                        BlocProvider.of<AuthenticationBloc>(context).add(GetAllCountriesEvent());
                                        isDropdownVisible = !isDropdownVisible;
                                        isNameFieldFocused = false;
                                        isEmailFieldFocused = false;
                                        isCountryFieldFocused = true;
                                        isConfirmpasswordFieldFocused = false;
                                        isPhoneFieldFocused = false;
                                        isPasswordFieldFocused = false;
                                      });
                                    },
                                    // No validator for now since we will handle error display separately
                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                ),
                                Visibility(
                                  visible: openedDropdownIndex == 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: AppColors.lightGreyColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: countries.map((stage) {
                                                return Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _validateForm();
                                                          yourStage = stage.name!;
                                                          countryCode = stage.countryCode!;
                                                          print('Selected Country Code Is: $countryCode');
                                                          // Set selected state for each stage
                                                          for (var element in countries) {
                                                            element.selected = element.name == yourStage;
                                                          }
                                                          // Close dropdown after selection
                                                          openedDropdownIndex = -1;
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 8.0),
                                                              child: Container(
                                                                width: 24,
                                                                height: 24,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(3),
                                                                  border: Border.all(
                                                                    color: stage.selected == true
                                                                        ? AppColors.primaryColorPink
                                                                        : AppColors.boarderColour,
                                                                    width: 1.5,
                                                                  ),
                                                                  color: stage.selected == true
                                                                      ? AppColors.primaryColorPink
                                                                      : Colors.white,
                                                                ),
                                                                child: stage.selected == true
                                                                    ? const Icon(Icons.check_box, color: Colors.white, size: 24)
                                                                    : null,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              stage.name.toString(),
                                                              maxLines: 3,
                                                              style: FTextStyle.rememberMeTextStyle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Divider
                                                    if (countries.indexOf(stage) != countries.length - 1)
                                                      const Padding(
                                                        padding: EdgeInsets.only(top: 15, bottom: 10),
                                                        child: Divider(
                                                          color: AppColors.darkGreyColor,
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
                                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                                  child: Visibility(
                                    visible: (yourStage == null || yourStage.isEmpty) ||
                                        (CountryRegionError != null && CountryRegionError!.isNotEmpty),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5, top: 2),
                                      child: Text(
                                        (yourStage == null || yourStage.isEmpty)
                                            ? "Please select country / region."
                                            : CountryRegionError ?? '', // Display the FullNameError message if it exists
                                        style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                            ? FTextStyle
                                            .tabletErrorStyle
                                            : FTextStyle
                                            .formFieldErrorTxtStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
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
                                TextFormField(
                                  key: _phoneKey,
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .tablettextfieldTextStyle
                                      : FTextStyle
                                      .mobileTextFieldStyle,
                                  focusNode: _phoneFocusNode,
                                  cursorColor: AppColors.authScreensHeading,
                                  keyboardType: TextInputType.number,
                                  decoration: TextFormFieldStyle.defaultphoneInputDecoration(displayType),
                                  controller: _phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15), // Limit to 15 characters
                                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                  ],
                                  onChanged: (value) {
                                    _validateForm();
                                    setState(() {
                                      if (value.isEmpty) {
                                        PhoneError = Constants.emptyPhoneFieldError;
                                      } else if (value.length < 8) {
                                        PhoneError = Constants.minLengthVoilationPhoneFieldError;
                                      } else if (RegExp(r'^0+$').hasMatch(value)) {
                                        PhoneError = Constants.allZeroPhoneNumberError;
                                      } else {
                                        PhoneError = null; // Clear error if valid
                                      }
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      isNameFieldFocused = false;
                                      isEmailFieldFocused = false;
                                      isCountryFieldFocused = false;
                                      isConfirmpasswordFieldFocused = false;
                                      isPhoneFieldFocused = true;
                                      isPasswordFieldFocused = false;
                                    });
                                  },
                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                                  child: Visibility(
                                    visible: PhoneError != null && PhoneError!.isNotEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5, top: 2),
                                      child: Text(
                                        PhoneError ?? '', // Display the PhoneError message
                                        style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                            ? FTextStyle
                                            .tabletErrorStyle
                                            : FTextStyle
                                            .formFieldErrorTxtStyle,
                                      ),
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: !PrefUtils.getIsSocialLogin(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
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
                                ),
                                Visibility(
                                  visible: !PrefUtils.getIsSocialLogin(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      readOnly: true,
                                      key: _emailKey,
                                      style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle
                                          .tablettextfieldTextStyle
                                          : FTextStyle
                                          .mobileTextFieldStyle,
                                      focusNode: _emailFocusNode,
                                      cursorColor: AppColors.authScreensHeading,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: TextFormFieldStyle
                                          .defaultemailInputDecoration(
                                          displayType),
                                      inputFormatters: [NoSpaceFormatter()],
                                      controller: _email,
                                      validator: emailValidator,
                                      onTap: () {
                                        setState(() {
                                          isNameFieldFocused = false;
                                          isCountryFieldFocused = false;
                                          isConfirmpasswordFieldFocused = false;
                                          isPhoneFieldFocused = false;
                                          isPasswordFieldFocused = false;
                                        });
                                      },
                                    ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    Constants.otherwork,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .tablettextfieldTextStyle
                                        : FTextStyle
                                        .mobileTextFieldStyle,
                                    controller: othermum,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour, // Color when the field is focused
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour, // Color when the field is not focused
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      suffixIcon: openedDropdownIndex == 1
                                          ? Icon(Icons.arrow_drop_up, color: Colors.grey, size: 24)
                                          : Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                                      hintText: "Select option", // Set hint text
                                      hintStyle: FTextStyle.loginFieldHintTextStyle, // Set hint style
                                      errorStyle: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                    readOnly: true, // Making it read-only to show the selected value
                                    maxLines: 1,
                                    onTap: () {
                                      setState(() {
                                        // Close all other dropdowns and open this one
                                        openedDropdownIndex = (openedDropdownIndex == 1) ? -1 : 1; // Toggle
                                      });
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                                BlocBuilder<DrawerBloc, DrawerState>(
                                  builder: (context, state) {
                                    if (state is OptionsDataLoaded) {
                                      return Visibility(
                                        visible: openedDropdownIndex == 1, // Show this dropdown if openedDropdownIndex is 1
                                        child: IntrinsicHeight(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: state.optionsData['OTHERTHANMUM']!.map((option) {
                                                final bool isSelected = selectedothermumOption.contains(option);

                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            // Update selected options
                                                            if (isSelected) {
                                                              selectedothermumOption.remove(option);
                                                            } else {
                                                              selectedothermumOption.add(option);
                                                            }

                                                            // Update the TextFormField with selected options
                                                            String displayText = selectedothermumOption.join(", ");
                                                            if (displayText.length > 35) {
                                                              displayText = displayText.substring(0, 35) + "...";
                                                            }
                                                            othermum.text = displayText; // Update the TextFormField
                                                            print("Selected options: $selectedothermumOption");
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 24,
                                                                height: 24,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(3),
                                                                  border: Border.all(
                                                                    color: isSelected
                                                                        ? AppColors.primaryColorPink
                                                                        : AppColors.boarderColour,
                                                                    width: 1.5,
                                                                  ),
                                                                  color: isSelected
                                                                      ? AppColors.primaryColorPink
                                                                      : Colors.white,
                                                                ),
                                                                child: isSelected
                                                                    ? const Icon(
                                                                  Icons.check_box,
                                                                  color: Colors.white,
                                                                  size: 24,
                                                                )
                                                                    : null,
                                                              ),
                                                              const SizedBox(width: 8),
                                                              Text(option),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (state is OptionsDataError) {
                                      return Text(state.message);
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    Constants.languages,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    controller: languages,
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .tablettextfieldTextStyle
                                        : FTextStyle
                                        .mobileTextFieldStyle,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour, // Color when the field is focused
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour, // Color when the field is not focused
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      suffixIcon: openedDropdownIndex == 2
                                          ? Icon(Icons.arrow_drop_up, color: Colors.grey, size: 24)
                                          : Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                                      hintText: "Select language",
                                      hintStyle: FTextStyle.loginFieldHintTextStyle,
                                      errorStyle: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                    readOnly: true,
                                    maxLines: 1,
                                    onTap: () {
                                      setState(() {
                                        // Set the current dropdown index to 2 (for this dropdown) and close others
                                        openedDropdownIndex = (openedDropdownIndex == 2) ? -1 : 2;
                                      });
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                                BlocBuilder<DrawerBloc, DrawerState>(
                                  builder: (context, state) {
                                    if (state is OptionsDataLoaded) {
                                      return Visibility(
                                        visible: openedDropdownIndex == 2, // Show this dropdown if openedDropdownIndex is 2
                                        child: IntrinsicHeight(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: state.optionsData['LANGUAGE']!.map((option) {
                                                final bool isSelected = selectedLanguages.contains(option);

                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            // Add or remove the option from the selected languages list
                                                            if (isSelected) {
                                                              selectedLanguages.remove(option);
                                                            } else {
                                                              selectedLanguages.add(option);
                                                            }

                                                            // Update the TextFormField with selected languages
                                                            String displayText = selectedLanguages.join(", ");
                                                            if (displayText.length > 35) {
                                                              displayText = displayText.substring(0, 35) + "...";
                                                            }
                                                            languages.text = displayText;
                                                            print("Selected Languages: $selectedLanguages");
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 24,
                                                                height: 24,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(3),
                                                                  border: Border.all(
                                                                    color: isSelected
                                                                        ? AppColors.primaryColorPink
                                                                        : AppColors.boarderColour,
                                                                    width: 1.5,
                                                                  ),
                                                                  color: isSelected
                                                                      ? AppColors.primaryColorPink
                                                                      : Colors.white,
                                                                ),
                                                                child: isSelected
                                                                    ? const Icon(
                                                                  Icons.check_box,
                                                                  color: Colors.white,
                                                                  size: 24,
                                                                )
                                                                    : null,
                                                              ),
                                                              const SizedBox(width: 8),
                                                              Text(option),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (state is OptionsDataError) {
                                      return Text(state.message);
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    Constants.exercise,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .tablettextfieldTextStyle
                                        : FTextStyle
                                        .mobileTextFieldStyle,
                                    controller: exercises,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour, // Color when the field is focused
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour, // Color when the field is not focused
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      suffixIcon: openedDropdownIndex == 3
                                          ? Icon(Icons.arrow_drop_up, color: Colors.grey, size: 24)
                                          : Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                                      hintText: "Select exercise",
                                      hintStyle: FTextStyle.loginFieldHintTextStyle,
                                      errorStyle: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                    readOnly: true,
                                    maxLines: 1,
                                    onTap: () {
                                      setState(() {
                                        // Set openedDropdownIndex to 3 for this dropdown, and close others
                                        openedDropdownIndex = (openedDropdownIndex == 3) ? -1 : 3;
                                      });
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                                BlocBuilder<DrawerBloc, DrawerState>(
                                  builder: (context, state) {
                                    if (state is OptionsDataLoaded) {
                                      return Visibility(
                                        visible: openedDropdownIndex == 3, // Show this dropdown if openedDropdownIndex is 3
                                        child: IntrinsicHeight(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: state.optionsData['EXERCISE']!.map((option) {
                                                final bool isSelected = selectedexercises.contains(option);

                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            // Add or remove the option from the selected exercises list
                                                            if (isSelected) {
                                                              selectedexercises.remove(option);
                                                            } else {
                                                              selectedexercises.add(option);
                                                            }

                                                            // Update the TextFormField with selected exercises
                                                            String displayText = selectedexercises.join(", ");
                                                            if (displayText.length > 35) {
                                                              displayText = displayText.substring(0, 35) + "...";
                                                            }
                                                            exercises.text = displayText;
                                                            print("Selected Exercises: $selectedexercises");
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 24,
                                                                height: 24,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(3),
                                                                  border: Border.all(
                                                                    color: isSelected
                                                                        ? AppColors.primaryColorPink
                                                                        : AppColors.boarderColour,
                                                                    width: 1.5,
                                                                  ),
                                                                  color: isSelected
                                                                      ? AppColors.primaryColorPink
                                                                      : Colors.white,
                                                                ),
                                                                child: isSelected
                                                                    ? const Icon(
                                                                  Icons.check_box,
                                                                  color: Colors.white,
                                                                  size: 24,
                                                                )
                                                                    : null,
                                                              ),
                                                              const SizedBox(width: 8),
                                                              Text(option),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (state is OptionsDataError) {
                                      return Text(state.message);
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    Constants.other,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField( style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .tablettextfieldTextStyle
                                      : FTextStyle
                                      .mobileTextFieldStyle,

                                    controller: other,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      suffixIcon: openedDropdownIndex == 4
                                          ? Icon(Icons.arrow_drop_up, color: Colors.grey, size: 24)
                                          : Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                                      hintText: "Select others",
                                      hintStyle: FTextStyle.loginFieldHintTextStyle,
                                      errorStyle: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                    readOnly: true,
                                    maxLines: 1,
                                    onTap: () {
                                      setState(() {
                                        // Set openedDropdownIndex to 4 for this dropdown, and close others
                                        openedDropdownIndex = (openedDropdownIndex == 4) ? -1 : 4;
                                      });
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                                BlocBuilder<DrawerBloc, DrawerState>(
                                  builder: (context, state) {
                                    if (state is OptionsDataLoaded) {
                                      return Visibility(
                                        visible: openedDropdownIndex == 4, // Show this dropdown if openedDropdownIndex is 4
                                        child: IntrinsicHeight(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: state.optionsData['OTHER']!.map((option) {
                                                final bool isSelected = selectedOthers.contains(option);

                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            // Add or remove the option from the selectedOthers list
                                                            if (isSelected) {
                                                              selectedOthers.remove(option);
                                                            } else {
                                                              selectedOthers.add(option);
                                                            }

                                                            // Update the TextFormField with selected options
                                                            String displayText = selectedOthers.join(", ");
                                                            if (displayText.length > 35) {
                                                              displayText = displayText.substring(0, 35) + "...";
                                                            }
                                                            other.text = displayText;

                                                            // Print the selected options
                                                            print("Selected Others: $selectedOthers");
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 24,
                                                                height: 24,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(3),
                                                                  border: Border.all(
                                                                    color: isSelected
                                                                        ? AppColors.primaryColorPink
                                                                        : AppColors.boarderColour,
                                                                    width: 1.5,
                                                                  ),
                                                                  color: isSelected
                                                                      ? AppColors.primaryColorPink
                                                                      : Colors.white,
                                                                ),
                                                                child: isSelected
                                                                    ? const Icon(
                                                                  Icons.check_box,
                                                                  color: Colors.white,
                                                                  size: 24,
                                                                )
                                                                    : null,
                                                              ),
                                                              const SizedBox(width: 8),
                                                              Text(option),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (state is OptionsDataError) {
                                      return Text(state.message);
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    Constants.haveKids,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .tablettextfieldTextStyle
                                        : FTextStyle
                                        .mobileTextFieldStyle,
                                    keyboardType: TextInputType.number,
                                    controller: havekids,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: isDropdownVisible
                                              ? AppColors.boarderColour
                                              : AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide: BorderSide(
                                            color: AppColors.errorColor),
                                      ),
                                      focusedErrorBorder:
                                      const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide: BorderSide(
                                            color: AppColors.errorColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.boarderColour),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      hintText: "Enter number of kids",
                                      hintStyle:
                                      FTextStyle.loginFieldHintTextStyle,
                                      errorStyle:
                                      FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                    maxLines: 1,
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    Constants.ageBracket,
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .tablettextfieldTextStyle
                                        : FTextStyle
                                        .mobileTextFieldStyle,
                                    controller: ageBracket,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide(
                                          color: AppColors.errorColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: AppColors.boarderColour,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      suffixIcon: openedDropdownIndex == 5
                                          ? Icon(Icons.arrow_drop_up, color: Colors.grey, size: 24)
                                          : Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                                      hintText: "Select your age",
                                      hintStyle: FTextStyle.loginFieldHintTextStyle,
                                      errorStyle: FTextStyle.formFieldErrorTxtStyle,
                                    ),
                                    readOnly: true,
                                    maxLines: 1,
                                    onTap: () {
                                      setState(() {
                                        // Toggle the dropdown for Age Bracket
                                        openedDropdownIndex = (openedDropdownIndex == 5) ? -1 : 5;
                                      });
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                                Visibility(
                                  visible: openedDropdownIndex == 5, // Show this dropdown if openedDropdownIndex is 5
                                  child: IntrinsicHeight(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          '21-24 Years',
                                          '25-34 Years',
                                          '35-44 Years',
                                          '45-54 Years',
                                          '55-64 Years',
                                          '65+ Years'
                                        ].map((option) {
                                          final bool isSelected = selectedAge == option;

                                          return Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      // Only allow one selection; set selectedAge to the selected option
                                                      selectedAge = option;

                                                      // Update the TextFormField with the selected age bracket
                                                      ageBracket.text = selectedAge!;

                                                      // Print the selected age
                                                      print("Selected Age: $selectedAge");

                                                      // Optionally hide the dropdown after selection
                                                      openedDropdownIndex = -1;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(3),
                                                            border: Border.all(
                                                              color: isSelected
                                                                  ? AppColors.primaryColorPink
                                                                  : AppColors.boarderColour,
                                                              width: 1.5,
                                                            ),
                                                            color: isSelected
                                                                ? AppColors.primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: isSelected
                                                              ? const Icon(
                                                            Icons.check_box,
                                                            color: Colors.white,
                                                            size: 24,
                                                          )
                                                              : null,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(option),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? 30.h
                                      : 0,
                                ),
                                Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                    child: ElevatedButton(
                                      onPressed: _isButtonEnabled
                                          ? () {
                                        // If all required fields are filled, print values and proceed
                                        print(_name.text);
                                        print(_email.text);
                                        print(countryCode);
                                        print(yourStage);
                                        print(_phone.text);
                                        print(selectedothermumOption);
                                        print(selectedLanguages);
                                        print(selectedexercises);
                                        print(selectedOthers);
                                        print(selectedAge);
                                        print(havekids.text);

                                        // Use the previous selections if new selections are empty
                                        final updatedOtherMumOption = selectedothermumOption.isNotEmpty
                                            ? selectedothermumOption
                                            : widget.otherthanmum.cast<String>();
                                        final updatedLanguages = selectedLanguages.isNotEmpty
                                            ? selectedLanguages
                                            : widget.languages.cast<String>();
                                        final updatedExercises = selectedexercises.isNotEmpty
                                            ? selectedexercises
                                            : widget.exercises.cast<String>();
                                        final updatedOthers = selectedOthers.isNotEmpty
                                            ? selectedOthers
                                            : widget.other.cast<String>();
                                        final updatedAge = selectedAge.isNotEmpty
                                            ? selectedAge
                                            : widget.ageBracket;

                                        // Trigger the update profile event

                                        BlocProvider.of<DrawerBloc>(context).add(
                                          UpdateUserProfileRequested(
                                            fullName: _name.text,
                                            email: PrefUtils.getIsSocialLogin()
                                                ? PrefUtils.getUserEmail()
                                                : _email.text,
                                            countryCode: countryCode,
                                            stage: yourStage,
                                            phoneNumber: _phone.text,
                                            profilePicture: base64Encode(profileImage),
                                            otherWork: updatedOtherMumOption,
                                            languages: updatedLanguages,
                                            exercise: updatedExercises,
                                            others: updatedOthers,
                                            age: updatedAge,
                                            kids: havekids.text.isNotEmpty ? havekids.text : widget.havekids,
                                          ),
                                        );

                                        // Navigate to the next screen if profile is updated successfully
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CustomBottomNavigationBar()),
                                        );
                                      }
                                          : null, // Disable the button if _isButtonEnabled is false
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue1,
                                        textStyle: FTextStyle.buttonStyle,
                                        minimumSize: (displayType == 'desktop' || displayType == 'tablet')
                                            ? Size(120.w, 50.h)
                                            : Size(120, 40), // Adjust button size as needed
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'Update Your Account',
                                        style: (displayType == 'desktop' || displayType == 'tablet')
                                            ? FTextStyle.buttonStyleTablet
                                            : FTextStyle.buttonStyle,
                                      ),
                                    ),


                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        onPressed: () {
                          _imgFromCamera();
                          Navigator.pop(context);
                        },
                      ),
                      const Text('Take a Photo').animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: () {
                          _imgFromGallery();
                          Navigator.pop(context);
                        },
                      ),
                      const Text('Choose from Gallery').animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _imgFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        profileUpdate = false;
        profileImage = [];
        selectionImageType = 'CAMERA';
        _image = File(image.path);
        final bytes = _image?.readAsBytesSync();
        cameraSelectedImage = base64Encode(bytes!);
        profileImage = base64Decode(cameraSelectedImage);
      });
    }
  }

  void _imgFromGallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      selectionImageType = 'GALLERY';
      setState(() {
        profileUpdate = false;
        profileImage = [];
        _image = File(image.path);
        final bytes = _image?.readAsBytesSync();
        gallerySelectedImage = base64Encode(bytes!);
        profileImage = base64Decode(gallerySelectedImage);
      });
    }
  }
}


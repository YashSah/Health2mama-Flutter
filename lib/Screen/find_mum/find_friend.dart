import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/ModelClass/OptionSelection.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find_mum/find_a_mum.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';
import '../../Utils/CommonFuction.dart';
import '../../Utils/constant.dart';

class FindFriendProfile extends StatefulWidget {
  const FindFriendProfile({super.key});

  @override
  State<FindFriendProfile> createState() => _FindFriendProfileState();
}

class _FindFriendProfileState extends State<FindFriendProfile> {
  void initState() {
    super.initState();
    BlocProvider.of<FindMumBloc>(context).add(FetchDropdownOptions());
  }

  String convertStage(String stage) {
    stage = stage.toUpperCase().replaceAll(' ', '');

    switch (stage) {
      case 'TRYINGTOCONCEIVE':
        return 'TRYINGTOCONCEIVE';
      case 'PREGNANT':
        return 'PREGNANT';
      case 'POSTPARTUM(0-6WEEKSAFTERBIRTH)':
        return 'POSTPARTUM';
      default:
        return 'BEYOND'; // Return the original stage if no match is found
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
  final formKey = GlobalKey<FormState>();
  final TextEditingController age = TextEditingController();
  final TextEditingController ageAdd = TextEditingController();
  TextEditingController mentoryController =
      TextEditingController(); // Controller for "Mentory" field
  TextEditingController ageController = TextEditingController();
  bool isDropdownVisible = false;
  bool doingStageVisible = false;
  bool ages = false;
  bool execiseVisible = false;
  bool languagueVisible = false;
  bool otherVisible = false;
  String yourStage = "";
  String ageStage = "";
  String doingStage = "";
  String execiseStage = "";
  String languagueStage = "";
  String otherStage = "";
  TextEditingController _descriptionController = TextEditingController();
  String? _titleError;
  String? _descriptionError;
  final int maxTitleLength = 50;
  final int maxDescriptionLength = 200;
  // Track button enabled state
  List<Map<String, dynamic>> areYouStages = [
    {"title": Constants.stage1, "value": Constants.stage1, "selected": false},
    {"title": Constants.stage2, "value": Constants.stage2, "selected": false},
    {"title": Constants.stage3, "value": Constants.stage3, "selected": false},
    {"title": Constants.stage41, "value": Constants.stage41, "selected": false},
  ];

  late Map<String, dynamic> result;

  List<Map<String, dynamic>> ageStages = [
    {"title": "21-24 Years", "value": "21-24 Years", "selected": false},
    {"title": "25-34 Years", "value": "25-34 Years", "selected": false},
    {"title": "35-44 Years", "value": "35-44 Years", "selected": false},
    {"title": "45-54 Years", "value": "45-54 Years", "selected": false},
    {"title": "55-64 Years", "value": "55-64 Years", "selected": false},
    {"title": "65+ Years", "value": "65+ Years", "selected": false},
  ];

  bool isButtonEnabled() {
    return yourStage.isNotEmpty ||
        doingStage.isNotEmpty ||
        execiseStage.isNotEmpty ||
        languagueStage.isNotEmpty ||
        otherStage.isNotEmpty ||
        ageStage.isNotEmpty;
  }

  List<Optionselection> otherStages = [];
  List<Optionselection> languagueStages = [];
  List<Optionselection> execiseStages = [];
  List<Optionselection> doingStages = [];
  bool isLastCheckboxSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              child: Text("Find a Friend Profile",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context,[true]);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 4.w
                        : screenWidth * 0.03,
                vertical: (displayType == 'desktop' || displayType == 'tablet')
                    ? 2.w
                    : screenWidth * 0.01,
              ),
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
        body: BlocBuilder<FindMumBloc, FindMumState>(
          builder: (context, state) {
            if (state is DropdownLoading) {
              return Center(child: CircularProgressIndicator(color: AppColors.pink));
            } else if (state is DropdownLoaded) {
              if (otherStages.isEmpty) {
                result = state.result;
                print('Loaded data: $result');
                for (String obj in result['OTHER']) {
                  otherStages.add(Optionselection(
                      title: obj.toString(),
                      value: obj.toString(),
                      selected: false));
                }
              }
              if (languagueStages.isEmpty) {
                result = state.result;
                print('Loaded data: $result');
                for (String obj in result['LANGUAGE']) {
                  languagueStages.add(Optionselection(
                      title: obj.toString(),
                      value: obj.toString(),
                      selected: false));
                }
              }
              if (execiseStages.isEmpty) {
                result = state.result;
                print('Loaded data: $result');
                for (String obj in result['EXERCISE']) {
                  execiseStages.add(Optionselection(
                      title: obj.toString(),
                      value: obj.toString(),
                      selected: false));
                }
              }
              if (doingStages.isEmpty) {
                result = state.result;
                print('Loaded data: $result');
                for (String obj in result['OTHERTHANMUM']) {
                  doingStages.add(Optionselection(
                      title: obj.toString(),
                      value: obj.toString(),
                      selected: false));
                }
              }
              return ListView(
                children: [
                  const Divider(
                    thickness: 1.2,
                    color: Color(0XFFF6F6F6),
                  ),
                  Padding(
                    padding:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? EdgeInsets.symmetric(horizontal: 25.w)
                            : EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Text(
                                  "Are you?",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                              TextFormField(
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
                                      color: AppColors
                                          .boarderColour, // Color when the field is focused
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is not focused
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    // or Icons.arrow_drop_up based on your condition
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  hintText: "Select stage",
                                  // Set an empty hintText initially
                                  hintStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                          .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                ),
                                readOnly: true,
                                // Making it read-only to show the selected value
                                controller: areYouStages.last['selected'] ==
                                        true
                                    ? age
                                    : TextEditingController(text: yourStage),
                                // Setting initial value
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  setState(() {
                                    isDropdownVisible = !isDropdownVisible;
                                  });
                                },
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Visibility(
                                visible: isDropdownVisible,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 35),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: areYouStages.map((stage) {
                                          int index = areYouStages.indexOf(
                                              stage); // Get the index of the current stage
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    yourStage = stage['value']!;
                                                    areYouStages.forEach((s) {
                                                      s['selected'] =
                                                          (s == stage);
                                                    });
                                                    // Enable the button when at least one checkbox is selected
                                                  });
                                                  areYouStages.last[
                                                                  'selected'] ==
                                                              true &&
                                                          age.text.isEmpty
                                                      ? isDropdownVisible
                                                      : Future.delayed(
                                                          const Duration(
                                                              microseconds:
                                                                  1500), () {
                                                          setState(() {
                                                            isDropdownVisible =
                                                                !isDropdownVisible;
                                                          });
                                                        });
                                                  areYouStages.last[
                                                                  'selected'] ==
                                                              true &&
                                                          age.text.isEmpty
                                                      ? isDropdownVisible
                                                      : Future.delayed(
                                                          const Duration(
                                                              microseconds:
                                                                  1500), () {
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
                                                        setState(() {
                                                          yourStage =
                                                              stage['value']!;
                                                          areYouStages
                                                              .forEach((s) {
                                                            s['selected'] =
                                                                (s == stage);
                                                          });
                                                          // Enable the button when at least one checkbox is selected
                                                        });
                                                        areYouStages.last[
                                                                        'selected'] ==
                                                                    true &&
                                                                age.text.isEmpty
                                                            ? isDropdownVisible
                                                            : Future.delayed(
                                                                const Duration(
                                                                    microseconds:
                                                                        1500),
                                                                () {
                                                                setState(() {
                                                                  isDropdownVisible =
                                                                      !isDropdownVisible;
                                                                });
                                                              });
                                                        areYouStages.last[
                                                                        'selected'] ==
                                                                    true &&
                                                                age.text.isEmpty
                                                            ? isDropdownVisible
                                                            : Future.delayed(
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
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          width: 24,
                                                          // Adjust the width as needed
                                                          height: 24,
                                                          // Adjust the height as needed
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            // Adjust the radius as needed
                                                            border: Border.all(
                                                              color: stage[
                                                                          'selected'] ==
                                                                      true
                                                                  ? AppColors
                                                                      .primaryColorPink
                                                                  : AppColors
                                                                      .boarderColour,
                                                              width:
                                                                  1.5, // Adjust the width as needed
                                                            ),
                                                            color: stage[
                                                                        'selected'] ==
                                                                    true
                                                                ? AppColors
                                                                    .primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: stage[
                                                                      'selected'] ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 24,
                                                                )
                                                              : null, // No icon when unselected
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        stage['title'],
                                                        maxLines: 3,
                                                        style: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .rememberMeTextStyleTablet
                                                            : FTextStyle
                                                                .rememberMeTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Add divider conditionally except for the last item
                                              if (index !=
                                                  areYouStages.length - 1)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 10),
                                                  child: Divider(
                                                    color:
                                                        AppColors.darkGreyColor,
                                                    height: 0.5,
                                                  ),
                                                ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      // Add Text widget for age
                                      Visibility(
                                        visible: isDropdownVisible &&
                                            areYouStages.last['selected'] ==
                                                true,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 32.0,
                                                  vertical: 8),
                                              child: Text(
                                                "Age of Kids",
                                                style: (displayType ==
                                                            'desktop' ||
                                                        displayType == 'tablet')
                                                    ? FTextStyle
                                                        .loginEmailFieldHeadingStyleTablet
                                                    : FTextStyle
                                                        .loginEmailFieldHeadingStyle,
                                              ),
                                            ),
                                            Visibility(
                                              visible: isDropdownVisible &&
                                                  yourStage.isNotEmpty,
                                              // Show only if dropdown is visible and a stage is selected
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 32.0),
                                                child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: doingStageVisible
                                                              ? AppColors
                                                                  .boarderColour
                                                              : AppColors
                                                                  .boarderColour,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .boarderColour, // Color when the field is focused
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .boarderColour, // Color when the field is not focused
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 4,
                                                              horizontal: 10),
                                                      hintText: "Enter age",
                                                      // Set an empty hintText initially
                                                      hintStyle: (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .loginFieldHintTextStyleTablet
                                                          : FTextStyle
                                                              .loginFieldHintTextStyle,
                                                      errorStyle: (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .formFieldErrorTxtStyleTablet
                                                          : FTextStyle
                                                              .formFieldErrorTxtStyle, // Set hint color to grey if yourStage is empty, otherwise black
                                                    ),
                                                    controller: age,
                                                    // Setting initial value
                                                    style:
                                                        (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .cardSubtitleTablet
                                                            : FTextStyle
                                                                .cardSubtitle,
                                                    maxLines: 1,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your age'; // Return error message if age is empty
                                                      }
                                                      int? ageValue =
                                                          int.tryParse(value);
                                                      if (ageValue == null ||
                                                          ageValue <= 0 ||
                                                          value.length > 10) {
                                                        return 'Please enter a valid age between 1 and 10 digits'; // Return error message if age is not within the specified range
                                                      }
                                                      // You can add more specific validation if needed
                                                      return null; // Return null if validation passes
                                                    },
                                                    onTap: () {}),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Add TextFormField for age input
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Text(
                                  "What is your Age Bracket? ",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ages
                                          ? AppColors.boarderColour
                                          : AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is focused
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is not focused
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    // or Icons.arrow_drop_up based on your condition
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  hintText: "Full time",
                                  // Set an empty hintText initially
                                  hintStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                          .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                ),
                                readOnly: true,
                                // Making it read-only to show the selected value
                                controller:
                                    TextEditingController(text: ageStage),
                                // Setting initial value
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  setState(() {
                                    ages = !ages;
                                  });
                                },
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Visibility(
                                visible: ages,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 35),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: ageStages.map((stage) {
                                          int index = ageStages.indexOf(
                                              stage); // Get the index of the current stage
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    ageStage = stage['value']!;
                                                    ageStages.forEach((s) {
                                                      s['selected'] =
                                                          (s == stage);
                                                    });
                                                    // Enable the button when at least one checkbox is selected
                                                  });
                                                  ageStages.last['selected'] ==
                                                          true
                                                      ? ages
                                                      : Future.delayed(
                                                          const Duration(
                                                              microseconds:
                                                                  1500), () {
                                                          setState(() {
                                                            ages = !ages;
                                                          });
                                                        });
                                                  ageStages.last['selected'] ==
                                                          true
                                                      ? ages
                                                      : Future.delayed(
                                                          const Duration(
                                                              microseconds:
                                                                  1500), () {
                                                          setState(() {
                                                            ages = !ages;
                                                          });
                                                        });
                                                  // setState(() {
                                                  //   // Toggle the 'selected' property of the tapped stage
                                                  //   stage['selected'] = !stage['selected'];
                                                  //
                                                  //   // Update the servicesStage based on selected stages
                                                  //   List<String> selectedValues = [];
                                                  //   for (var s in ageStages) {
                                                  //     if (s['selected']) {
                                                  //       selectedValues.add(s['value']);
                                                  //     }
                                                  //   }
                                                  //   if(selectedValues.length > 2) {
                                                  //     ageStage = '${selectedValues.take(2).join(',')} +${selectedValues.length-2}';
                                                  //   } else {
                                                  //     ageStage = selectedValues.join(', ');
                                                  //   }
                                                  //   // Join selected values with a comma
                                                  // });
                                                },
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          ageStage =
                                                              stage['value']!;
                                                          ageStages
                                                              .forEach((s) {
                                                            s['selected'] =
                                                                (s == stage);
                                                          });
                                                          // Enable the button when at least one checkbox is selected
                                                        });
                                                        ageStages.last[
                                                                    'selected'] ==
                                                                true
                                                            ? ages
                                                            : Future.delayed(
                                                                const Duration(
                                                                    microseconds:
                                                                        1500),
                                                                () {
                                                                setState(() {
                                                                  ages = !ages;
                                                                });
                                                              });
                                                        ageStages.last[
                                                                    'selected'] ==
                                                                true
                                                            ? ages
                                                            : Future.delayed(
                                                                const Duration(
                                                                    microseconds:
                                                                        1500),
                                                                () {
                                                                setState(() {
                                                                  ages = !ages;
                                                                });
                                                              });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          width: 24,
                                                          // Adjust the width as needed
                                                          height: 24,
                                                          // Adjust the height as needed
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            // Adjust the radius as needed
                                                            border: Border.all(
                                                              color: stage[
                                                                          'selected'] ==
                                                                      true
                                                                  ? AppColors
                                                                      .primaryColorPink
                                                                  : AppColors
                                                                      .boarderColour,
                                                              width:
                                                                  1.5, // Adjust the width as needed
                                                            ),
                                                            color: stage[
                                                                        'selected'] ==
                                                                    true
                                                                ? AppColors
                                                                    .primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: stage[
                                                                      'selected'] ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 24,
                                                                )
                                                              : null, // No icon when unselected
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        stage['title'],
                                                        maxLines: 3,
                                                        style: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .rememberMeTextStyleTablet
                                                            : FTextStyle
                                                                .rememberMeTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Add divider conditionally except for the last item
                                              if (index != ageStages.length - 1)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 10),
                                                  child: Divider(
                                                    color:
                                                        AppColors.darkGreyColor,
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Text(
                                  "Other than being a mum are you doing other work?",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: doingStageVisible
                                          ? AppColors.boarderColour
                                          : AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is focused
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is not focused
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    // or Icons.arrow_drop_up based on your condition
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  hintText: "Full time",
                                  // Set an empty hintText initially
                                  hintStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                          .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                ),
                                readOnly: true,
                                // Making it read-only to show the selected value
                                controller:
                                    TextEditingController(text: doingStage),
                                // Setting initial value
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  setState(() {
                                    doingStageVisible = !doingStageVisible;
                                  });
                                },
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Visibility(
                                visible: doingStageVisible,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 35),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: doingStages.map((stage) {
                                          int index = doingStages.indexOf(
                                              stage); // Get the index of the current stage
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    // Toggle the 'selected' property of the tapped stage
                                                    stage.selected =
                                                        !stage.selected;

                                                    // Update the servicesStage based on selected stages
                                                    List<String>
                                                        selectedValues = [];
                                                    for (var s in doingStages) {
                                                      if (s.selected) {
                                                        selectedValues
                                                            .add(s.value);
                                                      }
                                                    }
                                                    if (selectedValues.length >
                                                        2) {
                                                      doingStage =
                                                          '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                    } else {
                                                      doingStage =
                                                          selectedValues
                                                              .join(', ');
                                                    }
                                                    // Join selected values with a comma
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          // Toggle the 'selected' property of the tapped stage
                                                          stage.selected =
                                                              !stage.selected;

                                                          // Update the servicesStage based on selected stages
                                                          List<String>
                                                              selectedValues =
                                                              [];
                                                          for (var s
                                                              in doingStages) {
                                                            if (s.selected) {
                                                              selectedValues
                                                                  .add(s.value);
                                                            }
                                                          }
                                                          if (selectedValues
                                                                  .length >
                                                              2) {
                                                            doingStage =
                                                                '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                          } else {
                                                            doingStage =
                                                                selectedValues
                                                                    .join(', ');
                                                          }
                                                          // Join selected values with a comma
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          width: 24,
                                                          // Adjust the width as needed
                                                          height: 24,
                                                          // Adjust the height as needed
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            // Adjust the radius as needed
                                                            border: Border.all(
                                                              color: stage.selected ==
                                                                      true
                                                                  ? AppColors
                                                                      .primaryColorPink
                                                                  : AppColors
                                                                      .boarderColour,
                                                              width:
                                                                  1.5, // Adjust the width as needed
                                                            ),
                                                            color: stage.selected ==
                                                                    true
                                                                ? AppColors
                                                                    .primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: stage.selected ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 24,
                                                                )
                                                              : null, // No icon when unselected
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        stage.title,
                                                        maxLines: 3,
                                                        style: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .rememberMeTextStyleTablet
                                                            : FTextStyle
                                                                .rememberMeTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Add divider conditionally except for the last item
                                              if (index !=
                                                  doingStages.length - 1)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 10),
                                                  child: Divider(
                                                    color:
                                                        AppColors.darkGreyColor,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Text(
                                  "Interests",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: otherVisible
                                          ? AppColors.boarderColour
                                          : AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is focused
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is not focused
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    // or Icons.arrow_drop_up based on your condition
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  hintText: "Select interests",
                                  // Set an empty hintText initially
                                  hintStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                          .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                ),
                                readOnly: true,
                                // Making it read-only to show the selected value
                                controller:
                                    TextEditingController(text: otherStage),
                                // Setting initial value
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  setState(() {
                                    otherVisible = !otherVisible;
                                  });
                                },
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Visibility(
                                visible: otherVisible,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 35),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: otherStages.map((stage) {
                                          int index = otherStages.indexOf(
                                              stage); // Get the index of the current stage
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    // Toggle the 'selected' property of the tapped stage
                                                    stage.selected =
                                                        !stage.selected;

                                                    // Update the servicesStage based on selected stages
                                                    List<String>
                                                        selectedValues = [];
                                                    for (var s in otherStages) {
                                                      if (s.selected) {
                                                        selectedValues
                                                            .add(s.value);
                                                      }
                                                    }
                                                    if (selectedValues.length >
                                                        2) {
                                                      otherStage =
                                                          '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                    } else {
                                                      otherStage =
                                                          selectedValues
                                                              .join(', ');
                                                    }
                                                    // Join selected values with a comma
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          // Toggle the 'selected' property of the tapped stage
                                                          stage.selected =
                                                              !stage.selected;

                                                          // Update the servicesStage based on selected stages
                                                          List<String>
                                                              selectedValues =
                                                              [];
                                                          for (var s
                                                              in otherStages) {
                                                            if (s.selected) {
                                                              selectedValues
                                                                  .add(s.value);
                                                            }
                                                          }
                                                          if (selectedValues
                                                                  .length >
                                                              2) {
                                                            otherStage =
                                                                '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                          } else {
                                                            otherStage =
                                                                selectedValues
                                                                    .join(', ');
                                                          }
                                                          // Join selected values with a comma
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          width: 24,
                                                          // Adjust the width as needed
                                                          height: 24,
                                                          // Adjust the height as needed
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            // Adjust the radius as needed
                                                            border: Border.all(
                                                              color: stage.selected ==
                                                                      true
                                                                  ? AppColors
                                                                      .primaryColorPink
                                                                  : AppColors
                                                                      .boarderColour,
                                                              width:
                                                                  1.5, // Adjust the width as needed
                                                            ),
                                                            color: stage.selected ==
                                                                    true
                                                                ? AppColors
                                                                    .primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: stage.selected ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 24,
                                                                )
                                                              : null, // No icon when unselected
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        stage.title,
                                                        maxLines: 3,
                                                        style: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .rememberMeTextStyleTablet
                                                            : FTextStyle
                                                                .rememberMeTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Add divider conditionally except for the last item
                                              if (index !=
                                                  otherStages.length - 1)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 10),
                                                  child: Divider(
                                                    color:
                                                        AppColors.darkGreyColor,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Text(
                                  "Which Exercise type do you enjoy?",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: execiseVisible
                                          ? AppColors.boarderColour
                                          : AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is focused
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is not focused
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    // or Icons.arrow_drop_up based on your condition
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  hintText: "Select exercise",
                                  // Set an empty hintText initially
                                  hintStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                          .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                ),
                                readOnly: true,
                                // Making it read-only to show the selected value
                                controller:
                                    TextEditingController(text: execiseStage),
                                // Setting initial value
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  setState(() {
                                    execiseVisible = !execiseVisible;
                                  });
                                },
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Visibility(
                                visible: execiseVisible,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 35),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: execiseStages.map((stage) {
                                          int index = execiseStages.indexOf(
                                              stage); // Get the index of the current stage
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    // Toggle the 'selected' property of the tapped stage
                                                    stage.selected =
                                                        !stage.selected;

                                                    // Update the servicesStage based on selected stages
                                                    List<String>
                                                        selectedValues = [];
                                                    for (var s
                                                        in execiseStages) {
                                                      if (s.selected) {
                                                        selectedValues
                                                            .add(s.value);
                                                      }
                                                    }
                                                    if (selectedValues.length >
                                                        2) {
                                                      execiseStage =
                                                          '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                    } else {
                                                      execiseStage =
                                                          selectedValues
                                                              .join(', ');
                                                    }
                                                    // Join selected values with a comma
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          // Toggle the 'selected' property of the tapped stage
                                                          stage.selected =
                                                              !stage.selected;

                                                          // Update the servicesStage based on selected stages
                                                          List<String>
                                                              selectedValues =
                                                              [];
                                                          for (var s
                                                              in execiseStages) {
                                                            if (s.selected) {
                                                              selectedValues
                                                                  .add(s.value);
                                                            }
                                                          }
                                                          if (selectedValues
                                                                  .length >
                                                              2) {
                                                            execiseStage =
                                                                '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                          } else {
                                                            execiseStage =
                                                                selectedValues
                                                                    .join(', ');
                                                          }
                                                          // Join selected values with a comma
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          width: 24,
                                                          // Adjust the width as needed
                                                          height: 24,
                                                          // Adjust the height as needed
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            // Adjust the radius as needed
                                                            border: Border.all(
                                                              color: stage.selected ==
                                                                      true
                                                                  ? AppColors
                                                                      .primaryColorPink
                                                                  : AppColors
                                                                      .boarderColour,
                                                              width:
                                                                  1.5, // Adjust the width as needed
                                                            ),
                                                            color: stage.selected ==
                                                                    true
                                                                ? AppColors
                                                                    .primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: stage.selected ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 24,
                                                                )
                                                              : null, // No icon when unselected
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        stage.title,
                                                        maxLines: 3,
                                                        style: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .rememberMeTextStyleTablet
                                                            : FTextStyle
                                                                .rememberMeTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Add divider conditionally except for the last item
                                              if (index !=
                                                  execiseStages.length - 1)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 10),
                                                  child: Divider(
                                                    color:
                                                        AppColors.darkGreyColor,
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Text(
                                  "Which languages do you speak fluently?",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: execiseVisible
                                          ? AppColors.boarderColour
                                          : AppColors.boarderColour,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is focused
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors
                                          .boarderColour, // Color when the field is not focused
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    // or Icons.arrow_drop_up based on your condition
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  hintText: "Select languages",
                                  // Set an empty hintText initially
                                  hintStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.loginFieldHintTextStyleTablet
                                      : FTextStyle.loginFieldHintTextStyle,
                                  errorStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.formFieldErrorTxtStyleTablet
                                      : FTextStyle
                                          .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                ),
                                readOnly: true,
                                // Making it read-only to show the selected value
                                controller:
                                    TextEditingController(text: languagueStage),
                                // Setting initial value
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.cardSubtitleTablet
                                    : FTextStyle.cardSubtitle,
                                maxLines: 1,
                                onTap: () {
                                  setState(() {
                                    languagueVisible = !languagueVisible;
                                  });
                                },
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Visibility(
                                visible: languagueVisible,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 35),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: languagueStages.map((stage) {
                                          int index = languagueStages.indexOf(
                                              stage); // Get the index of the current stage
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    // Toggle the 'selected' property of the tapped stage
                                                    stage.selected =
                                                        !stage.selected;

                                                    // Update the servicesStage based on selected stages
                                                    List<String>
                                                        selectedValues = [];
                                                    for (var s
                                                        in languagueStages) {
                                                      if (s.selected) {
                                                        selectedValues
                                                            .add(s.value);
                                                      }
                                                    }
                                                    if (selectedValues.length >
                                                        2) {
                                                      languagueStage =
                                                          '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                    } else {
                                                      languagueStage =
                                                          selectedValues
                                                              .join(', ');
                                                    }
                                                    // Join selected values with a comma
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          // Toggle the 'selected' property of the tapped stage
                                                          stage.selected =
                                                              !stage.selected;

                                                          // Update the servicesStage based on selected stages
                                                          List<String>
                                                              selectedValues =
                                                              [];
                                                          for (var s
                                                              in languagueStages) {
                                                            if (s.selected) {
                                                              selectedValues
                                                                  .add(s.value);
                                                            }
                                                          }
                                                          if (selectedValues
                                                                  .length >
                                                              2) {
                                                            languagueStage =
                                                                '${selectedValues.take(2).join(',')} +${selectedValues.length - 2}';
                                                          } else {
                                                            languagueStage =
                                                                selectedValues
                                                                    .join(', ');
                                                          }
                                                          // Join selected values with a comma
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          width: 24,
                                                          // Adjust the width as needed
                                                          height: 24,
                                                          // Adjust the height as needed
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            // Adjust the radius as needed
                                                            border: Border.all(
                                                              color: stage.selected ==
                                                                      true
                                                                  ? AppColors
                                                                      .primaryColorPink
                                                                  : AppColors
                                                                      .boarderColour,
                                                              width:
                                                                  1.5, // Adjust the width as needed
                                                            ),
                                                            color: stage.selected ==
                                                                    true
                                                                ? AppColors
                                                                    .primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: stage.selected ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 24,
                                                                )
                                                              : null, // No icon when unselected
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        stage.value,
                                                        maxLines: 3,
                                                        style: (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .rememberMeTextStyleTablet
                                                            : FTextStyle
                                                                .rememberMeTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Add divider conditionally except for the last item
                                              if (index !=
                                                  languagueStages.length - 1)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 10),
                                                  child: Divider(
                                                    color:
                                                        AppColors.darkGreyColor,
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Text(
                                  "Sum yourself up in a few lines (optional)",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle
                                          .loginEmailFieldHeadingStyleTablet
                                      : FTextStyle.loginEmailFieldHeadingStyle,
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.0325),
                                height: screenHeight * 0.1375,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: AppColors.boarderColour)),
                                child: TextFormField(
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.cardSubtitleTablet
                                      : FTextStyle.cardSubtitle,
                                  controller: _descriptionController,
                                  maxLines: 10,
                                  maxLength: maxDescriptionLength,
                                  // Set max length for description
                                  decoration: InputDecoration(
                                      counterText: "",
                                      // To hide the default counter text
                                      border: InputBorder.none,
                                      hintText: 'Write Something.....',
                                      hintStyle: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle
                                              .loginFieldHintTextStyleTablet
                                          : FTextStyle.loginFieldHintTextStyle,
                                      errorStyle: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle
                                              .formFieldErrorTxtStyleTablet
                                          : FTextStyle.formFieldErrorTxtStyle),
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              if (_descriptionError != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, left: 8),
                                  child: Text(_descriptionError!,
                                      style: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle
                                              .formFieldErrorTxtStyleTablet
                                          : FTextStyle.formFieldErrorTxtStyle),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 48),
                                child: ElevatedButton(
                                  onPressed: isButtonEnabled()
                                      ? () {
                                          List<String> selectedWork =
                                              otherStages
                                                  .where((service) =>
                                                      service.selected)
                                                  .map((service) =>
                                                      service.value)
                                                  .toList();
                                          List<String> selectedInterest =
                                              doingStages
                                                  .where((specialization) =>
                                                      specialization.selected)
                                                  .map((specialization) =>
                                                      specialization.value)
                                                  .toList();
                                          List<String> selectedExercise =
                                              execiseStages
                                                  .where((service) =>
                                                      service.selected)
                                                  .map((service) =>
                                                      service.value)
                                                  .toList();
                                          List<String> selectedLanguage =
                                              languagueStages
                                                  .where((specialization) =>
                                                      specialization.selected)
                                                  .map((specialization) =>
                                                      specialization.value)
                                                  .toList();
                                          String convertedStage =
                                              convertStage(yourStage);
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                create: (context) =>
                                                    FindMumBloc(),
                                                child: FindMum(
                                                    areYou: convertedStage,
                                                    Age: ageStage,
                                                    Other: selectedWork,
                                                    Interest: selectedInterest,
                                                    Exercise: selectedExercise,
                                                    Language: selectedLanguage),
                                              ),
                                            ),
                                          ).then((result) {
                                            if (result != null && result[0]) {
                                              BlocProvider.of<FindMumBloc>(
                                                      context)
                                                  .add(FetchDropdownOptions());
                                            }
                                          });
                                        }
                                      : null,
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.pinkButton,
                                          textStyle:
                                              FTextStyle.buttonStyleTablet,
                                          minimumSize:
                                              Size(double.infinity, 45.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          elevation: 2,
                                        )
                                      : ElevatedButton.styleFrom(
                                          backgroundColor: isButtonEnabled()
                                              ? AppColors.appBlue
                                              : Colors.grey,
                                          textStyle: FTextStyle.buttonStyle,
                                          minimumSize: const Size(120, 40),
                                          // Adjust button size as needed
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          elevation: 2,
                                        ),
                                  child: Text(
                                    'Find a friend',
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.buttonStyleTablet
                                        : FTextStyle.buttonStyle,
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

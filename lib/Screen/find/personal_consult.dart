import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/ModelClass/find_model.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find/your_consultant.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/constant.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/find/find_bloc.dart';

class PersonalConsult extends StatefulWidget {
  const PersonalConsult({super.key});

  @override
  State<PersonalConsult> createState() => _PersonalConsultState();
}

class _PersonalConsultState extends State<PersonalConsult> {
  final formKey = GlobalKey<FormState>();
  String? developer;
  bool specializationsFetched = false;
  bool developerError = false;
  bool isDropdownVisible = false;
  bool isSpecialistDropdownTapped = false;
  bool serviceVisible = false;
  bool specialist = false;
  int selectedDistance = 0; // Variable to store the selected distance in meters
  String userPregnancyStage = ""; // Initial stage selection
  String servicesStage = ""; // Initial stage selection
  String servicesStageId = ""; // Store the selected service's ID
  String specialisationStageId = ""; // Store the selected service's ID
  String specialistStage = ""; // Initial stage selection
  List<Map<String, dynamic>> pregnancyStages = [
    {"title": "0-5 km", "value": "0-5 km", "selected": false},
    {"title": "0-10 km", "value": "0-10 km", "selected": false},
    {"title": "0-20 km", "value": "0-20 km", "selected": false},
    {"title": "0-30 km", "value": "0-30 km", "selected": false},
    {"title": "0-50 km", "value": "0-50 km", "selected": false},
    {"title": "0-100 km", "value": "0-100 km", "selected": false},
  ];

  int rangeToValue(String range) {
    final match = RegExp(r'(\d+)-(\d+)').firstMatch(range);
    if (match != null) {
      int lowerBound = int.parse(match.group(1)!);
      int upperBound = int.parse(match.group(2)!);

      // You need to scale the upper bound by 1000 for the final value
      return upperBound * 1000;
    }
    return 0;
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
  List<Doc> specialistStages = [];
  List<Doc> serviceStages = [];

  final TextEditingController profession = TextEditingController();

  bool isButtonEnabled() {
    return userPregnancyStage.isNotEmpty &&
        servicesStage.isNotEmpty &&
        specialistStages.any((stage) => stage.isSelected);
  }

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
    specializationsFetched = false;
  }

  Future<void> _loadDropdownData() async {
    if (isSpecialistDropdownTapped) {
      // Fetch specializations based on the service ID
      if (servicesStage.isNotEmpty && !specializationsFetched) {
        context.read<FindBloc>().add(FetchSpecializations(servicesStageId));
        setState(() {
          specializationsFetched = true; // Flag to prevent repeated API calls
        });
      }
    } else {
      callApi1(); // Fetch services
    }
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Find In Person Consults",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
        body: SafeArea(
          child: BlocListener<FindBloc, FindState>(
            listener: (context, state) {
              if (state is DropdownLoaded) {
                setState(() {
                  serviceStages = state.options;
                });
              } else if (state is SpecialistDropdownLoaded) {
                setState(() {
                  specialistStages = state.specialists;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  const Divider(thickness: 1.2, color: Color(0XFFF6F6F6)),
                  SizedBox(
                    height:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 20.h
                            : 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? 45.h
                            : 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: Container(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text(
                                    Constants.searchPerson,
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.headingTablet
                                        : FTextStyle.heading,
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 18, bottom: 8),
                                  child: Text(
                                    Constants.findWith,
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .loginEmailFieldHeadingStyleTablet
                                        : FTextStyle
                                            .loginEmailFieldHeadingStyle,
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
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
                                      color: AppColors.pinkButton,
                                      size: 30,
                                    ),
                                    hintText: "Select range",
                                    // Set an empty hintText initially
                                    hintStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .formFieldErrorTxtStyleTablet
                                        : FTextStyle
                                            .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                  ),
                                  readOnly: true,
                                  // Making it read-only to show the selected value
                                  controller: TextEditingController(
                                      text: userPregnancyStage),
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
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: pregnancyStages.map((stage) {
                                        final isLastItem =
                                            pregnancyStages.indexOf(stage) ==
                                                pregnancyStages.length - 1;
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  userPregnancyStage =
                                                      stage['value']!;
                                                  pregnancyStages.forEach((s) {
                                                    s['selected'] =
                                                        (s == stage);
                                                  });
                                                  selectedDistance =
                                                      rangeToValue(
                                                          stage['value']!);
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        microseconds: 1500),
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
                                                      setState(() {
                                                        userPregnancyStage =
                                                            stage['value']!;
                                                        pregnancyStages
                                                            .forEach((s) {
                                                          s['selected'] =
                                                              (s == stage);
                                                        });
                                                        selectedDistance =
                                                            rangeToValue(stage[
                                                                'value']!);
                                                      });
                                                      Future.delayed(
                                                          const Duration(
                                                              microseconds:
                                                                  1500), () {
                                                        setState(() {
                                                          isDropdownVisible =
                                                              !isDropdownVisible;
                                                        });
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                                  .circular(3),
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
                                                                Icons.check_box,
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
                                            if (!isLastItem) // Conditionally render the divider
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
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 18, bottom: 8),
                                  child: Text(
                                    Constants.Services,
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .loginEmailFieldHeadingStyleTablet
                                        : FTextStyle
                                            .loginEmailFieldHeadingStyle,
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: serviceVisible
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
                                      color: AppColors.pinkButton,
                                      size: 30,
                                    ),
                                    hintText: "Select Services",
                                    // Set an empty hintText initially
                                    hintStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle
                                            .formFieldErrorTxtStyleTablet
                                        : FTextStyle
                                            .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                  ),
                                  readOnly: true,
                                  // Making it read-only to show the selected value
                                  controller: TextEditingController(
                                      text: servicesStage),
                                  // Setting initial value
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.cardSubtitleTablet
                                      : FTextStyle.cardSubtitle,
                                  maxLines: 1,
                                  onTap: () {
                                    setState(() {
                                      serviceVisible = !serviceVisible;
                                      // Reset specialization whenever the service changes
                                      specialistStages.forEach((stage) => stage.isSelected = false);
                                      specialistStages.clear();
                                      specialisationStageId = "";
                                      specialistStage = "";
                                    });
                                  },
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                                Visibility(
                                  visible: serviceVisible,
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: serviceStages.map((stage) {
                                        final isLastItem =
                                            serviceStages.indexOf(stage) == serviceStages.length - 1;
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  stage.isSelected = true;
                                                  servicesStage = stage.name;
                                                  servicesStageId = stage.id;
                                                  serviceVisible = false;

                                                  // Reset the specialization data
                                                  specialistStages.forEach((stage) => stage.isSelected = false);
                                                  specialistStages.clear();
                                                  specialisationStageId = "";
                                                  specialistStage = "";

                                                  // Reset flags to allow fetching specializations
                                                  isSpecialistDropdownTapped = true;
                                                  specializationsFetched = false;

                                                  for (var s in serviceStages) {
                                                    if (s != stage) {
                                                      s.isSelected = false;
                                                    }
                                                  }
                                                });
                                                // Fetch specializations for the newly selected service
                                                _loadDropdownData();
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        border: Border.all(
                                                          color: stage.isSelected
                                                              ? AppColors.primaryColorPink
                                                              : AppColors.boarderColour,
                                                          width: 1.5,
                                                        ),
                                                        color: stage.isSelected
                                                            ? AppColors.primaryColorPink
                                                            : Colors.white,
                                                      ),
                                                      child: stage.isSelected
                                                          ? const Icon(
                                                        Icons.check_box,
                                                        color: Colors.white,
                                                        size: 24,
                                                      )
                                                          : null,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      stage.name,
                                                      maxLines: 3,
                                                      style: (displayType == 'desktop' ||
                                                          displayType == 'tablet')
                                                          ? FTextStyle.rememberMeTextStyleTablet
                                                          : FTextStyle.rememberMeTextStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (!isLastItem) // Conditionally render the divider
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
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 18, bottom: 8),
                                  child: Text(
                                    Constants.Specialisation,
                                    style: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.loginEmailFieldHeadingStyleTablet
                                        : FTextStyle.loginEmailFieldHeadingStyle,
                                  ),
                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: specialist ? AppColors.boarderColour : AppColors.boarderColour,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.boarderColour, // Color when the field is focused
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.boarderColour, // Color when the field is not focused
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    suffixIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.pinkButton,
                                      size: 30,
                                    ),
                                    hintText: "Select Specialisations",
                                    hintStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' || displayType == 'tablet')
                                        ? FTextStyle.formFieldErrorTxtStyleTablet
                                        : FTextStyle.formFieldErrorTxtStyle,
                                  ),
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: specialistStages
                                        .where((stage) => stage.isSelected)
                                        .map((stage) => stage.name)
                                        .join(', '),
                                  ),
                                  style: (displayType == 'desktop' || displayType == 'tablet')
                                      ? FTextStyle.cardSubtitleTablet
                                      : FTextStyle.cardSubtitle,
                                  maxLines: 1,
                                  onTap: () {
                                    setState(() {
                                      specialist = !specialist;
                                      isSpecialistDropdownTapped = true;
                                    });
                                    _loadDropdownData();
                                  },
                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                Visibility(
                                  visible: specialist,
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: specialistStages.map((stage) {
                                        final isLastItem =
                                            specialistStages.indexOf(stage) == specialistStages.length - 1;

                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  // Toggle selection
                                                  stage.isSelected = !stage.isSelected;
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      border: Border.all(
                                                        color: stage.isSelected
                                                            ? AppColors.primaryColorPink
                                                            : AppColors.boarderColour,
                                                        width: 1.5,
                                                      ),
                                                      color: stage.isSelected
                                                          ? AppColors.primaryColorPink
                                                          : Colors.white,
                                                    ),
                                                    child: stage.isSelected
                                                        ? const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 20,
                                                    )
                                                        : null,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      stage.name,
                                                      maxLines: 3,
                                                      style: (displayType == 'desktop' || displayType == 'tablet')
                                                          ? FTextStyle.rememberMeTextStyleTablet
                                                          : FTextStyle.rememberMeTextStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (!isLastItem)
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
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 20),
                                  child: ElevatedButton(
                                    onPressed: isButtonEnabled()
                                        ? () {
                                            print(
                                                "selectedDistance>>$selectedDistance");
                                            List<String> selectedServicesIds =
                                                serviceStages
                                                    .where((service) =>
                                                        service.isSelected)
                                                    .map((service) =>
                                                        service.id)
                                                    .toList();
                                            List<String>
                                                selectedSpecializationsIds =
                                                specialistStages
                                                    .where((specialization) =>
                                                        specialization
                                                            .isSelected)
                                                    .map((specialization) =>
                                                        specialization.id)
                                                    .toList();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                  create: (context) =>
                                                      FindBloc(),
                                                  child: YourConsultant(
                                                    services: selectedServicesIds,
                                                    specialisations:
                                                        selectedSpecializationsIds,
                                                    maxDistance:
                                                        selectedDistance,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.pinkButton,
                                      textStyle: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle.buttonStyleTablet
                                          : FTextStyle.buttonStyle,
                                      minimumSize: Size(
                                          double.infinity,
                                          (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 45.h
                                              : 52),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Search',
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.buttonStyleTablet
                                            : FTextStyle.buttonStyle,
                                      ),
                                    ),
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  Future<void> callApi1() async {
    BlocProvider.of<FindBloc>(context)
        .add(FetchDropdownOptions("SERVICE", "ACTIVE"));
  }

  Future<void> callApi2() async {
    BlocProvider.of<FindBloc>(context)
        .add(FetchDropdownOptions("SPECIALIZATION", "ACTIVE"));
  }
}

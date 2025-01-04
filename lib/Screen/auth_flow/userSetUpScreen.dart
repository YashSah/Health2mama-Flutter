import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/Auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:health2mama/Screen/program_flow/program.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import '../../Utils/constant.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../Utils/pref_utils.dart';

class UserSetUpScreen extends StatefulWidget {
  const UserSetUpScreen({super.key});

  @override
  State<UserSetUpScreen> createState() => _UserSetUpScreenState();
}

// Define API values corresponding to the constants
final Map<String, String> displayToApiMapping = {
  Constants.stage1: 'TRYINGTOCONCEIVE',
  Constants.stage2: 'PREGNANT',
  Constants.stage3: 'POSTPARTUM',
  Constants.stage41: 'BEYOND',
};
List<String> categories = [
  'Advice',
  'Tracker',
  'Workout',
  'Recipes',
  'Pelvic Floor',
  'Abs & Core',
  'Community',
  'Expert Help',
];

List<bool> isChecked = List<bool>.filled(categories.length, false);
List<String> selectedCategoryIds = [];

class _UserSetUpScreenState extends State<UserSetUpScreen> {
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
  bool isButtonEnabled = false;
  bool isDropdownVisible = false;
  bool stage1check = false;
  bool stage2check = false;
  bool stage3check = false;
  bool stage4check = false;
  String userPregnencyStage = "Please choose an option below";

  bool checkDropdown() {
    if (stage1check || stage2check || stage3check || stage4check) {
      return true;
    }
    return false;
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
            resizeToAvoidBottomInset: true,
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
                      left:
                          (displayType == 'desktop' || displayType == 'tablet')
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
                    height:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 35.h
                            : 35, // Set height as needed
                  ),
                ),
              ),
            ),
            body: BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is SelectStageLoading) {
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                        child:
                            CircularProgressIndicator(color: AppColors.pink)),
                  );
                } else if (state is SelectStageSuccess) {
                  PrefUtils.setIsLogin(true);
                  Navigator.of(context).pop(); // Close the loading dialog
                } else if (state is SelectStageFailure) {
                  Navigator.of(context).pop(); // Close the loading dialog
                } else if (state is UpdatePreferenceSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomBottomNavigationBar(),
                    ),
                  );
                }
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 15.h
                              : 15.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
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
                        ),
                      ),
                      Container(
                        // width: 360,
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
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        Constants.setupScreenHeading,
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.loginTitleStyleTablet
                                            : FTextStyle.loginTitleStyle,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        color: AppColors.editTextBorderColor,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          Constants.setupScreenDropdown1,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .setupScreenFieldsHeadingStyleTablet
                                              : FTextStyle
                                                  .setupScreenFieldsHeadingStyle,
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isDropdownVisible =
                                                !isDropdownVisible;
                                          });
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isDropdownVisible
                                                  ? AppColors
                                                      .editTextBorderColorfocused
                                                  : AppColors
                                                      .editTextBorderColorenabled,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  userPregnencyStage,
                                                  style:
                                                      (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? FTextStyle
                                                              .cardSubtitleTablet
                                                          : FTextStyle
                                                              .cardSubtitle,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              IconButton(
                                                alignment: Alignment.center,
                                                icon: Icon(
                                                  isDropdownVisible
                                                      ? Icons.arrow_drop_up
                                                      : Icons.arrow_drop_down,
                                                  color: AppColors
                                                      .authScreensHeading,
                                                  size: 24,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isDropdownVisible =
                                                        !isDropdownVisible;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ),
                                      Visibility(
                                        visible: isDropdownVisible,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 30),
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: AppColors.lightGreyColor,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(),
                                                    child: Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              stage1check =
                                                                  !stage1check;
                                                              stage2check =
                                                                  false;
                                                              stage3check =
                                                                  false;
                                                              stage4check =
                                                                  false;
                                                              userPregnencyStage =
                                                                  stage1check
                                                                      ? Constants
                                                                          .stage1
                                                                      : "Please choose an option below";
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
                                                                  setState(() {
                                                                    stage1check =
                                                                        !stage1check;
                                                                    stage2check =
                                                                        false;
                                                                    stage3check =
                                                                        false;
                                                                    stage4check =
                                                                        false;
                                                                    userPregnencyStage = stage1check
                                                                        ? Constants
                                                                            .stage1
                                                                        : "Please choose an option below";
                                                                  });
                                                                  // Convert display stage to API value
                                                                  String
                                                                      apiStage =
                                                                      displayToApiMapping[
                                                                              userPregnencyStage] ??
                                                                          '';
                                                                  // Dispatch event to BLoC with the API value
                                                                  final authenticationBloc =
                                                                      BlocProvider.of<
                                                                              AuthenticationBloc>(
                                                                          context);
                                                                  authenticationBloc.add(
                                                                      SelectStageRequested(
                                                                          stage:
                                                                              apiStage));
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
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              5),
                                                                  child: IconTheme(
                                                                      data: const IconThemeData(
                                                                          color: AppColors
                                                                              .primaryColorPink,
                                                                          weight:
                                                                              14),
                                                                      child: Icon(stage1check
                                                                          ? Icons
                                                                              .check_box
                                                                          : Icons
                                                                              .check_box_outline_blank)),
                                                                ),
                                                              ),
                                                              Text(
                                                                Constants
                                                                    .stage1,
                                                                style: (displayType ==
                                                                            'desktop' ||
                                                                        displayType ==
                                                                            'tablet')
                                                                    ? FTextStyle
                                                                        .rememberMeTextStyleTablet
                                                                    : FTextStyle
                                                                        .rememberMeTextStyle,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  bottom: 10),
                                                          child: Divider(
                                                            color: AppColors
                                                                .darkGreyColor,
                                                            height: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                        padding: const EdgeInsets
                                                            .only(),
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  stage2check =
                                                                      !stage2check;
                                                                  stage1check =
                                                                      false;
                                                                  stage3check =
                                                                      false;
                                                                  stage4check =
                                                                      false;
                                                                  userPregnencyStage = stage2check
                                                                      ? Constants
                                                                          .stage2
                                                                      : "Please choose an option below";
                                                                });
                                                                final authenticationBloc =
                                                                    BlocProvider.of<
                                                                            AuthenticationBloc>(
                                                                        context);
                                                                // Dispatch event to BLoC
                                                                authenticationBloc.add(
                                                                    SelectStageRequested(
                                                                        stage:
                                                                            userPregnencyStage));
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
                                                                        stage2check =
                                                                            !stage2check;
                                                                        stage1check =
                                                                            false;
                                                                        stage3check =
                                                                            false;
                                                                        stage4check =
                                                                            false;
                                                                        userPregnencyStage = stage2check
                                                                            ? Constants.stage2
                                                                            : "Please choose an option below";
                                                                      });
                                                                      // Convert display stage to API value
                                                                      String
                                                                          apiStage =
                                                                          displayToApiMapping[userPregnencyStage] ??
                                                                              '';
                                                                      // Dispatch event to BLoC with the API value
                                                                      final authenticationBloc =
                                                                          BlocProvider.of<AuthenticationBloc>(
                                                                              context);
                                                                      authenticationBloc.add(SelectStageRequested(
                                                                          stage:
                                                                              apiStage));
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              microseconds: 1500),
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
                                                                              5),
                                                                      child: IconTheme(
                                                                          data: const IconThemeData(
                                                                              color: AppColors
                                                                                  .primaryColorPink,
                                                                              weight:
                                                                                  14),
                                                                          child: Icon(stage2check
                                                                              ? Icons.check_box
                                                                              : Icons.check_box_outline_blank)),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    Constants
                                                                        .stage2,
                                                                    style: (displayType ==
                                                                                'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                        ? FTextStyle
                                                                            .rememberMeTextStyleTablet
                                                                        : FTextStyle
                                                                            .rememberMeTextStyle,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 15,
                                                                        bottom:
                                                                            10),
                                                                child: Divider(
                                                                  color: AppColors
                                                                      .darkGreyColor,
                                                                  height: 1,
                                                                )),
                                                          ],
                                                        ))
                                                    .animateOnPageLoad(
                                                        animationsMap[
                                                            'imageOnPageLoadAnimation2']!),
                                                Padding(
                                                        padding: const EdgeInsets
                                                            .only(),
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  stage3check =
                                                                      !stage3check;
                                                                  stage2check =
                                                                      false;
                                                                  stage1check =
                                                                      false;
                                                                  stage4check =
                                                                      false;
                                                                  userPregnencyStage = stage3check
                                                                      ? Constants
                                                                          .stage3
                                                                      : "Please choose an option below";
                                                                });
                                                                // Convert display stage to API value
                                                                String
                                                                    apiStage =
                                                                    displayToApiMapping[
                                                                            userPregnencyStage] ??
                                                                        '';
                                                                // Dispatch event to BLoC with the API value
                                                                final authenticationBloc =
                                                                    BlocProvider.of<
                                                                            AuthenticationBloc>(
                                                                        context);
                                                                authenticationBloc.add(
                                                                    SelectStageRequested(
                                                                        stage:
                                                                            apiStage));
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
                                                                        stage3check =
                                                                            !stage3check;
                                                                        stage2check =
                                                                            false;
                                                                        stage1check =
                                                                            false;
                                                                        stage4check =
                                                                            false;
                                                                        userPregnencyStage = stage3check
                                                                            ? Constants.stage3
                                                                            : "Please choose an option below";
                                                                      });
                                                                      // Convert display stage to API value
                                                                      String
                                                                          apiStage =
                                                                          displayToApiMapping[userPregnencyStage] ??
                                                                              '';
                                                                      // Dispatch event to BLoC with the API value
                                                                      final authenticationBloc =
                                                                          BlocProvider.of<AuthenticationBloc>(
                                                                              context);
                                                                      authenticationBloc.add(SelectStageRequested(
                                                                          stage:
                                                                              apiStage));
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              microseconds: 1500),
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
                                                                              5),
                                                                      child: IconTheme(
                                                                          data: const IconThemeData(
                                                                              color: AppColors
                                                                                  .primaryColorPink,
                                                                              weight:
                                                                                  14),
                                                                          child: Icon(stage3check
                                                                              ? Icons.check_box
                                                                              : Icons.check_box_outline_blank)),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      Constants
                                                                          .stage3,
                                                                      style: (displayType == 'desktop' ||
                                                                              displayType ==
                                                                                  'tablet')
                                                                          ? FTextStyle
                                                                              .rememberMeTextStyleTablet
                                                                          : FTextStyle
                                                                              .rememberMeTextStyle,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 15,
                                                                        bottom:
                                                                            10),
                                                                child: Divider(
                                                                  color: AppColors
                                                                      .darkGreyColor,
                                                                  height: 1,
                                                                )),
                                                          ],
                                                        ))
                                                    .animateOnPageLoad(
                                                        animationsMap[
                                                            'imageOnPageLoadAnimation2']!),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        stage4check =
                                                            !stage4check;
                                                        stage2check = false;
                                                        stage3check = false;
                                                        stage1check = false;
                                                        userPregnencyStage =
                                                            stage4check
                                                                ? Constants
                                                                    .stage41
                                                                : "Please choose an option below";
                                                      });
                                                      // Convert display stage to API value
                                                      String apiStage =
                                                          displayToApiMapping[
                                                                  userPregnencyStage] ??
                                                              '';
                                                      // Dispatch event to BLoC with the API value
                                                      final authenticationBloc =
                                                          BlocProvider.of<
                                                                  AuthenticationBloc>(
                                                              context);
                                                      authenticationBloc.add(
                                                          SelectStageRequested(
                                                              stage: apiStage));
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
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              stage4check =
                                                                  !stage4check;
                                                              stage2check =
                                                                  false;
                                                              stage3check =
                                                                  false;
                                                              stage1check =
                                                                  false;
                                                              userPregnencyStage =
                                                                  stage4check
                                                                      ? Constants
                                                                          .stage41
                                                                      : "Please choose an option below";
                                                            });
                                                            // Convert display stage to API value
                                                            String apiStage =
                                                                displayToApiMapping[
                                                                        userPregnencyStage] ??
                                                                    '';
                                                            // Dispatch event to BLoC with the API value
                                                            final authenticationBloc =
                                                                BlocProvider.of<
                                                                        AuthenticationBloc>(
                                                                    context);
                                                            authenticationBloc.add(
                                                                SelectStageRequested(
                                                                    stage:
                                                                        apiStage));
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
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 5),
                                                            child: IconTheme(
                                                                data: const IconThemeData(
                                                                    color: AppColors
                                                                        .primaryColorPink,
                                                                    weight: 14),
                                                                child: Icon(stage4check
                                                                    ? Icons
                                                                        .check_box
                                                                    : Icons
                                                                        .check_box_outline_blank)),
                                                          ),
                                                        ),
                                                        Text(
                                                          Constants.stage41,
                                                          style: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? FTextStyle
                                                                  .rememberMeTextStyleTablet
                                                              : FTextStyle
                                                                  .rememberMeTextStyle,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ).animateOnPageLoad(animationsMap[
                                                    'imageOnPageLoadAnimation2']!),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        child: Text(
                                          Constants.setupScreenDropdown2,
                                          style: (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? FTextStyle
                                                  .setupScreenFieldsHeadingStyleTablet
                                              : FTextStyle
                                                  .setupScreenFieldsHeadingStyle,
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ),
                                      BlocBuilder<AuthenticationBloc,
                                          AuthenticationState>(
                                        builder: (context, state) {
                                          if (state is SelectStageSuccess) {
                                            final List<dynamic> categories =
                                                state.SelectStageResponse[
                                                        'result'] ??
                                                    [];

                                            // Initialize the isChecked list based on the number of categories
                                            if (isChecked.length !=
                                                categories.length) {
                                              isChecked = List.generate(
                                                  categories.length,
                                                  (index) => false);
                                            }

                                            return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio: 4,
                                                  ),
                                                  itemCount: categories.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final category =
                                                        categories[index];
                                                    final categoryId =
                                                        category['_id'];
                                                    final categoryName = category[
                                                            'categoryName'] ??
                                                        'Unknown';

                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFFF58CA9)),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            value: isChecked[
                                                                index],
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                isChecked[
                                                                        index] =
                                                                    value!;
                                                                if (value) {
                                                                  selectedCategoryIds
                                                                      .add(
                                                                          categoryId);
                                                                } else {
                                                                  selectedCategoryIds
                                                                      .remove(
                                                                          categoryId);
                                                                }
                                                              });
                                                            },
                                                            activeColor: Color(
                                                                0xFFF58CA9),
                                                            checkColor:
                                                                Colors.white,
                                                            side: BorderSide(
                                                                color: Color(
                                                                    0xFFF58CA9)),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              categoryName,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              maxLines:
                                                                  1, // Ensure single-line text
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Adds '...' when the text is too long
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ));
                                          } else if (state
                                              is SelectStageFailure) {
                                            final errorMessage =
                                                state.SelectStageFailureResponse[
                                                        'error'] ??
                                                    'Unknown error';
                                            return Center(
                                                child: Image.asset(
                                                    'assets/Images/somethingwentwrong.png'));
                                          } else {
                                            return Center(
                                                child: Text(
                                                    'Please select a stage first...'));
                                          }
                                        },
                                      )
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 25, right: 25),
                                child: SizedBox(
                                  width: width,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: checkDropdown()
                                        ? () {
                                            // Safely handle the nullable return value
                                            final userStage =
                                                displayToApiMapping[
                                                    userPregnencyStage];
                                            if (userStage == null) {
                                              // Handle the null case, e.g., log an error or show a message
                                              print(
                                                  'Error: Invalid pregnancy stage');
                                              return;
                                            }

                                            // Set the user stage
                                            PrefUtils.setUserStage(userStage);
                                            print(PrefUtils.getUserStage());

                                            // Dispatch the UpdatePreferenceRequested event with the correct token and screenName
                                            BlocProvider.of<AuthenticationBloc>(
                                                    context)
                                                .add(
                                              UpdatePreferenceRequested(
                                                stage: userStage,
                                                categoryIds:
                                                    selectedCategoryIds,
                                              ),
                                            );
                                          }
                                        : null, // Disable the button if checkDropdown() is false
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      backgroundColor:
                                          AppColors.primaryColorPink,
                                    ),
                                    child: Text(Constants.setupScreenButton,
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.loginwithBtnStyleTablet
                                            : FTextStyle.loginwithBtnStyle),
                                  ),
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ]),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/custom_radio.dart';
import 'package:health2mama/Utils/submisson_dialog.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import '../../Utils/pref_utils.dart';

class EditQuiz extends StatefulWidget {
  const EditQuiz({super.key});

  @override
  State<EditQuiz> createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  String? selectedOption;
  @override
  void initState() {
    super.initState();
    _fetchUserStage();
  }

  final List<Map<String, dynamic>> sectionTopicdata1 = [
    {
      'text': 'Trying to Conceive',
    },
    {
      'text': 'Pregnant',
    },
    {
      'text': 'Postpartum (0-6 Weeks After\nBirth)',
    },
    {
      'text': 'Beyond -(6 Weeks + After Birth\n(Weeks, Months, Years)',
    },
  ];

  final Map<String, String> textToServerFormat = {
    'Trying to Conceive': 'TRYINGTOCONCEIVE',
    'Pregnant': 'PREGNANT',
    'Postpartum (0-6 Weeks After\nBirth)': 'POSTPARTUM',
    'Beyond -(6 Weeks + After Birth\n(Weeks, Months, Years)': 'BEYOND',
  };
  final Map<String, String> serverToTextFormat = {
    'TRYINGTOCONCEIVE': 'Trying to Conceive',
    'PREGNANT': 'Pregnant',
    'POSTPARTUM': 'Postpartum (0-6 Weeks After\nBirth)',
    'BEYOND': 'Beyond -(6 Weeks + After Birth\n(Weeks, Months, Years)',
  };

  Future<void> _fetchUserStage() async {
    String? stage = await PrefUtils.getUserStage(); // Fetch user stage
    setState(() {
      selectedOption = serverToTextFormat[
          stage]; // Set selected option based on the fetched value
    });
  }

  Future<void> _submit(BuildContext context) async {
    if (selectedOption != null) {
      final stage = textToServerFormat[selectedOption];
      final categoryIds = await PrefUtils.getCategoryIds();

      if (stage != null) {
        PrefUtils.setUserStage(stage);
        BlocProvider.of<AuthenticationBloc>(context).add(
          UpdatePreferenceRequested(
            stage: stage,
            categoryIds: categoryIds,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomNavigationBar(),
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is UpdatePreferenceSuccess) {
            final stage = textToServerFormat[selectedOption];
            if (stage != null) {
              PrefUtils.setUserStage(stage);
            }
            BlocProvider.of<AuthenticationBloc>(context)
                .add(SelectStageRequested(stage: PrefUtils.getUserStage()));
          } else if (state is UpdatePreferenceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${state.updatePreferenceFailureResponse}')),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Edit QUIZ",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.appBarTitleStyleTablet
                    : FTextStyle.appBarTitleStyle,
              ),
            ),
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
                      : 3,
                ),
                child: Image.asset(
                  'assets/Images/back.png', // Replace with your image path
                  width: (displayType == 'desktop' || displayType == 'tablet')
                      ? 24.w
                      : 24,
                  height: (displayType == 'desktop' || displayType == 'tablet')
                      ? 24.h
                      : 24,
                ),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 1, color: AppColors.dark1),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 40.h
                              : screenWidth * 0.03,
                          vertical: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 30.h
                              : screenWidth * 0.01,
                        ),
                        child: Card(
                          color: AppColors.cardBack,
                          elevation: 0.05,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.05, top: 10),
                                child: Text(
                                  "Which option interests you now?",
                                  style: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? FTextStyle.forumTopicsTitleTap
                                      : FTextStyle.forumTopicsTitle,
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sectionTopicdata1.length,
                                itemBuilder: (context, index) {
                                  String key = sectionTopicdata1[index]['text'];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = key;
                                      });
                                    },
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    hoverColor: Colors.transparent,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.05,
                                            vertical: screenHeight * 0.004,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    key,
                                                    style:
                                                        (displayType ==
                                                                    'desktop' ||
                                                                displayType ==
                                                                    'tablet')
                                                            ? FTextStyle
                                                                .ForumsNameTitleTab
                                                            : FTextStyle
                                                                .ForumsNameTitle,
                                                  ).animateOnPageLoad(animationsMap[
                                                      'imageOnPageLoadAnimation2']!),
                                                ],
                                              ),
                                              CustomRadio(
                                                value: key,
                                                groupValue: selectedOption,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedOption = newValue;
                                                  });
                                                },
                                              ).animateOnPageLoad(animationsMap[
                                                  'imageOnPageLoadAnimation2']!)
                                            ],
                                          ),
                                        ),
                                        if (index !=
                                            sectionTopicdata1.length - 1)
                                          Divider(
                                            thickness: 1,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            indent: 16,
                                            endIndent: 16,
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 28, horizontal: 28),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 220.h
                                            : screenWidth * 0.47,
                                        (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 45.h
                                            : screenHeight * 0.06,
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return AppColors.boarderColour
                                              .withOpacity(0.5);
                                        }
                                        return AppColors.appBlue;
                                      },
                                    ),
                                  ),
                                  onPressed: selectedOption != null
                                      ? () => _submit(context)
                                      : null,
                                  child: Text(
                                    'Continue',
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.ForumsButtonStylingTab
                                        : FTextStyle.ForumsButtonStyling,
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

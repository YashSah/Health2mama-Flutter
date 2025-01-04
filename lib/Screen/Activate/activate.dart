import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/Activate/activate_setting.dart';
import 'package:health2mama/Screen/Activate/exercise.dart';
import 'package:health2mama/Screen/Activate/learn.dart';
import 'package:health2mama/Screen/Activate/tab_to_start.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/Activate/set_reminder.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/Activate/activate_bloc.dart';
import 'package:health2mama/apis/Activate/activate_event.dart';
import 'package:health2mama/apis/Activate/activate_state.dart';

class Activate extends StatefulWidget {
  const Activate({Key? key}) : super(key: key);

  @override
  State<Activate> createState() => _ActivateState();
}

class _ActivateState extends State<Activate> {
  List<Map<String, dynamic>> containersData = [
    {
      'color': Color(0XFFFFE1E9),
      'image': 'assets/Images/icon1.png',
      'Text': 'Learn How To Activate',
    },
    {
      'color': Color(0XFFE1E8FF),
      'image': 'assets/Images/icon2.png',
      'Text': 'Set Reminders',
    },
    {
      'color': Color(0XFFE5E1FF),
      'image': 'assets/Images/icon3.png',
      'Text': 'Exercise Records',
    },
    {
      'color': Color(0XFFFFE1E9),
      'image': 'assets/Images/icon4.png',
      'Text': 'Activate Now',
    },
    {
      'color': Color(0XFFFFEFE1),
      'image': 'assets/Images/icon5.png',
      'Text': 'Pro Settings',
    }
  ];
  final userStage = PrefUtils.getUserStage();
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

  String videoUrlSquezzes = '';
  String videoUrlReps = '';
  String videoUrlEndurance = '';
  String videoUrlRepsDes = '';
  String videoUrlSquezzesDes = '';
  String videoUrlEnduranceDes = '';

  @override
  void initState() {
    BlocProvider.of<ActivateBloc>(context).add(FetchLearnHowToActivate());
    super.initState();
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LearnActivate()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SetReminderScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Exercise()));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TabToStart(
                      repsDescription: videoUrlRepsDes,
                      squeezesDescription: videoUrlSquezzesDes,
                      enduranceDescription: videoUrlEnduranceDes,
                    )));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ActivateSetting()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ActivateBloc, LearnHowToActivateState>(
        listener: (context, state) {
          if (state is LearnHowToActivateLoading) {
            Center(child: CircularProgressIndicator(color: AppColors.pink));
          } else if (state is LearnHowToActivateLoaded) {
            var matchedContent = state.successResponse['result'].firstWhere(
              (exercise) => exercise['stage'] == userStage,
              orElse: () => null,
            );
            if (matchedContent != null) {
              setState(() {
                videoUrlReps = matchedContent['reps']['videoUrl'];
                videoUrlSquezzes = matchedContent['squeezes']
                    ['videoUrl']; // Squeezes video URL
                videoUrlEndurance = matchedContent['endurance']['videoUrl'];
                videoUrlEnduranceDes =
                    matchedContent['endurance']['description'];
                videoUrlSquezzesDes = matchedContent['squeezes']['description'];
                videoUrlRepsDes = matchedContent['reps']['description'];
                print("videoUrlReps:  ${videoUrlReps}");
                print("videoUrlSquezzes:  ${videoUrlSquezzes}");
                print("videoUrlEndurance:  ${videoUrlEndurance}");

                PrefUtils.setRepsVideo(videoUrlReps);
                PrefUtils.setSquezzesVideo(videoUrlSquezzes);
                PrefUtils.setEnduranceVideo(videoUrlEndurance);
              });
            }
          }
        },
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.007),
                      child: Divider(
                        thickness: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? screenHeight * 0.0015
                            : screenHeight * 0.0012,
                        color: Color(0XFFF6F6F6),
                      ),
                    ),
                    SizedBox(
                      height:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 30.h
                              : 0,
                    ),
                    ...containersData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final containerData = entry.value;
                      return GestureDetector(
                        onTap: () {
                          _navigateToPage(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 30.w
                                  : screenWidth * 0.04,
                              vertical: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 6.w
                                  : screenHeight * 0.007),
                          child: Container(
                            height: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 120.h
                                : screenHeight * 0.11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: containerData['color'],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? 40.w
                                      : screenWidth * 0.11),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    containerData['image'],
                                    // Corrected access to image path using containerData
                                    width: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 40.w
                                        : screenWidth * 0.1,
                                    height: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 40.h
                                        : screenHeight * 0.030,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03),
                                    child: Text(containerData['Text'],
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.ActivateTitleTablet
                                            : FTextStyle.ActivateTitle),
                                  )
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

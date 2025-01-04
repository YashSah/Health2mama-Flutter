import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';

class ActivateSetting extends StatefulWidget {
  const ActivateSetting({Key? key}) : super(key: key);

  @override
  State<ActivateSetting> createState() => _ActivateSettingState();
}

class _ActivateSettingState extends State<ActivateSetting> {
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
  int squeezes = 5;
  int strength = 3;
  int endurance = 10;

  void _updatePref(String key, int value) {
    switch (key) {
      case 'squeezes':
        if (value >= 1 && value <= 60) {
          PrefUtils.setSqueezes(value);
          setState(() {
            squeezes = value;
          });
        }
        break;
      case 'strength':
        if (value >= 1 && value <= 10) {
          PrefUtils.setStrength(value);
          setState(() {
            strength = value;
          });
        }
        break;
      case 'endurance':
        if (value >= 10 && value <= 60 && value % 10 == 0) {
          PrefUtils.setEndurance(value);
          setState(() {
            endurance = value;
          });
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      squeezes = PrefUtils.getSqueezes() == 0 ? 5 : PrefUtils.getSqueezes();
      strength = PrefUtils.getStrength() == 0 ? 3 : PrefUtils.getStrength();
      endurance = PrefUtils.getEndurance() == 0 ? 10 : PrefUtils.getEndurance();
    });
  }

  // Updated containersData to link with the actual state
  List<Map<String, dynamic>> get containersData => [
        {
          'color': const Color(0XFFE1E8FF),
          'text': 'Squeezes',
          'miniText': 'Set Number',
          'value': squeezes,
        },
        {
          'color': const Color(0XFFFFEFE1),
          'text': 'Strength Reps',
          'miniText': 'Set Number of reps',
          'value': strength,
        },
        {
          'color': const Color(0XFFE1F4FF),
          'text': 'Endurance Hold',
          'miniText': 'Set Hold time (sec)',
          'value': endurance,
        }
      ];

  customStepper(
      int value, Function() onDecrement, Function() onIncrement, String key) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return Row(
      children: [
        Container(
          width:
              (displayType == 'desktop' || displayType == 'tablet') ? 90.h : 70,
          height:
              (displayType == 'desktop' || displayType == 'tablet') ? 40.h : 35,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: (displayType == 'desktop' || displayType == 'tablet')
                  ? 20.h
                  : 18,
              color: Colors.black,
            ),
          ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: (displayType == 'desktop' || displayType == 'tablet')
                ? 10.h
                : 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (key == 'endurance') {
                    if (value + 10 <= 60) {
                      _updatePref(key, value + 10); // Increment by 10
                    }
                  } else {
                    onIncrement(); // Regular increment
                  }
                },
                child: Container(
                  width: (displayType == 'desktop' || displayType == 'tablet')
                      ? 30.w
                      : 30,
                  height: (displayType == 'desktop' || displayType == 'tablet')
                      ? 20.h
                      : 17.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9DA5C1),
                  ),
                  child: Icon(
                    Icons.arrow_drop_up,
                    color: Colors.black,
                    size: (displayType == 'desktop' || displayType == 'tablet')
                        ? 20.h
                        : 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (key == 'endurance') {
                    if (value - 10 >= 10) {
                      _updatePref(key, value - 10); // Decrement by 10
                    }
                  } else {
                    onDecrement(); // Regular decrement
                  }
                },
                child: Container(
                  width: (displayType == 'desktop' || displayType == 'tablet')
                      ? 30.w
                      : 30,
                  height: (displayType == 'desktop' || displayType == 'tablet')
                      ? 20.h
                      : 17.5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9DA5C1),
                  ),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: (displayType == 'desktop' || displayType == 'tablet')
                        ? 20.h
                        : 18,
                  ),
                ),
              ),
            ],
          ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(
              left: (displayType == 'desktop' || displayType == 'tablet')
                  ? 10.w
                  : 8.0),
          child: Text(
            "Pro Settings",
            style: (displayType == 'desktop' || displayType == 'tablet')
                ? FTextStyle.appBarTitleStyleTablet
                : FTextStyle.appTitleStyle,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            print('You Have Set Squeezes To ${PrefUtils.getSqueezes()}');
            print('You Have Set Strength To ${PrefUtils.getStrength()}');
            print('You Have Set Endurance To ${PrefUtils.getEndurance()}');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 4.w
                        : screenWidth * 0.03),
            child: Image.asset(
              'assets/Images/back.png', // Replace with your image path
              width: (displayType == 'desktop' || displayType == 'tablet')
                  ? 35.w
                  : 35,
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 35.h
                  : 35,
            ),
          ),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal:
                    (displayType == 'desktop' || displayType == 'tablet')
                        ? 30.h
                        : screenWidth * 0.007),
            child: Column(
              children: [
                Divider(
                  thickness: screenHeight * 0.0012,
                  color: const Color(0XFFF6F6F6),
                ),
                SizedBox(
                    height:
                        (displayType == 'desktop' || displayType == 'tablet')
                            ? 30.h
                            : 0),
                ...containersData.map((containerData) {
                  String key;
                  switch (containerData['text']) {
                    case 'Squeezes':
                      key = 'squeezes';
                      break;
                    case 'Strength Reps':
                      key = 'strength';
                      break;
                    case 'Endurance Hold':
                      key = 'endurance';
                      break;
                    default:
                      key = '';
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 30.h
                              : screenWidth * 0.04,
                      vertical:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 10.h
                              : screenHeight * 0.012,
                    ),
                    child: Container(
                      height:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 130.h
                              : screenHeight * 0.16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: containerData['color'],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? 20.h
                                      : screenWidth * 0.06,
                                ),
                                child: Text(containerData['text'],
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.forumMainHeadingTab
                                        : FTextStyle.forumMainHeading),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? 20.h
                                      : screenWidth * 0.06,
                                ),
                                child: Text(containerData['miniText'],
                                    style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? FTextStyle.ForumsTextFieldTitleTab
                                        : FTextStyle.ForumsTextField),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation2']!),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? 40.h
                                    : screenWidth * 0.02),
                            child: customStepper(
                              containerData['value'],
                              () {
                                int currentValue = containerData['value'];
                                if (currentValue > 0) {
                                  _updatePref(key, currentValue - 1);
                                }
                              },
                              () {
                                // Increment handler
                                int currentValue = containerData['value'];
                                _updatePref(key, currentValue + 1);
                              },
                              key,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

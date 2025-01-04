/*
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/Auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/flutter_button_style.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
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


  final List<Map<String, dynamic>> sectionTopicdata1 = [
    {
      'image': 'assets/Images/getstarted1.png',
      'text': 'Advice',
    },
    {
      'image': 'assets/Images/get2.png',
      'text': 'Workouts',
    },
    {
      'image': 'assets/Images/get3.png',
      'text': 'Recipes',
    },
    {
      'image': 'assets/Images/get4.png',
      'text': 'Trackers',
    },
    {
      'image': 'assets/Images/get5.png',
      'text': 'Find a Friend',
    },
    {
      'image': 'assets/Images/get6.png',
      'text': 'Find a Professional',
    },

  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Divider(height: 1, color: AppColors.cardBack),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Image(image: AssetImage("assets/Images/getstarted_header_img.png")),
                      SizedBox(height: width * 0.03),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns in the grid
                              crossAxisSpacing: 4, // Spacing between columns
                              mainAxisSpacing: 4, // Spacing between rows
                              childAspectRatio: 1.2, // Adjust this value based on your height and width needs
                            ),
                            itemCount: sectionTopicdata1.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 2,
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image(
                                            image: AssetImage(sectionTopicdata1[index]['image']),
                                            width: width,
                                            fit: BoxFit.cover,
                                          ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          sectionTopicdata1[index]['text'],
                                          style: FTextStyle.getStartCartTextStyle,
                                        ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                Image.asset(
                  "assets/Images/Rectangle_shadow.png",
                ),
                Positioned(
                  left: 110,
                  right: 110,
                  bottom: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: 37.0,
                      height: 43.0,
                      decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.primaryColorPink), borderRadius: BorderRadius.circular(10),),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: FButtonStyle.subscriptionBtnStyle(),
                            child: const Text(
                              'Get Start',
                              style: FTextStyle.getStartButtonSize,
                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!)
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),


    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/Auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_button_style.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
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

  final List<Map<String, dynamic>> sectionTopicdata1 = [
    {
      'image': 'assets/Images/getstarted1.png',
      'text': 'Advice',
    },
    {
      'image': 'assets/Images/get2.png',
      'text': 'Workouts',
    },
    {
      'image': 'assets/Images/get3.png',
      'text': 'Recipes',
    },
    {
      'image': 'assets/Images/get4.png',
      'text': 'Trackers',
    },
    {
      'image': 'assets/Images/get5.png',
      'text': 'Find a Friend',
    },
    {
      'image': 'assets/Images/get6.png',
      'text': 'Find a Professional',
    },
    {
      'image': 'assets/Images/get4.png',
      'text': 'Trackers',
    },
    {
      'image': 'assets/Images/get5.png',
      'text': 'Find a Friend',
    },
    {
      'image': 'assets/Images/get6.png',
      'text': 'Find a Professional',
    },
    {
      'image': 'assets/Images/get4.png',
      'text': 'Trackers',
    },
    {
      'image': 'assets/Images/get5.png',
      'text': 'Find a Friend',
    },
    {
      'image': 'assets/Images/get6.png',
      'text': 'Find a Professional',
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: (displayType == 'desktop' ||  displayType == 'tablet') ? EdgeInsets.symmetric(horizontal: 15.h) : const EdgeInsets.all(15.0),
            child: Column(
              children: [
                (displayType == 'desktop' ||  displayType == 'tablet')
                    ? const Image(image: AssetImage("assets/Images/tablet_get_started.png"))
                    : const Image(image: AssetImage("assets/Images/getstarted_header_img.png")),
                SizedBox(height: width * 0.03),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (displayType == 'desktop' || displayType == 'tablet') ? 3 : 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio:
                        1.2,
                      ),
                      itemCount: sectionTopicdata1.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    child: Image(
                                      image: AssetImage(
                                          sectionTopicdata1[index]
                                          ['image']),
                                      width: width,
                                      fit: BoxFit.cover,
                                    ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    sectionTopicdata1[index]['text'],
                                    style:
                                    FTextStyle.getStartCartTextStyle,
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                Image.asset(
                  "assets/Images/Rectangle_shadow.png",
                ),
                Positioned(
                  left: 110.w,
                  right: 110.w,
                  bottom: 27.h,
                  child: Padding(
                    padding: EdgeInsets.all(18.h),
                    child: Container(
                      width: 37.w,
                      height: 43.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: AppColors.primaryColorPink),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3.h),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: FButtonStyle.subscriptionBtnStyle(),
                            child: const Text(
                              'Get Start',
                              style: FTextStyle.getStartButtonSize,
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


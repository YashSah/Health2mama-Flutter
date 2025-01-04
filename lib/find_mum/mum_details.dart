import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

import '../../Utils/CommonFuction.dart';

class MumDetails extends StatefulWidget {
  const MumDetails({super.key});

  @override
  State<MumDetails> createState() => _MumDetailsState();
}

class _MumDetailsState extends State<MumDetails> {
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
  final List<Map<String, dynamic>> mumDetails = [
    {
      'title': 'Work Status',
      'value': 'Full Time',
    },
    {
      'title': 'Exercise | Enjoy',
      'value': 'Walks, Ball Sport',
    },
    {
      'title': 'Other Interest',
      'value': 'Reading, Music',
    },
    {
      'title': 'Language Known',
      'value': 'English, French',
    },
    {
      'title': 'Status',
      'value': 'Connected',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Mum Details", style: (displayType == 'desktop' || displayType == 'tablet')
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
                  ? 35.w
                  : 35, // Set width as needed
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 35.h
                  : 35, // Set height as needed
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Divider(
            thickness: 1.2,
            color: Color(0XFFF6F6F6),
          ),
          Padding(
            padding: (displayType == 'desktop' || displayType == 'tablet') ? EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w) : EdgeInsets.zero,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 1.5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: (displayType == 'desktop' || displayType == 'tablet')? 45.w:  72,
                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 45.w: 72,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.filterBackroundColor,
                                          width: 3),
                                      shape: BoxShape.circle),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/Images/mom.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Minakshi Singh',
                                            style:
                                            (displayType == 'desktop' || displayType == 'tablet')
                                                ? FTextStyle
                                                .tabToStart2TextStyleTablet : FTextStyle
                                                .tabToStart2TextStyle,
                                          ),
                                        ],
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Trying to Conceive',
                                              style: (displayType == 'desktop' || displayType == 'tablet')
                                                  ?  FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style,
                                            ).animateOnPageLoad(animationsMap[
                                                'imageOnPageLoadAnimation2']!),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Have Kids-Ages 3,4',
                                              style: (displayType == 'desktop' || displayType == 'tablet')
                                                  ?  FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style,
                                            ),
                                          ],
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 35, right: 35),
                            child: Container(
                              height: 1,
                              color: AppColors.findMumBorderColor,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: mumDetails.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mumDetails[index]['title'] ?? '',
                                            style:
                                            (displayType == 'desktop' || displayType == 'tablet')
                                                ? FTextStyle.findMumDetailsTitleTablet : FTextStyle.findMumDetailsTitle,
                                          ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            mumDetails[index]['value'] ?? '',
                                            style: !(index ==
                                                    mumDetails.length - 1)
                                                ? (displayType == 'desktop' || displayType == 'tablet')
                                                ? FTextStyle
                                                .findMumDetails2TitleTablet : FTextStyle
                                                    .findMumDetails2Title
                                                : (displayType == 'desktop' || displayType == 'tablet')
                                                ? FTextStyle
                                                .programAskButtonStyleTablet :FTextStyle
                                                    .programAskButtonStyle,
                                          )
                                        ],
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'imageOnPageLoadAnimation2']!)
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          )
        ],
      )),
    );
  }
}

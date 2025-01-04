import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

import '../../Utils/CommonFuction.dart';

class FindMumDetails extends StatefulWidget {
  const FindMumDetails({super.key});

  @override
  State<FindMumDetails> createState() => _FindMumDetailsState();
}

class _FindMumDetailsState extends State<FindMumDetails> {
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
    }
  ];
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
                "Mum Details",
                style: FTextStyle.appBarTitleStyle)
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Image.asset(
              "assets/Images/back.png",
              height: 14,
              width: 14,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.007),
            child: Column(
              children: [
                const Divider(
                  thickness: 1.2,
                  color: Color(0XFFF6F6F6),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child:  Card(
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
                    child:  Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          child:  Row(
                              children: [
                                Container(
                                  height: 72,
                                  width: 72,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/Images/profileImg.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(top: 10, left: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Minakshi Singh',
                                            style: FTextStyle.MumsTitle,
                                          ),
                                        ],
                                      ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Trying to Conceive',
                                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.dateTimeTablet : FTextStyle.dateTime,
                                            ),
                                          ],
                                        ).animateOnPageLoad(animationsMap[
                                        'imageOnPageLoadAnimation2']!),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Have Kids-Ages 3,4',
                                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.dateTimeTablet : FTextStyle.dateTime,
                                            ),
                                          ],
                                        ).animateOnPageLoad(animationsMap[
                                        'imageOnPageLoadAnimation2']!),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(screenWidth * 0.04,screenHeight * 0.003,screenWidth * 0.04,screenHeight * 0.015),
                            child: Divider(thickness: screenHeight * 0.0015, color: AppColors.opacityBlack3),
                          ),
                          Container(
                            height: screenHeight * 0.25,
                            child: ListView.builder(
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
                                              style: FTextStyle.MumsKey,
                                            ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                mumDetails[index]['value'] ?? '',
                                                style: FTextStyle.MumsValues
                                            ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation2']!)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ) ,
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(screenWidth * 0.85, screenHeight * 0.05),
                                backgroundColor: AppColors.pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                child: Text(
                                  "Connect",
                                  style: FTextStyle.ForumsButtonStyling,
                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ),
                            ),
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ],
                      ),
                    ),
                  ),
                )
            )],
            )),
      ),
    );
  }
}

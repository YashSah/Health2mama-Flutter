import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/booking_appointDialog.dart';
import 'package:health2mama/Utils/custom_radio.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

import '../../Utils/CommonFuction.dart';

class OnlineNutrition extends StatefulWidget {
  const OnlineNutrition({Key? key}) : super(key: key);

  @override
  State<OnlineNutrition> createState() => _OnlineNutritionState();
}

class _OnlineNutritionState extends State<OnlineNutrition> {
  String? selectedOption;
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
  Map<String, String> options = {
    'Initial Consult': 'Value 1',
    'Follow Up Consult': 'Value 2',
    '1 week Meal Plan': 'Value 3',
    '2 week Meal Plan': 'Value 4',
    '4 week Program': 'Value 5',
    '8 week Program': 'Value 6',
    '12 week Program ': 'Value 7',
  };

  bool get isButtonEnabled => selectedOption != null;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double width = MediaQuery.of(context).size.width;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    void showBookingDialog(String valueFromNextClass) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppointmentDialog(
            onConfirm: (String date, String time) async {
              await Future.delayed(Duration(seconds: 1));
            },
          );
        },
      );
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "",
            style: (displayType == 'desktop' || displayType == 'tablet')
                ? FTextStyle.appTitleStyleTablet
                : FTextStyle.appBarTitleStyle,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (displayType == 'desktop' ||  displayType == 'tablet') ?4.w:screenWidth * 0.03, vertical:(displayType == 'desktop' ||  displayType == 'tablet') ?2.w: screenWidth * 0.01,),

            child: Image.asset(
              "assets/Images/back.png",
              height: screenHeight * 0.03,
              // Adjust height based on screen height
              width: screenHeight * 0.03, // Adjust width based on screen height
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
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.06,
                        top: screenHeight * 0.008,
                        right: screenWidth * 0.06),
                    child: Text(
                      'Online Nutritionist/Dietician Consult',
                      style:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? FTextStyle.appTitleStyleTablet
                              : FTextStyle.appBarTitleStyle,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.06,
                        top: screenHeight * 0.03,
                        right: screenWidth * 0.06),
                    child: Text(
                      'Lorem ipsum dolor sit amet consectetur. Tellus platea laoreet pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. U',
                      style:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? FTextStyle.forumTopicsSubTitleTablet
                              : FTextStyle.forumContent,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  SizedBox(height: screenHeight * 0.015),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Card(
                      color: const Color.fromRGBO(247, 247, 247, 0.95),
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
                            child: Text('Nutritional Consult Options',
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.forumTopicsTitleTablet
                                    : FTextStyle.forumMainHeading),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              String key = options.keys.elementAt(index);

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption =
                                        key; // Assuming 'key' is the value associated with this option
                                  });
                                },
                                overlayColor:
                                    MaterialStatePropertyAll(Colors.transparent),
                                // Removes hover color
                                hoverColor: Colors.transparent,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.05,
                                          vertical: screenHeight * 0.004),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(key,
                                              style: (displayType ==
                                                          'desktop' ||
                                                      displayType == 'tablet')
                                                  ? FTextStyle
                                                      .forumTopicsSubTitleTablet
                                                  : FTextStyle.ForumsNameTitle),
                                          CustomRadio(
                                            value: key,
                                            groupValue: selectedOption,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedOption = newValue;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    if (index != options.length - 1)
                                      Divider(
                                        thickness: 1,
                                        color: Colors.black.withOpacity(0.1),
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.06,
                        top: screenHeight * 0.015,
                        right: screenWidth * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lorem ipsum dolor sit amet consectetur. Tellus platea laoreet pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam.',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.forumTopicsSubTitleTablet
                              : FTextStyle.forumContent,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          '\$579.50',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.forumTopicsTitleTablet
                              : FTextStyle.forumTopicsTitle,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(Size(screenWidth * 0.47, screenHeight * 0.06)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              backgroundColor:MaterialStateProperty.resolveWith<Color>((states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return AppColors.boarderColour;

                                }
                                return   AppColors.appBlue;

                              }),
                            ),
                            onPressed: isButtonEnabled ? () {
                              String valueFromNextClass = 'Value from Next Class';
                              showBookingDialog(valueFromNextClass);


                            } : null,
                            child: Text(
                              'Single Purchase',
                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.ForumsButtonStylingTablet : FTextStyle.ForumsButtonStyling,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

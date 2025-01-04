import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/schedule/consultation_offline_schedule.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/custom_radio.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';

import 'package:intl/intl.dart';


import '../../Utils/flutter_font_style.dart';


class Onlineschedule extends StatefulWidget {
  const Onlineschedule({Key? key}) : super(key: key);



  @override
  _ConsultState createState() => _ConsultState();

}

class _ConsultState extends State<Onlineschedule> {
  late String _formattedDate;
  late String _upcomingText;
  bool _isSelected = false;

  final List<Map<String, dynamic>> dataList = [
    {
      'text1': 'Health2mama',
      'text2':
      "Lorem ipsum dolor sit amet consectetur. In mi duis eu pharetra metus eget vitae vel cras. Lorem ipsum dolor sit amet consectetur.",
      'text3': "Appointment Date & Time"
      ,'text32':'Appointment Type',
      'text4':'29th 2024 4:30 PM'
    },
    {
      'text1': 'Health2mama',
      'text2':
      "Lorem ipsum dolor sit amet consectetur. In mi duis eu pharetra metus eget vitae vel cras. Lorem ipsum dolor sit amet consectetur.",
      'text3': "Appointment Date & Time"
      ,'text32':'Appointment Type',
      'text4':'29th 2024 4:30 PM'
    },
    {
      'text1': 'Health2mama',
      'text2':
      "Lorem ipsum dolor sit amet consectetur. In mi duis eu pharetra metus eget vitae vel cras. Lorem ipsum dolor sit amet consectetur.",
      'text3': "Appointment Date & Time"
      ,'text32':'Appointment Type',
      'text4':'29th 2024 4:30 PM'
    },




    // Add more data here
  ];
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
  final List<Map<String, dynamic>> onlinePackage = [
    {
      'text': 'Initial Consult',
      // Correctly formatted price
    },
  ];
  String? onlinePackageOption;

  @override
  void initState() {
    super.initState();
    _updateDate();
    _upcomingText = 'Upcoming';
  }

  void _updateDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    _formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Padding(
          padding: EdgeInsets.only(left:(displayType == 'desktop' ||  displayType == 'tablet') ?4.w: 8.0),
          child: Text(
            "Online Nutritionist/Dietician Consult",
            style: FTextStyle.appBarTitleStyle,
            maxLines: 2,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (displayType == 'desktop' ||  displayType == 'tablet') ?4.w:screenWidth * 0.03, vertical:(displayType == 'desktop' ||  displayType == 'tablet') ?2.w: screenWidth * 0.01,),

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
      body: Container(
        color: Colors.white,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal:(displayType == 'desktop' || displayType == 'tablet')?18.h: 18.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                const Divider(
                  thickness: 2,
                  color: AppColors.linecolor,
                ),

                const SizedBox(height: 10,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: (displayType == 'desktop' || displayType == 'tablet')?10.h:10.0),
                  child: Text(
                    " Lorem ipsum dolor sit amet consectetur. Tellus platea laoreet pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam.  ",
                    style:(displayType == 'desktop' || displayType == 'tablet')?FTextStyle.loremtextTab.copyWith(
                      color: AppColors.loremtextcolor,
                    ): FTextStyle.loremtext.copyWith(color: AppColors.loremtextcolor),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                ),




                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
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
                          padding: EdgeInsets.only(left: (displayType == 'desktop' || displayType == 'tablet')?5.h:screenWidth * 0.05, top:(displayType == 'desktop' || displayType == 'tablet')?10.h: 10),
                          child:  Text(
                            'Nutritional Consult Options',
                            style: (displayType == 'desktop' || displayType == 'tablet')? FTextStyle.forumTopicsTitleTap: FTextStyle.forumTopicsTitle,
                          ),
                        ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                        ListView.builder(
                          padding: EdgeInsets.symmetric(vertical:(displayType == 'desktop' || displayType == 'tablet')?10.h: screenHeight * 0.01),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: onlinePackage.length,
                          itemBuilder: (context, index) {
                            String key = onlinePackage[index]['text'];

                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical:(displayType == 'desktop' || displayType == 'tablet')?4.h :screenHeight * 0.004, horizontal:(displayType == 'desktop' || displayType == 'tablet')?18.h: 18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(key, style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.ForumsNameTitleTab:FTextStyle.ForumsNameTitle).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                        ],
                                      ),
                                      CustomRadio(
                                        value: key,
                                        groupValue: onlinePackageOption,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            onlinePackageOption = newValue;
                                          });
                                        },
                                      ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!)
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),




                Center(
                  child: Padding(


                    padding:  EdgeInsets.symmetric(horizontal:(displayType == 'desktop' || displayType == 'tablet')?2.h: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet consectetur. Tellus platea laoreet pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. ",
                      style: (displayType == 'desktop' || displayType == 'tablet')?FTextStyle.loremtextTab.copyWith(
                        color: AppColors.loremtextcolor,
                      ): FTextStyle.loremtext.copyWith(color: AppColors.loremtextcolor),             ),
                  ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),


                const SizedBox(height: 30,),
                Padding(


                  padding:  EdgeInsets.symmetric(horizontal:(displayType == 'desktop' || displayType == 'tablet')?2.h: 11.0),
                  child: Text(
                    "\$544.50",
                    style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.cardTitleTable:FTextStyle.cardTitle,             ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!)
                ,

                SizedBox(height:(displayType == 'desktop' || displayType == 'tablet')?10.h: 20,),


                Padding(

                  padding:  EdgeInsets.symmetric(horizontal:(displayType == 'desktop' || displayType == 'tablet')?2.h: 12.0),
                  child: Text(
                    "Appointment Details",
                    style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.cardTitleTable:FTextStyle.cardTitle,
                   ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),


                SizedBox(height:(displayType == 'desktop' || displayType == 'tablet')?10.h: 10,),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:(displayType == 'desktop' || displayType == 'tablet')?2.h: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Booked On: ",
                        style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.fontsizetab.copyWith(
                          color: AppColors.textbluecolor,
                        ): FTextStyle.fontsize.copyWith(
                          color: AppColors.textbluecolor,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),

                      Text(
                        "25th Jan. 2024, 04:30 PM",
                        maxLines: 2,
                        style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.fontsizetab.copyWith(
                          color: AppColors.textbluecolor,
                        ): FTextStyle.fontsize.copyWith(
                          color: AppColors.textbluecolor,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ],
                  ),
                ),
                SizedBox(height:(displayType == 'desktop' || displayType == 'tablet')?10.h: 6,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:(displayType == 'desktop' || displayType == 'tablet')?2.h: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Appointment  On: ",
                        style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.fontsizetab.copyWith(
                          color: AppColors.textbluecolor,
                        ): FTextStyle.fontsize.copyWith(
                          color: AppColors.textbluecolor,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),

                      Text(
                        "29th Jan. 2024, 04:30 PM",
                        maxLines: 2,
                        style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.fontsizetab.copyWith(
                          color: AppColors.textbluecolor,
                        ): FTextStyle.fontsize.copyWith(
                          color: AppColors.textbluecolor,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ],
                  ),
                ),

                SizedBox(height:(displayType == 'desktop' || displayType == 'tablet')?10.h: 6,),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:(displayType == 'desktop' || displayType == 'tablet')?2.h: 15.0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Meeting Link: ",
                        style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.fontsizetab.copyWith(
                          color: AppColors.textbluecolor,
                        ): FTextStyle.fontsize.copyWith(
                          color: AppColors.textbluecolor,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),

                      Text(
                        "https:www.google.cozoxa",
                        maxLines: 2,
                        style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.fontsizetab.copyWith(
                          color: AppColors.textbluecolor,
                        ): FTextStyle.fontsize.copyWith(
                          color: AppColors.textbluecolor,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ],
                  ),
                ),







                const SizedBox(height: 30,),
                Padding(
                  padding:  EdgeInsets.symmetric(vertical:(displayType == 'desktop' || displayType == 'tablet')?20.h: 25.0,horizontal: (displayType == 'desktop' || displayType == 'tablet')?5.h:5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(

                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.lightgray,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child:  Padding(
                        padding: EdgeInsets.symmetric(vertical:(displayType == 'desktop' || displayType == 'tablet')?12.h: 12.0,horizontal:(displayType == 'desktop' || displayType == 'tablet')?20.h: 23), // Add verticatical padding to center the text vertically
                        child: Text(
                          'Cancel Appointment',
                          textAlign: TextAlign.center, // Align the text to the center
                          style:(displayType == 'desktop' || displayType == 'tablet')? FTextStyle.blackStyleSmallTab: FTextStyle.blackStyleSmall,
                        ),
                      ),
                    ),
                  ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),





              ]
          ),
        ),
      ),
    );
  }
}


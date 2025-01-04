import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/schedule/consult_screen.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:intl/intl.dart';
import '../../Utils/flutter_font_style.dart';


class OfflineDetail extends StatefulWidget {
  const OfflineDetail({Key? key}) : super(key: key);


  @override
  _ConsultState createState() => _ConsultState();
}

class _ConsultState extends State<OfflineDetail> {
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
  late String _formattedDate;
  late String _upcomingText;

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
    MediaQueryData _mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:  Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                  "Health2mama",
                  style: FTextStyle.appBarTitleStyle)
          ),
          leading:

          GestureDetector(
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
        body: Container(
          color: AppColors.customwhite,
          child: Column(

              children: [


                const Divider(
                  thickness: 2,
                  color: AppColors.linecolor,
                ),

                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding as needed
                  child: Text(
                    "Lorem ipsum dolor sit amet consectetur. Tellus platea laoreet pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue ",
                    style: FTextStyle.loremtext.copyWith(color: AppColors.loremtextcolor),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                ),
                const SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
                  child: Text(
                    "Website",
                    style: FTextStyle.health2mama.copyWith(color: AppColors.currentdate),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                ),

                const SizedBox(height: 3,),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
                  child: Text(
                    "www.health2mama.sg",
                    style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                ),


                const SizedBox(height: 25,),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
                  child: Text(
                    "Contact",
                    style: FTextStyle.health2mama.copyWith(color: AppColors.currentdate),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                ),


                const SizedBox(height: 10,),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
                      child: Image.asset(
                        'assets/Images/email.png', // Replace 'my_image.png' with your image asset path
                        width: _mediaQuery.size.width * 0.06,
                        height: _mediaQuery.size.width * 0.06,// Adjust the height as needed
                      ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
                      child: Text(
                        "www.health2mama.sg",
                        style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),
                      ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),

                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
                      child: Image.asset(
                        'assets/Images/phoneblue.png', // Replace 'my_image.png' with your image asset path
                        width: _mediaQuery.size.width * 0.06,
                        height: _mediaQuery.size.width * 0.06,// 5% of screen height
                      ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),


                    Padding(
                      padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
                      child: Text(
                        "+33-453243-5535",
                        style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),              ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),

                  ],
                ),

                const SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0), // Adjust the left margin as needed
                  child: Text(
                    "Appointment Details",
                    style: FTextStyle.appoinmentdetails.copyWith(color: AppColors.currentdate),              ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),

                const SizedBox(height: 10,),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0), // Adjust the left margin as needed
                      child: Text(
                        "Booked On : ",
                        style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),              ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),


                    Padding(
                      padding: const EdgeInsets.only(left: 16.0,right: 10), // Adjust the left margin as needed
                      child: Text(
                        "  25th Jan. 2024,  12:00 PM",
                        style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),              ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),

                  ],
                ),
                const SizedBox(height: 5,),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0,right: 15), // Adjust the left margin as needed
                      child: Text(
                        "Appointment Held On:",
                        style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),              ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),

                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 3), // Adjust the left and right margins as needed
                      child: Text(
                        "29th Jan. 2024, ",
                        style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),              ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),

                  ],
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 196, right: 3), // Adjust the left and right margins as needed
                  child: Text(
                    " 04:30 PM",
                    style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),              ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),
                const SizedBox(height: 25,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5, // 40% of the screen width
                  height: MediaQuery.of(context).size.height * 0.05, // Adjusted height, 5% of the screen height
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to the next screen
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Offlineschedule()), // Replace NextScreen() with the widget of your next screen
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightgray, // Button background color
                      padding: EdgeInsets.zero, // No padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Add corner radius here
                      ),
                    ),
                    child:  Text(
                      'Cancel Appointment', // Add your button text here
                      style: FTextStyle.fontsize.copyWith(color: AppColors.customblack),
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


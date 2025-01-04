import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/schedule/consultation_offline_view.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:intl/intl.dart';


import '../../Utils/flutter_font_style.dart';



class Offlineschedule extends StatefulWidget {
  const Offlineschedule({Key? key}) : super(key: key);



  @override
  _ConsultState createState() => _ConsultState();

}

class _ConsultState extends State<Offlineschedule> {
  late String _formattedDate;
  late String _upcomingText;
  bool _isSelected = false;
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Online Nutritionist/Dietician",
            style: FTextStyle.appBarTitleStyle,
          ),
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
      body: Column(

          children: [


            const Divider(
              thickness: 2,
              color: AppColors.linecolor,
            ),

            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding as needed
              child: Text(
                " Lorem ipsum dolor sit amet consectetur. Tellus platea laoreet pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam.  ",
                style: FTextStyle.loremtext.copyWith(color: AppColors.loremtextcolor),
              ).animateOnPageLoad(animationsMap[
              'imageOnPageLoadAnimation2']!),
            ),

            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 13), // Add left margin
              child: Container(
                width: MediaQuery.of(context).size.width * 8, // 80% of the screen width
                height: MediaQuery.of(context).size.height * 0.12, // 11% of the screen height
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add symmetric horizontal padding
                decoration: BoxDecoration(
                  color: AppColors.radiocontainer, // Background color of the container
                  borderRadius: BorderRadius.circular(20.0), // Border radius of the container
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10.0), // Add bottom margin
                      child: const Text(
                        'Nutritional Consult Options',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.currentdate,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ),




                    // Add space between text and radio button


                    Row(
                      children: [
                        const Text(
                          'Initial Consult',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                        Padding(
                          padding: const EdgeInsets.only(left: 140.0), // Add left padding
                          child: Radio(
                            value: true, // You can set any value for the radio button
                            groupValue: _isSelected, // Use a boolean variable to manage selection
                            onChanged: (bool? value) {
                              setState(() {
                                _isSelected = value!;
                              });
                            },
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 10,),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 23.0,right: 10), // Adjust the left margin as needed
                child: Text(
                  "Lorem ipsum dolor sit amet consectetur. Tellus platea laoreet pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. Urna facilisi diam at augue nascetur diam  pretium etiam. Et rhoncus at duis sed non vitae tellus nibh quam. ",
                  style: FTextStyle.loremtext.copyWith(color: AppColors.loremtextcolor),             ),
              ),
            ).animateOnPageLoad(animationsMap[
            'imageOnPageLoadAnimation2']!),

            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 23.0), // Adjust the left margin as needed
              child: Text(
                "\$544.50",
                style: FTextStyle.appoinmentdetails.copyWith(color: AppColors.currentdate),              ),
            ).animateOnPageLoad(animationsMap[
            'imageOnPageLoadAnimation2']!)
            ,
            const SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.only(left: 16.0), // Adjust the left margin as needed
              child: Text(
                "Appointment Details",
                style: FTextStyle.appoinmentdetails.copyWith(color: AppColors.currentdate),              ),
            ).animateOnPageLoad(animationsMap[
            'imageOnPageLoadAnimation2']!),

            const SizedBox(height: 10,),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 10), // Adjust the left margin as needed
                  child: Text(
                    "Booked On : ",
                    style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),
                  ),).animateOnPageLoad(animationsMap[
    'imageOnPageLoadAnimation2']!),


                Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10), // Adjust the left margin as needed
                  child: Text(
                    "  25th Jan. 2024,  12:00 PM",
                    style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),
                  ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!)
              ],
            ),
            const SizedBox(height: 10,),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 15), // Adjust the left margin as needed
                  child: Text(
                    "Appointment Held On: ",
                    style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),
                  ),).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!)

                ,
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 3), // Adjust the left and right margins as needed
                  child: Text(
                    "29th Jan. 2024,",
                    style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),
                  ),
                ).animateOnPageLoad(animationsMap[
                'imageOnPageLoadAnimation2']!),

              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 195, right: 3), // Adjust the left and right margins as needed
              child: Text(
                "04:30 PM,",
                style: FTextStyle.fontsize.copyWith(color: AppColors.textbluecolor),
              ),
            ).animateOnPageLoad(animationsMap[
            'imageOnPageLoadAnimation2']!),


            const SizedBox(height: 30,),


            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7, // 40% of the screen width
              height: MediaQuery.of(context).size.height * 0.06, // Adjusted height, 5% of the screen height
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0), // Adjust the left padding as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OfflineDetail()), // Replace NextScreen() with the widget of your next screen
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightgray, // Button background color
                    padding: EdgeInsets.zero, // No padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Add corner radius here
                    ),
                  ),
                  child: const Text(
                    'Cancel Appointment', // Add your button text here
                    style: TextStyle(
                      fontSize: 16.0, // Adjust the font size as needed
                      color: AppColors.customblack, // Text color
                    ),
                  ),
                ),
              ),
            ).animateOnPageLoad(animationsMap[
            'imageOnPageLoadAnimation2']!),



          ]
      ),
    );
  }
}

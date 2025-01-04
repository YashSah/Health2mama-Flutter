import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
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
    return  MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:  Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                  "Terms And Conditions",
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
        body:  ListView(

          children:  [
            Divider(
              thickness: 1.2,
              color: Color(0XFFF6F6F6),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last updated May 08, 2023",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                  SizedBox(height: 20.0),
                  Text(
                    "This privacy notice for Health2u Pte Ltd (doing business as Health2mama) ('Health2mama', 'we', 'us', or 'our'), describes how and why we might collect, store, use, and/or share ('process') your information when you use our services ('Services'), such as when you:",
                    style: TextStyle(fontSize: 14.0),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                  SizedBox(height: 10.0),
                  Text(
                    "Questions or concerns? Reading this privacy notice will help you understand your privacy rights and choices. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at rebecca@health2u.sg.",
                    style: TextStyle(fontSize: 14.0),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                  SizedBox(height: 20.0),
                  Text(
                    "SUMMARY OF KEY POINTS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                  SizedBox(height: 10.0),
                  Text(
                    "This summary provides key points from our privacy notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below to find the section you are looking for.",
                    style: TextStyle(fontSize: 14.0),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                  SizedBox(height: 20.0),
                  Text(
                    "WHAT INFORMATION DO WE COLLECT?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                  SizedBox(height: 10.0),
                  Text(
                    "What personal information do we process? When you visit, use, or navigate our Services, we may process personal information depending on how you interact with Health2mama and the Services, the choices you make, and the products and features you use. Learn more about personal information you disclose to us.",
                    style: TextStyle(fontSize: 14.0),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),
                  SizedBox(height: 10.0),
                  Text(
                    "Do we process any sensitive personal information? We may process sensitive personal information when necessary with your consent or as otherwise permitted by applicable law. Learn more about sensitive information we process.",
                    style: TextStyle(fontSize: 14.0),
                  ).animateOnPageLoad(animationsMap[
                  'imageOnPageLoadAnimation2']!),

                  SizedBox(height: 10.0),
                ],
              ),
            ),

          ],
        ),

      ),
    );
  }
}

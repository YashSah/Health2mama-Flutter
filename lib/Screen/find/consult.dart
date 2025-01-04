import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find/book_online_consultation.dart';
import 'package:health2mama/Screen/find/personal_consult.dart';
import 'package:health2mama/Screen/find_mum/find_mum.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/find/find_bloc.dart';

import '../../Utils/CommonFuction.dart';
class ConsultFind extends StatefulWidget {
  const ConsultFind({Key? key}) : super(key: key);

  @override
  State<ConsultFind> createState() => _ConsultFindState();
}

class _ConsultFindState extends State<ConsultFind> {
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
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(

        body: Stack(
          fit: StackFit.expand,
          children: [
            Transform.scale(
              scaleY: 1.1,

              child: Container(
                decoration: const BoxDecoration(

                  image: DecorationImage(

                    image: AssetImage('assets/Images/findbackground.png',),
                    // Background image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Transform.scale(
              scale: -5,
              child: Image.asset(
                'assets/Images/findback.png', // Overlay image
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: (displayType == 'desktop' || displayType == 'tablet')
                        ? 15.h
                        : 0),
                child: Container(
                  width: (displayType == 'desktop' || displayType == 'tablet') ? 280.w : width * 0.88,
                  height: height * 0.32,
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the container
                    borderRadius: BorderRadius.circular(15.0), // Add border radius here
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 25, left: 25.0, top: 25,bottom: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PersonalConsult()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appBlue,
                            textStyle: FTextStyle.buttonStyle,
                            minimumSize: Size(double.infinity, (displayType == 'desktop' || displayType == 'tablet') ? 65.h : 52),
                            // Adjusted button height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 2,

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:  Text(
                              'Find A Professional Near You',
                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.buttonStyleTablet : FTextStyle.buttonStyle,
                            ),
                          ),
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),

                      Padding(
                        padding: const EdgeInsets.only(left: 25.0,right: 25.0,bottom: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => FindBloc(),
                                        child: const BookOnlineConsultation(),
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pinkButton,
                            textStyle: FTextStyle.buttonStyle,
                            minimumSize: Size(double.infinity, (displayType == 'desktop' || displayType == 'tablet') ? 65.h : 52),
                            // Adjusted button height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 2,

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:  Text(
                              'Book Online Consult',
                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.buttonStyleTablet : FTextStyle.buttonStyle,
                            ),
                          ),
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FindMumData()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Colors.white,
                            textStyle: FTextStyle.buttonStyle,
                            minimumSize: Size(double.infinity, (displayType == 'desktop' || displayType == 'tablet') ? 65.h : 52),
                            // Adjusted button height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                            side: const BorderSide(color: AppColors.pinkButton,width: 2.0,), // Border color
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Find A Mum',
                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.buttonpinkTablet : FTextStyle.buttonpink,
                            ),
                          ),
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!)

                    ],
                  )
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}


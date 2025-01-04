
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/Tutorial_screen/content_model.dart';
import 'package:health2mama/Screen/Tutorial_screen/getstarted_splash.dart';
import 'package:health2mama/Screen/auth_flow/login_Screen.dart';
import 'package:health2mama/Screen/splash_screen.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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

  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_controller.page == contents.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GetStarted()),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Stack(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: screenHeight,
                        width: screenWidth,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              child: Container(
                                width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : 90.w ,
                                height: 40.h,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.splashContinueButton,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child:  Text(
                                  'Skip',
                                  style: FTextStyle.SkipStyle(displayType),
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: (displayType == 'desktop' || displayType == 'tablet') ? 55 : 25, left: 12.h , right: 12.h),
                                    child: Container(
                                      width:  550.w,
                                      height:  200.h,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            contents[i].background,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Padding(
                                            padding: (displayType == 'desktop' || displayType == 'tablet') ? EdgeInsets.only(left: 20.w, right:20.w) : EdgeInsets.only(left: 10.w, right: 10.w),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 40.w),
                                                  child: Text(
                                                    contents[i].title,
                                                    style: FTextStyle.splashHeader(displayType),
                                                    textAlign: TextAlign.center,
                                                  ).animateOnPageLoad(animationsMap[
                                                      'imageOnPageLoadAnimation2']!),
                                                ),

                                                Padding(
                                                  padding:displayType == 'desktop' ? EdgeInsets.only(left: 55.w, right: 55.w, bottom: 50.h) : displayType == 'tablet' ? EdgeInsets.only(left: 50.w, right: 50.w, bottom: 50.h) : EdgeInsets.only(left: 45.w, right: 45.w, bottom: 55.h),
                                                  child: Text(
                                                    contents[i].description,
                                                    style: FTextStyle.splashSubHeader(displayType),
                                                    textAlign: TextAlign.center,
                                                  ).animateOnPageLoad(
                                                      animationsMap['imageOnPageLoadAnimation2']!),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : 0,
                                    left: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: nextPage,
                                      child: SizedBox(
                                        width: (displayType == 'desktop' || displayType == 'tablet') ?  65.w : 60.w,
                                        height:  (displayType == 'desktop' || displayType == 'tablet') ?  65.h : 60.h,
                                        child: Image.asset(
                                          'assets/Images/splash_forward_btn.png',
                                          fit: BoxFit.contain,
                                        ).animateOnPageLoad(
                                            animationsMap['imageOnPageLoadAnimation2']!),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

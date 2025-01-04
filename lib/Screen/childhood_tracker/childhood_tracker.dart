import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/childhood_tracker/childhood_personlised.dart';
import 'package:health2mama/Screen/childhood_tracker/childhood_search.dart';
import 'package:health2mama/Screen/pregnnacy/personalize_tracker.dart';
import 'package:health2mama/Screen/pregnnacy/search_result.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';

import '../../Utils/flutter_colour_theams.dart';
class ChildhoodTracker extends StatefulWidget {
  const ChildhoodTracker({super.key});

  @override
  State<ChildhoodTracker> createState() => _ChildhoodTrackerState();
}

class _ChildhoodTrackerState extends State<ChildhoodTracker> {
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;
  late ScrollController _scrollController3;

  final Duration debounceDuration = Duration(milliseconds: 500);

  late AsyncMemoizer _scrollRightMemoizer1 = AsyncMemoizer();
  late AsyncMemoizer _scrollLeftMemoizer1 = AsyncMemoizer();

  late AsyncMemoizer _scrollRightMemoizer2 = AsyncMemoizer();
  late AsyncMemoizer _scrollLeftMemoizer2 = AsyncMemoizer();

  late AsyncMemoizer _scrollRightMemoizer3 = AsyncMemoizer();
  late AsyncMemoizer _scrollLeftMemoizer3 = AsyncMemoizer();
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
    {'image': 'assets/Images/childhood1.png'},
    {'image': 'assets/Images/childhood2.png'},
    {'image': 'assets/Images/childhood1.png'},
    {'image': 'assets/Images/childhood2.png'},
    {'image': 'assets/Images/childhood1.png'},
    {'image': 'assets/Images/childhood2.png'},
    {'image': 'assets/Images/childhood1.png'},
    {'image': 'assets/Images/childhood2.png'},
    {'image': 'assets/Images/childhood1.png'},
    {'image': 'assets/Images/childhood2.png'},
    {'image': 'assets/Images/childhood1.png'},
    {'image': 'assets/Images/childhood2.png'},
    {'image': 'assets/Images/childhood1.png'},
    {'image': 'assets/Images/childhood2.png'},

  ];

  // Flags to track scroll state for each ListView
  bool isRightScrollPerformed1 = false;
  bool isRightScrollPerformed2 = false;
  bool isRightScrollPerformed3 = false;

  @override
  void initState() {
    super.initState();
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController3 = ScrollController();
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    _scrollController3.dispose();
    super.dispose();
  }

  void _scrollToRight1(ScrollController controller) {
    final double newPosition = controller.offset + 150.0;
    final double maxOffset = controller.position.maxScrollExtent;
    if (newPosition <= maxOffset) {
      controller.animateTo(
        newPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        isRightScrollPerformed1 = true;
      });
    }
  }

  void _scrollToLeft1(ScrollController controller) {
    final double newPosition = controller.offset - 150.0;
    if (newPosition >= 0) {
      controller.animateTo(
        newPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      if (newPosition == 0) {
        setState(() {
          isRightScrollPerformed1 = false;
        });
      }
    }
  }

  void _scrollToRight2(ScrollController controller) {
    final double newPosition = controller.offset + 150.0;
    final double maxOffset = controller.position.maxScrollExtent;
    if (newPosition <= maxOffset) {
      controller.animateTo(
        newPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        isRightScrollPerformed2 = true;
      });
    }
  }

  void _scrollToLeft2(ScrollController controller) {
    final double newPosition = controller.offset - 150.0;
    if (newPosition >= 0) {
      controller.animateTo(
        newPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      if (newPosition == 0) {
        setState(() {
          isRightScrollPerformed2 = false;
        });
      }
    }
  }

  void _scrollToRight3(ScrollController controller) {
    final double newPosition = controller.offset + 150.0;
    final double maxOffset = controller.position.maxScrollExtent;
    if (newPosition <= maxOffset) {
      controller.animateTo(
        newPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        isRightScrollPerformed3 = true;
      });
    }
  }

  void _scrollToLeft3(ScrollController controller) {
    final double newPosition = controller.offset - 150.0;
    if (newPosition >= 0) {
      controller.animateTo(
        newPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      if (newPosition == 0) {
        setState(() {
          isRightScrollPerformed3 = false;
        });
      }
    }
  }

  void _scrollToItem(int index, ScrollController controller) {
    final double newPosition = index * 150.0; // Adjust this value according to your item size
    controller.animateTo(
      newPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToRight1Debounced(ScrollController controller) {
    _scrollRightMemoizer1.runOnce(() async {
      _scrollToRight1(controller);
      await Future.delayed(debounceDuration);
      _scrollRightMemoizer1 = AsyncMemoizer(); // Reassign a new AsyncMemoizer
    });
  }

  void _scrollToRight2Debounced(ScrollController controller) {
    _scrollRightMemoizer2.runOnce(() async {
      _scrollToRight2(controller);
      await Future.delayed(debounceDuration);
      _scrollRightMemoizer2 = AsyncMemoizer(); // Reassign a new AsyncMemoizer
    });
  }

  void _scrollToRight3Debounced(ScrollController controller) {
    _scrollRightMemoizer3.runOnce(() async {
      _scrollToRight3(controller);
      await Future.delayed(debounceDuration);
      _scrollRightMemoizer3 = AsyncMemoizer(); // Reassign a new AsyncMemoizer
    });
  }

  void _scrollToLeft1Debounced(ScrollController controller) {
    _scrollLeftMemoizer1.runOnce(() async {
      _scrollToLeft1(controller);
      await Future.delayed(debounceDuration);
      _scrollLeftMemoizer1 = AsyncMemoizer(); // Reassign a new AsyncMemoizer
    });
  }

  void _scrollToLeft2Debounced(ScrollController controller) {
    _scrollLeftMemoizer2.runOnce(() async {
      _scrollToLeft2(controller);
      await Future.delayed(debounceDuration);
      _scrollLeftMemoizer2 = AsyncMemoizer(); // Reassign a new AsyncMemoizer
    });
  }

  void _scrollToLeft3Debounced(ScrollController controller) {
    _scrollLeftMemoizer3.runOnce(() async {
      _scrollToLeft3(controller);
      await Future.delayed(debounceDuration);
      _scrollLeftMemoizer3 = AsyncMemoizer(); // Reassign a new AsyncMemoizer
    });
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
                  "Childhood Development",
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
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Divider(
                thickness: 2,
                color: AppColors.linecolor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>

                              ChildhoodPersonalized()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        width: _mediaQuery.size.width * 0.450,
                        height: _mediaQuery.size.height * 0.15,
                        child: Image.asset('assets/Images/childweek.png').animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                  InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChildHoodSearch()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        width: _mediaQuery.size.width * 0.450,
                        height: _mediaQuery.size.height * 0.15,
                        child: Image.asset('assets/Images/personlized.png'),
                      ),
                    ).animateOnPageLoad(animationsMap[
                    'imageOnPageLoadAnimation2']!),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 28.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: _mediaQuery.size.width * 0.3,
                      height: _mediaQuery.size.height * 0.03,
                      child: const Text(
                        "1st Year",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: AppColors.customblack,
                            fontWeight: FontWeight.bold),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 146,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _scrollController1,
                      scrollDirection: Axis.horizontal,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 1.0, left: 10
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _scrollToItem(index, _scrollController1);
                            },
                            child: Card(
                              child: SizedBox(
                                width: _mediaQuery.size.width * 0.35,
                                height: _mediaQuery.size.height * 0.15,
                                child: Image.asset(
                                  dataList[index]['image'],
                                  fit: BoxFit.cover,
                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 55,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        _scrollToRight1Debounced(_scrollController1);
                      },
                      child: SizedBox(
                        width: _mediaQuery.size.width * 0.10,
                        height: _mediaQuery.size.width * 0.10,
                        child: Image.asset('assets/Images/rightbtn.png').animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 15,
                    child: Visibility(
                      visible: isRightScrollPerformed1 && _scrollController1.offset > 0,
                      child: GestureDetector(
                        onTap: () {
                          _scrollToLeft1Debounced(_scrollController1);
                        },
                        child: SizedBox(
                          width: _mediaQuery.size.width * 0.10,
                          height: _mediaQuery.size.width * 0.10,
                          child: Image.asset('assets/Images/back.png'),
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 28.0),
                child: Row(
                  children: [
                    // Replace the fixed width and height with MediaQuery values
                    SizedBox(
                      width: _mediaQuery.size.width * 0.3,
                      height: _mediaQuery.size.height * 0.03, // Adjust the multiplier as needed
                      child: Text(
                        "2nd Year",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.customblack,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ),

                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 146,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _scrollController2,
                      scrollDirection: Axis.horizontal,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 1.0, left: 10
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _scrollToItem(index, _scrollController2);
                            },
                            child: Card(
                              child: SizedBox(
                                width: _mediaQuery.size.width * 0.35,
                                height: _mediaQuery.size.height * 0.15,
                                child: Image.asset(
                                  dataList[index]['image'],
                                  fit: BoxFit.cover,
                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 55,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        _scrollToRight2Debounced(_scrollController2);
                      },
                      child: SizedBox(
                        width: _mediaQuery.size.width * 0.10,
                        height: _mediaQuery.size.width * 0.10,
                        child: Image.asset('assets/Images/rightbtn.png').animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 15,
                    child: Visibility(
                      visible: isRightScrollPerformed2 && _scrollController2.offset > 0,
                      child: GestureDetector(
                        onTap: () {
                          _scrollToLeft2Debounced(_scrollController2);
                        },
                        child: SizedBox(
                          width: _mediaQuery.size.width * 0.10,
                          height: _mediaQuery.size.width * 0.10,
                          child: Image.asset('assets/Images/back.png'),
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 28.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: _mediaQuery.size.width * 0.3,
                      height: _mediaQuery.size.height * 0.03,
                      child:  const Text(
                        "3rd Year",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.customblack,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animateOnPageLoad(animationsMap[
                      'imageOnPageLoadAnimation2']!),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 146,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _scrollController3,
                      scrollDirection: Axis.horizontal,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 1.0, left: 10
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _scrollToItem(index, _scrollController3);
                            },
                            child: Card(
                              child: SizedBox(
                                width: _mediaQuery.size.width * 0.35,
                                height: _mediaQuery.size.height * 0.15,
                                child: Image.asset(
                                  dataList[index]['image'],
                                  fit: BoxFit.cover,
                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 55,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        _scrollToRight3Debounced(_scrollController3);
                      },
                      child: SizedBox(
                        width: _mediaQuery.size.width * 0.10,
                        height: _mediaQuery.size.width * 0.10,
                        child: Image.asset('assets/Images/rightbtn.png').animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 15,
                    child: Visibility(
                      visible: isRightScrollPerformed3 && _scrollController3.offset > 0,
                      child: GestureDetector(
                        onTap: () {
                          _scrollToLeft3Debounced(_scrollController3);
                        },
                        child: SizedBox(
                          width: _mediaQuery.size.width * 0.10,
                          height: _mediaQuery.size.width * 0.10,
                          child: Image.asset('assets/Images/back.png').animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

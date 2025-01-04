import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/pregnnacy/personalize_tracker.dart';
import 'package:health2mama/Screen/pregnnacy/search_result.dart';
import 'package:health2mama/Screen/pregnnacy/weeks_trimster.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/pregnancy/pregnancy_bloc.dart';
import 'package:intl/intl.dart';
import '../../Utils/flutter_colour_theams.dart';

class Pregnancytracker extends StatefulWidget {
  Pregnancytracker({Key? key}) : super(key: key);

  @override
  _PregnancytrackerState createState() => _PregnancytrackerState();
}

class _PregnancytrackerState extends State<Pregnancytracker> {
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

  Map<String, dynamic> successResponse = {};
  List<dynamic> dataList = [];
  List<dynamic> listWeeks = [];
  List<dynamic> filteredTrimesters = [];
  Map<String, List<dynamic>> trimesterWeeks = {};
  final Duration debounceDuration = const Duration(milliseconds: 200);
  late List<ScrollController> _scrollControllers;
  late List<AsyncMemoizer> _scrollRightMemoizers;
  late List<AsyncMemoizer> _scrollLeftMemoizers;
  late List<bool> _isRightScrollPerformed;
  late List<bool> _rightIconVisibility;
  bool isLoading = false;
  String? dueDate;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PregnancyBloc>(context).add(FetchTrimesterData());
    BlocProvider.of<PregnancyBloc>(context).add(LoadUserProfile());
    dataList = [];
    _scrollControllers =
        List.generate(dataList.length, (_) => ScrollController());
    _scrollRightMemoizers =
        List.generate(dataList.length, (_) => AsyncMemoizer());
    _scrollLeftMemoizers =
        List.generate(dataList.length, (_) => AsyncMemoizer());
    _isRightScrollPerformed = List.generate(dataList.length, (_) => false);
    _rightIconVisibility = List.generate(dataList.length, (_) => true);

    // Add listeners for each ScrollController
    for (var i = 0; i < _scrollControllers.length; i++) {
      _scrollControllers[i].addListener(() {
        setState(() {
          _rightIconVisibility[i] = _scrollControllers[i].position.pixels <
              _scrollControllers[i].position.maxScrollExtent;
          _isRightScrollPerformed[i] = _scrollControllers[i].position.pixels >
              _scrollControllers[i].position.minScrollExtent;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _scrollToRight(int index, MediaQueryData mediaQuery) {
    final controller = _scrollControllers[index];
    final double scrollDistance = mediaQuery.size.width * 0.4;
    final double newPosition = controller.offset + scrollDistance;
    final double maxOffset = controller.position.maxScrollExtent;

    if (newPosition <= maxOffset) {
      controller.animateTo(
        newPosition,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

      setState(() {
        _isRightScrollPerformed[index] = true;
      });
    } else {
      final double increaseDistance = mediaQuery.size.width * 0.5;

      setState(() {
        _rightIconVisibility[index] = false;
      });
      controller.animateTo(
        maxOffset + increaseDistance,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToLeft(int index, MediaQueryData mediaQuery) {
    final controller = _scrollControllers[index];
    final double scrollDistance = mediaQuery.size.width * 0.4;
    final double newPosition = controller.offset - scrollDistance;

    if (newPosition >= 0) {
      controller.animateTo(
        newPosition,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

      if (newPosition == 0 && newPosition < scrollDistance) {
        setState(() {
          _isRightScrollPerformed[index] = false;
          _rightIconVisibility[index] = true;
        });
      }
    } else {
      setState(() {
        _isRightScrollPerformed[index] = false;
        _rightIconVisibility[index] = true;
      });
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToItem(int index, int itemIndex) {
    final controller = _scrollControllers[index];
    final double newPosition = itemIndex * 150.0;
    controller.animateTo(
      newPosition,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToRightDebounced(int index) {
    _scrollRightMemoizers[index].runOnce(() async {
      _scrollToRight(index, MediaQuery.of(context));
      await Future.delayed(debounceDuration);
      _scrollRightMemoizers[index] = AsyncMemoizer();
    });
  }

  void _scrollToLeftDebounced(int index) {
    _scrollLeftMemoizers[index].runOnce(() async {
      _scrollToLeft(index, MediaQuery.of(context));
      await Future.delayed(debounceDuration);
      _scrollLeftMemoizers[index] = AsyncMemoizer();
    });
  }

  void _handleDueDate(String dueDate) {
    setState(() {
      this.dueDate = formatDueDate(dueDate);
      filterTrimesters();
    });
  }

  void filterTrimesters() {
    if (dueDate == null || dataList.isEmpty) return;

    final currentDate = DateTime.now();
    final dueDateObj = DateTime.parse(dueDate!);
    final totalWeeks = ((dueDateObj.difference(currentDate).inDays) / 7).ceil();
    final pregnancyWeeks = 40 - totalWeeks;

    setState(() {
      filteredTrimesters = dataList.where((trimester) {
        final endWeek = trimester['endWeek'] as int;
        return pregnancyWeeks <= endWeek;
      }).toList();
    });
  }

  String formatDueDate(String dueDateString) {
    DateTime dueDate = DateTime.parse(dueDateString);
    return DateFormat('yyyy-MM-dd').format(dueDate);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Pregnancy Tracker",
            style: (displayType == 'desktop' || displayType == 'tablet')
                ? FTextStyle.appTitleStyleTablet
                : FTextStyle.appTitleStyle,
          ),
        ),
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
                  ? 24.w
                  : 24, // Set width as needed
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 24.h
                  : 24, // Set height as needed
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            thickness: 2,
            color: AppColors.linecolor,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 121.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeeksTrimster()));
                      },
                      child: displayType == "mobile"
                          ? Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: SizedBox(
                                width: _mediaQuery.size.width,
                                child: Image.asset(
                                        'assets/Images/Frame 1991425262.png',
                                        fit: BoxFit.contain)
                                    .animateOnPageLoad(animationsMap[
                                        'imageOnPageLoadAnimation2']!),
                              ),
                            )
                          : Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 10.w),
                              width: _mediaQuery.size.width,
                              child: Image.asset(
                                      'assets/Images/Frame 1991425262.png',
                                      fit: BoxFit.contain)
                                  .animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                            ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PersonalizedTracker()),
                        );
                        if (dueDate != null) {
                          _handleDueDate(successResponse['dueDate']);
                        }
                      },
                      hoverColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      focusColor: Colors.transparent,
                      child: displayType == "mobile"
                          ? Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: SizedBox(
                                width: _mediaQuery.size.width,
                                child: Image.asset(
                                  'assets/Images/Frame 1991425261.png',
                                  fit: BoxFit.contain,
                                ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                              ),
                            )
                          : Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 10.w),
                              width: _mediaQuery.size.width,
                              child: Image.asset(
                                      'assets/Images/Frame 1991425261.png',
                                      fit: BoxFit.contain)
                                  .animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocListener<PregnancyBloc, PregnancyState>(
            listener: (context, state) {
              if (state is PregnancyLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is PregnancyLoaded) {
                setState(() {
                  isLoading = false;
                  dataList = state.trimesters;
                  filterTrimesters(); // Filter trimesters when data is loaded
                });
              } else if (state is WeekByTrimesterLoaded) {
                setState(() {
                  isLoading = false;
                  trimesterWeeks[state.trimesterId] = state.weeks;
                });
              } else if (state is UserProfileLoaded) {
                setState(() {
                  isLoading = false;
                  successResponse = state.successResponse;
                  if (successResponse.containsKey('dueDate')) {
                    _handleDueDate(successResponse['dueDate']);
                  } else {
                    print('Key "dueDate" not found in successResponse');
                  }
                });
              } else if (state is UserProfileError) {
                setState(() {
                  isLoading = false;
                  Map<String, dynamic> failureResponse = state.failureResponse;
                  print('UserProfileError: $failureResponse');
                });
              }
            },
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.pink))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: filteredTrimesters.length,
                          itemBuilder: (context, trimesterIndex) {
                            final trimester =
                                filteredTrimesters[trimesterIndex];
                            final trimesterId = trimester['_id'];
                            final weeksForTrimester =
                                trimesterWeeks[trimesterId] ?? [];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: trimesterIndex == 0
                                      ? const EdgeInsets.only(
                                          left: 12.0, top: 24, bottom: 10)
                                      : const EdgeInsets.only(
                                          left: 12.0, top: 30, bottom: 10),
                                  child: Text(
                                    trimester['trimesterName'],
                                    style: FTextStyle.blackstyle,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? _mediaQuery.size.height * 0.22
                                          : _mediaQuery.size.height * 0.19,
                                      child: GestureDetector(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: weeksForTrimester.length,
                                          itemBuilder: (context, index) {
                                            final listWeek =
                                                weeksForTrimester[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchResult(
                                                        weekNumber: listWeek[
                                                            'weekNumber'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Card(
                                                  elevation: 2.5,
                                                  shadowColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13.0),
                                                  ),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  13.0)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              7.0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: _mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                            height: (displayType ==
                                                                        'desktop' ||
                                                                    displayType ==
                                                                        'tablet')
                                                                ? _mediaQuery
                                                                        .size
                                                                        .height *
                                                                    0.16
                                                                : _mediaQuery
                                                                        .size
                                                                        .height *
                                                                    0.13,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          10)),
                                                              child: (listWeek[
                                                                              'description']
                                                                          .isEmpty ||
                                                                      listWeek['description'][0]
                                                                              [
                                                                              'weekThumbnail']
                                                                          .isEmpty)
                                                                  ? Image.asset(
                                                                      'assets/Images/track.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      listWeek['description']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'weekThumbnail'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5.0),
                                                            child: Text(
                                                              'Week ${listWeek['weekNumber']}',
                                                              style: (displayType ==
                                                                          'desktop' ||
                                                                      displayType ==
                                                                          'tablet')
                                                                  ? FTextStyle
                                                                      .smallTextBlackTablet
                                                                  : FTextStyle
                                                                      .smallTextBlack,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

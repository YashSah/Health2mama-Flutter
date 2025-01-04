import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/Activate/activate_bloc.dart';
import 'package:health2mama/apis/Activate/activate_event.dart';
import 'package:health2mama/apis/Activate/activate_state.dart';
import 'package:video_player/video_player.dart';

class TabToStart extends StatefulWidget {
  final String? repsDescription;
  final String? squeezesDescription;
  final String? enduranceDescription;

  const TabToStart({
    Key? key,
    this.repsDescription,
    this.squeezesDescription,
    this.enduranceDescription,
  }) : super(key: key);

  @override
  State<TabToStart> createState() => _TabToStartState();
}

class _TabToStartState extends State<TabToStart> {
  bool isCountDown = false;
  bool isBetweenCountDown = false;
  bool isPelvicGif = false;
  bool _exerciseCompletedSqueezes = false;
  bool _exerciseCompletedReps = false;
  bool _exerciseCompletedEndurance = false;
  bool isEnduranceCtText = false;
  late int _squeezes;
  late int _reps;
  late int _endurance;
  bool _showStartButton = true;
  bool isCompleted = false;
  VideoPlayerController? _controller;
  final String videoUrlSqueezes = PrefUtils.getSquezzesVideo();
  final String videoUrlReps = PrefUtils.getRepsVideo();
  final String videoUrlEndurance = PrefUtils.getEnduranceVideo();
  int isExerciseCount = 0;
  bool _isExerciseActive = true;

  String commonTextFroDes = "";

  @override
  void initState() {
    super.initState();
    _squeezes = PrefUtils.getSqueezes() == 0 ? 5 : PrefUtils.getSqueezes();
    _reps = PrefUtils.getStrength() == 0 ? 3 : PrefUtils.getStrength();
    _endurance = PrefUtils.getEndurance() == 0 ? 10 : PrefUtils.getEndurance();
    BlocProvider.of<ActivateBloc>(context).add(FetchLearnHowToActivate());
  }

  void _resetStopwatch() {
    setState(() {
      isCountDown = false;
      isBetweenCountDown = false;
      _showStartButton = true;
      isPelvicGif = false;
      _exerciseCompletedSqueezes = false;
      _exerciseCompletedReps = false;
      _exerciseCompletedEndurance = false;
      isEnduranceCtText = false;
      isExerciseCount = 0;
      commonTextFroDes = "";
      if (_controller != null) {
        _controller?.removeListener(() {});
        _controller?.dispose();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  int _calculateAndStoreHealthPoints() {
    // Total health points to be awarded
    const int totalHealthPoints = 40;

    // Count the number of available video phases
    int availablePhases = 0;
    if (videoUrlSqueezes.isNotEmpty) availablePhases++;
    if (videoUrlReps.isNotEmpty) availablePhases++;
    if (videoUrlEndurance.isNotEmpty) availablePhases++;

    // Avoid division by zero
    if (availablePhases == 0) {
      print("No exercise phases available. No health points awarded.");
      return 0;
    }

    // Calculate points per phase
    int pointsPerPhase = (totalHealthPoints / availablePhases).ceil();

    // Determine completed phases and assign points
    int completedPhases = 0;
    if (_exerciseCompletedSqueezes) completedPhases++;
    if (_exerciseCompletedReps) completedPhases++;
    if (_exerciseCompletedEndurance) completedPhases++;

    // Award points based on completed phases
    int healthPoints = completedPhases * pointsPerPhase;

    // Ensure not exceeding the maximum health points
    healthPoints =
        healthPoints > totalHealthPoints ? totalHealthPoints : healthPoints;

    // Debugging logs
    print("Available Phases: $availablePhases");
    print("Completed Phases: $completedPhases");
    print("Points Per Phase: $pointsPerPhase");
    print("Total Health Points Awarded: $healthPoints");

    return healthPoints;
  }

// Update state variables when each phase is completed
  void _markPhaseCompleted(String phase) {
    setState(() {
      if (phase == "squeezes") _exerciseCompletedSqueezes = true;
      if (phase == "reps") _exerciseCompletedReps = true;
      if (phase == "endurance") _exerciseCompletedEndurance = true;
    });
  }

// Example usage: Call `_markPhaseCompleted` when a phase ends
  void _onSqueezesCompleted() {
    _markPhaseCompleted("squeezes");
  }

  void _onRepsCompleted() {
    _markPhaseCompleted("reps");
  }

  void _onEnduranceCompleted() {
    _markPhaseCompleted("endurance");
  }

  void _playVideo(String url, bool isEndurance, Function onVideoEnd) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    bool isHalfVideoPlay = false;

    // Initialize the video player controller
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _controller!.setLooping(false);
          _showStartButton =
              false; // Hide "Tap to Start" button when video starts
        });

        if (isEndurance) {
          // Play the first part of the video up to enduranceSeconds
          Duration videoDuration = _controller!.value.duration;
          _controller!.play();
          _controller!.addListener(() {
            if (isHalfVideoPlay) {
              if (_controller!.value.position >= _controller!.value.duration) {
                _controller!.pause();
                _controller!.removeListener(() {});
                onVideoEnd();
                _onEnduranceCompleted();
              }
            } else {
              if (_controller!.value.position.inSeconds >=
                  (videoDuration.inSeconds / 2)) {
                _controller!.pause();
                _controller!.removeListener(() {});

                _startEnduranceTimer(_endurance, () {
                  // Resume playing the remaining video after endurance hold
                  isHalfVideoPlay = true;
                  _controller!.play();
                });
              }
            }
          });
        } else {
          // Play the video normally
          _controller!.play();
          _controller!.addListener(() {
            if (_controller!.value.position >= _controller!.value.duration) {
              _controller!.pause();
              _controller!.removeListener(() {});
              onVideoEnd();
            }
          });
        }
      });
  }

  void _startEnduranceTimer(int seconds, Function onTimerComplete) {
    int remainingTime = seconds;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          isEnduranceCtText = true;
          isExerciseCount = remainingTime;
        });
        remainingTime--;
      } else {
        timer.cancel();
        setState(() {
          isExerciseCount = 0; // Clear the timer text after hold
        });
        onTimerComplete(); // Automatically resume the video after hold
      }
    });
  }

  Future<void> _playVideoSequence(
      String url, int count, bool isEndurance) async {
    if (isEndurance) {
      await _playVideoAsync(url, isEndurance);
    } else {
      for (int i = 0; i < count; i++) {
        await _playVideoAsync(url, isEndurance); // Always play normally
        setState(() {
          isExerciseCount++;
        });
      }
    }
  }

// Play a video asynchronously
  Future<void> _playVideoAsync(String url, bool isEndurance) async {
    Completer<void> videoComplete = Completer();

    _playVideo(url, isEndurance, () {
      videoComplete.complete();
    });

    await videoComplete.future; // Wait until video completes
  }

// Start the exercise sequence (squeezes, reps, and endurance)
  void _startExerciseSequence() async {
    _isExerciseActive = true;
    // Check if any video URL list is non-empty before starting
    if (videoUrlSqueezes.isNotEmpty ||
        videoUrlReps.isNotEmpty ||
        videoUrlEndurance.isNotEmpty) {
      // Play squeezes videos if available
      if (_isExerciseActive && videoUrlSqueezes.isNotEmpty) {
        setState(() {
          commonTextFroDes = widget.squeezesDescription ?? "";
        });
        await _playVideoSequence(videoUrlSqueezes, _squeezes, false);
        if (_isExerciseActive &&
            (videoUrlReps.isNotEmpty || videoUrlEndurance.isNotEmpty)) {
          await _showCountdown(3);
          _onSqueezesCompleted();
        }
      }

      // Play reps videos if available
      if (_isExerciseActive && videoUrlReps.isNotEmpty) {
        setState(() {
          commonTextFroDes = widget.repsDescription ?? "";
        });
        await _playVideoSequence(videoUrlReps, _reps, false);
        if (_isExerciseActive && videoUrlEndurance.isNotEmpty) {
          await _showCountdown(3);
          _onRepsCompleted();
        }
      }

      // Play endurance videos if available
      if (_isExerciseActive && videoUrlEndurance.isNotEmpty) {
        setState(() {
          isEnduranceCtText = false;
          commonTextFroDes = widget.enduranceDescription ?? "";
        });
        await _playVideoSequence(videoUrlEndurance, 0, true);
      }
    } else {
      // Handle case where no videos are available
      print("No videos to play.");
    }
  }

  // Show countdown before an exercise or transition
  Future<void> _showCountdown(int seconds) async {
    setState(() {
      isPelvicGif = false;
      isEnduranceCtText = false;
      isCountDown = true;
      isBetweenCountDown = true;
      isExerciseCount = 0;
    });

    await Future.delayed(Duration(seconds: seconds));

    setState(() {
      isPelvicGif = true;
      isEnduranceCtText = true;
      isCountDown = false;
      isBetweenCountDown = false;
    });
  }

  // Handle exercise delay
  void _startDelay() {
    setState(() {
      isCountDown = true;
      isBetweenCountDown = false;
      isPelvicGif = false;
      isEnduranceCtText = false;
      _showStartButton = false;
    });
    Future.delayed(const Duration(seconds: 3), _handler);
  }

  // Handle delay completion and start exercise sequence
  void _handler() {
    setState(() {
      isCountDown = false;
      isBetweenCountDown = false;
      isPelvicGif = true;
      isEnduranceCtText = true;
    });
    _startExerciseSequence();
  }

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
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    final userStage = PrefUtils.getUserStage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(
            left: (displayType == 'desktop' || displayType == 'tablet')
                ? 10.w
                : 8.0,
          ),
          child: Text(
            "Activate",
            style: (displayType == 'desktop' || displayType == 'tablet')
                ? FTextStyle.appBarTitleStyleTablet
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
                  ? 10.h
                  : 22.0,
            ),
            child: Image.asset(
              "assets/Images/back.png",
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 70.h
                  : 14,
              width: (displayType == 'desktop' || displayType == 'tablet')
                  ? 70.w
                  : 14,
            ),
          ),
        ),
      ),
      body: BlocListener<ActivateBloc, LearnHowToActivateState>(
        listener: (context, state) {
          if (state is ExerciseRecordSuccess) {
            setState(() {
              _isExerciseActive = false;
            });
            _resetStopwatch();

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ImagePopupWithButton(
                  message: isCompleted
                      ? "Activate exercise Completed!"
                      : "Activate exercise partially Completed!",
                  onOkPressed: () {
                    Navigator.pop(
                        context); // Close the dialog when OK is pressed
                  },
                );
              },
            );
          } else if (state is ExerciseRecordFailure) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(state.errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? 30.h
                                : 12),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Visibility(
                                visible:
                                    _showStartButton, // Control visibility with state variable
                                child: InkWell(
                                  onTap: () {
                                    _startDelay();
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/Images/stack1.png'),
                                        height: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 200.h
                                            : 150,
                                        width: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 200.w
                                            : 150,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Image(
                                        image: AssetImage(
                                            'assets/Images/stack2.png'),
                                        height: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 150.h
                                            : 120,
                                        width: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 150.w
                                            : 120,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!),
                                      Image(
                                        image: AssetImage(
                                            'assets/Images/stack3.png'),
                                        height: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 150.h
                                            : 125,
                                        width: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 150.h
                                            : 125,
                                      ),
                                      Text(
                                        'Tab To\n  Start',
                                        style: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.tabToStartTextStyleTab
                                            : FTextStyle.tabToStartTextStyle,
                                      ).animateOnPageLoad(animationsMap[
                                          'imageOnPageLoadAnimation2']!)
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isCountDown,
                                child: Container(
                                    height: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 230.h
                                        : 125,
                                    width: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 180.w
                                        : 125,
                                    child: ClipOval(
                                        child: Transform.translate(
                                      offset: Offset(
                                        (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? -20.0
                                            : -0.90, // Adjust this value as needed
                                        (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? -20.0
                                            : -0.90, // Adjust this value as needed
                                      ),
                                      child: Image.asset(
                                        "assets/Images/5_sec_counter.gif",
                                        height: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 180.h
                                            : 125,
                                      ),
                                    ))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Visibility(
                        visible: isEnduranceCtText,
                        child: Text(
                          isExerciseCount.toString(),
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.timerTextTab
                              : FTextStyle.timerText,
                        ),
                      ),
                      Visibility(
                        visible: isPelvicGif,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Center(
                            child: Container(
                              height: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 220.h
                                  : 180.h,
                              width: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? 300.h
                                  : 200.h,
                              child: _controller != null &&
                                      _controller!.value.isInitialized
                                  ? VideoPlayer(_controller!)
                                  : const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.pink)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                            isBetweenCountDown ? "Rest" : commonTextFroDes,
                            style: (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                ? FTextStyle.appTitleStyleTablet
                                : FTextStyle.appTitleStyle),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Visibility(
                        visible: isPelvicGif,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFF58CA9)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              (displayType == 'desktop' ||
                                                      displayType == 'tablet')
                                                  ? 8.0.r
                                                  : 8.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Restart',
                                      style: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle.tabToStartButtonTab
                                          : FTextStyle.tabToStartButton,
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      int healthPoints =
                                          _calculateAndStoreHealthPoints();
                                      print("healthPoints>>>> $healthPoints");
                                      isCompleted = healthPoints == 40;
                                      print(
                                          "healthPoints isCompleted>>>> $isCompleted");
                                      context
                                          .read<ActivateBloc>()
                                          .add(PostExerciseRecord(
                                            stage: userStage,
                                            completed: isCompleted,
                                            points: healthPoints,
                                          ));
                                      context.read<ActivateBloc>().add(
                                          AddPointsToUserWallet(
                                              points: healthPoints));
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFF58CA9)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              (displayType == 'desktop' ||
                                                      displayType == 'tablet')
                                                  ? 8.0.r
                                                  : 8.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'End Exercise',
                                      style: (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                          ? FTextStyle.tabToStartButtonTab
                                          : FTextStyle.tabToStartButton,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

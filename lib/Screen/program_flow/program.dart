import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/pregnnacy/pregnnacy_tracker.dart';
import 'package:health2mama/Screen/program_flow/quizScreen.dart';
import 'package:health2mama/Screen/program_flow/recipe_section_sub.dart';
import 'package:health2mama/Screen/program_flow/recipes_description.dart';
import 'package:health2mama/Screen/program_flow/section_topic_listing.dart';
import 'package:health2mama/Screen/program_flow/selected_workout.dart';
import 'package:health2mama/Screen/program_flow/sub_data_screen.dart';
import 'package:health2mama/Screen/program_flow/topic_description.dart';
import 'package:health2mama/Screen/program_flow/workout.dart';
import 'package:health2mama/Screen/subscription_plan/buy_subscription_screen.dart';
import 'package:health2mama/apis/auth_flow/authentication_bloc.dart';
import 'package:health2mama/apis/auth_flow/authentication_event.dart';
import 'package:health2mama/apis/drawer/drawer_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/subscription_plan/subscription_bloc.dart';
import '../../Utils/CommonFuction.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../Utils/pref_utils.dart';
import '../FluterFlow/flutter_flow_animations.dart';
import '../forums/forums_topics.dart';
import 'dart:developer' as developer;

class Programs extends StatefulWidget {
  const Programs({super.key});

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _programData = [];
  List<Map<String, dynamic>> _filteredProgramData = [];
  List<dynamic> _filteredProgramData1 = [];
  List<dynamic> _filteredTopicsData = [];
  List<dynamic> _filteredWorkoutCategoriesData = [];
  List<dynamic> _filteredRecipesData = [];
  bool _isSubscriptionActive = false;
  bool isProgramsLoading = false;
  bool isNoDataImage = false;
  bool isViewProfileLoading = false;
  bool isSearching = false;
  int currentPage = 1;
  int limit = 30;
  Timer? _debounce;
  List<Map<String, dynamic>> percentages = [];
  bool isPercentagesLoading = false;

  String _coreProgramOpted = "";

  Future<bool> _onWillPop() async {
    // Show the exit confirmation dialog
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          insetPadding:
              const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    "assets/Images/exit.png",
                    height: 60,
                    width: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    "Exit",
                    style: FTextStyle.logout,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "Are you sure you want to exit from the application?",
                  style: FTextStyle.lightTextlarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 45,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, false); // No
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.defaultButton),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color: AppColors.appBlue, width: 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(
                                color: AppColors.appBlue, fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      SizedBox(
                        width: 100,
                        height: 45,
                        child: TextButton(
                          onPressed: () {
                            SystemNavigator.pop(); // Close the app
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.appBlue),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                AppColors.whiteColor),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color: Colors.white, width: 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                color: AppColors.whiteColor, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Return true if the user confirmed they want to exit, otherwise return false
    return Future.value(shouldExit ?? false);
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

  double getPercentageForProgram(String programId) {
    final percentageData = percentages.firstWhere(
      (element) => element['programId'] == programId,
      orElse: () => {'percentage': '0'}, // Default to 0 if not found
    );
    return double.tryParse(percentageData['percentage'] ?? '0') ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthenticationBloc>(context).add(SelectStageRequested(stage: PrefUtils.getUserStage()));
    BlocProvider.of<DrawerBloc>(context).add(LoadUserProfile());
    _searchController.addListener(_onSearchChanged);
    print('${_coreProgramOpted}');
    print('${PrefUtils.getUserStage()}');
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        _resetSearch();
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      isSearching = true;
    });
    PrefUtils.setIsSearching(true);
    BlocProvider.of<AuthenticationBloc>(context).add(GlobalSearchEvent(search: query, limit: limit, page: currentPage));
    BlocProvider.of<ProgramflowBloc>(context).add(FetchProgramEvent(PrefUtils.getCategoryId()));
    BlocProvider.of<ProgramflowBloc>(context).add(FetchProgramPercentageEvent(PrefUtils.getCategoryId()));
  }

  void _resetSearch() {
    setState(() {
      isSearching = false;
    });
    PrefUtils.setIsSearching(false);
    BlocProvider.of<AuthenticationBloc>(context)
        .add(SelectStageRequested(stage: PrefUtils.getUserStage()));
  }

  void _updateProgramData(dynamic apiResponse) {
    if (apiResponse is List) {
      _programData =
          apiResponse.map((item) => item as Map<String, dynamic>).toList();
      _filteredProgramData = List.from(_programData);
    } else {
      print('Unexpected API response type');
    }
  }

  String transformStageText(String stage) {
    if (stage == 'TRYINGTOCONCEIVE') {
      return 'Trying to conceive';
    }

    if (stage == 'PREGNANT') {
      return 'Pregnant';
    }
    if (stage == 'POSTPARTUM') {
      return 'Postpartum';
    }
    if (stage == 'BEYOND') {
      return 'Beyond 6 Weeks + After Birth (Weeks, Months, Years)';
    }
    // Return the text as is if no transformation is needed
    return stage;
  }

  @override
  Widget build(BuildContext context) {

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: MultiBlocListener(
                listeners: [
                  BlocListener<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                    if (state is SelectStageLoading) {
                      setState(() {
                        isProgramsLoading = true;
                      });
                    }
                    if (state is SelectStageSuccess) {
                      setState(() {
                        isProgramsLoading = false;
                        if (_programData.isEmpty) {
                          _updateProgramData(state.SelectStageResponse['result']);
                        }
                      });
                    }
                    if (state is GlobalSearchLoading) {
                      setState(() {
                        isProgramsLoading = true;
                        isNoDataImage = false;
                      });
                    } else if (state is GlobalSearchSuccess) {
                      setState(() {
                        isProgramsLoading = false;
                        isNoDataImage = false;
                        final searchResults = state.GlobalSearchResponse;
                        _filteredProgramData1 =
                            searchResults['programs']['data'] ?? [];
                        _filteredTopicsData =
                            searchResults['topics']['data'] ?? [];
                        _filteredWorkoutCategoriesData =
                            searchResults['workoutSubCategories']['data'] ?? [];
                        _filteredRecipesData =
                            searchResults['recipes']['data'] ?? [];
                      });
                    } else if (state is GlobalSearchFailure) {
                      setState(() {
                        isProgramsLoading = false;
                        _filteredProgramData1 = [];
                        final errorMessage =
                            state.GlobalSearchFailureResponse['error'] ??
                                'Something went wrong!';
                        // You might want to display this error in the UI as well
                        isNoDataImage = true;
                      });
                    }
                  }),
                  BlocListener<DrawerBloc, DrawerState>(
                      listener: (context, state) {
                        print("🥲DrawerBloc state: $state"); // Debug line
                    if (state is UserProfileLoading) {
                      setState(() {
                        isViewProfileLoading = true;
                      });
                    }
                    if (state is UserProfileLoaded) {
                      print("UserProfileLoaded state detected"); // Debug here
                      isViewProfileLoading = false;
                      final userProfile = state.successResponse;
                      developer.log(">>>>>>>>>>>>>>>>$userProfile");
                      _coreProgramOpted = userProfile['coreProgramOpted']; //set coreProgramOpted to show or hide the quiz card
                      developer.log(">>>>>>>>>>>>>>>>$_coreProgramOpted");
                      if(userProfile['subscriptions'] != null) {
                        final subscriptionEndDate = DateTime.parse(userProfile['subscriptions']['endDate']);
                        // Check if the subscription is active
                        final isSubscriptionActive =
                        DateTime.now().isBefore(subscriptionEndDate);

                        setState(() {
                          _isSubscriptionActive = isSubscriptionActive;
                        });
                      }
                    }
                  })
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      height: 1,
                      color: AppColors.primaryGreyColor,
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                        ? 3
                                        : 0,
                                  ),
                                  width: width * 0.65,
                                  decoration: const BoxDecoration(
                                      color: AppColors.primaryGreyColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  child: Center(
                                    child: TextFormField(
                                      controller: _searchController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(60),
                                      ],
                                      textAlign: TextAlign
                                          .start, // Center align the hint text
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search here...',
                                        hintStyle: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? FTextStyle.searchBarHintStyleTablet
                                            : FTextStyle.searchBarHintStyle,
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: AppColors.primaryPinkColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            padding: const EdgeInsets.all(12),
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/Images/searchIcon.png'),
                                              width: 17,
                                              height: 17,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(
                                      animationsMap['imageOnPageLoadAnimation2']!),
                                ),
                              ),
                              Container(
                                width: width * 0.30,
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForumsListing()),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.primaryPinkColor,
                                            width: 2)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Ask ? ',
                                        style: FTextStyle.askInfoStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ).animateOnPageLoad(
                                    animationsMap['imageOnPageLoadAnimation2']!),
                              )
                            ],
                          ),

                          const SizedBox(height: 10), // Add spacing between the Ask and Edit Quiz buttons
                          if (PrefUtils.getUserStage() == "BEYOND" && _coreProgramOpted != "NOTATTEMPTED") // Conditional visibility for Edit Quiz button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: width * 0.30,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                                    ),
                                    onPressed: () {
                                      // Navigate to the quiz editing screen or perform your desired action
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const QuizScreen()), // Replace with your quiz editing screen
                                      ).then((value) async {
                                        if(value != null) {
                                          if(value[0]) {
                                            await Future.delayed(const Duration(seconds: 2));
                                            refreshApi();
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.primaryPinkColor, // Background color for the button
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Edit Quiz',
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? 30.h
                              : 16,
                          top: 5),
                      child: Text(
                        transformStageText(PrefUtils.getUserStage()),
                        style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                            ? FTextStyle.programsHeadingStyleTab
                            : FTextStyle.programsHeadingStyle,
                      ).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                    ),
                    SizedBox(
                      height:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 10.h
                              : 10,
                    ),
                    isSearching
                        ? isProgramsLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.pink))
                            : isNoDataImage
                                ? Center(
                                    child: Image.asset(
                                        'assets/Images/nodata.jpg',
                                        height: 265.sp))
                                : Expanded(
                                    child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          (_filteredProgramData1 != null &&
                                                  _filteredProgramData1
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Programs",
                                                          style: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? FTextStyle
                                                                  .programsHeadingStyleTab1
                                                              : FTextStyle
                                                                  .programsHeadingStyle1),
                                                      SizedBox(height: 4.sp),
                                                      GridView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 3
                                                              : 2,
                                                          crossAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 2.h
                                                              : 2,
                                                          mainAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 16.h
                                                              : 16,
                                                          childAspectRatio: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 1.2
                                                              : 1,
                                                        ),
                                                        itemCount:
                                                            _filteredProgramData1
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _filteredProgramData1[
                                                                  index];
                                                          final text = item[
                                                                  'programName'] ??
                                                              '';
                                                          final image = item[
                                                                  'programThumbnailImage'] ??
                                                              '';
                                                          final programId =
                                                              item['_id'] ?? '';
                                                          var percentageString =
                                                              item[
                                                                  'percentage'];
                                                          double
                                                              percentageValue =
                                                              double.parse(
                                                                      percentageString) /
                                                                  100;
                                                          final saveAs =
                                                              item['saveAs'] ??
                                                                  '';

                                                          void _navigateToScreen(
                                                              String
                                                                  categoryName) {
                                                            PrefUtils
                                                                .setCategoryId(
                                                                    programId);
                                                            Widget screen =
                                                                SubDataScreen(
                                                                    programId:
                                                                        programId,
                                                                    programName:
                                                                        categoryName);
                                                            Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => BlocProvider.value(
                                                                          value: BlocProvider.of<ProgramflowBloc>(
                                                                              context),
                                                                          child:
                                                                              screen),
                                                                    ))
                                                                .then((result) {
                                                              if (result != null &&
                                                                  result
                                                                      is List &&
                                                                  result
                                                                      .isNotEmpty &&
                                                                  result[0] ==
                                                                      true) {
                                                                BlocProvider.of<
                                                                            ProgramflowBloc>(
                                                                        context)
                                                                    .add(FetchProgramEvent(
                                                                        PrefUtils
                                                                            .getCategoryId()));
                                                                BlocProvider.of<
                                                                            ProgramflowBloc>(
                                                                        context)
                                                                    .add(FetchProgramPercentageEvent(
                                                                        PrefUtils
                                                                            .getCategoryId()));
                                                              }
                                                            }).catchError(
                                                                    (error) {
                                                              print(
                                                                  "Navigation error: $error");
                                                            });
                                                          }

                                                          return GestureDetector(
                                                            onTap: () {
                                                              _navigateToScreen(
                                                                  text);
                                                            },
                                                            child: Opacity(
                                                              opacity: (_isSubscriptionActive &&
                                                                      saveAs ==
                                                                          'LOCKED')
                                                                  ? 1.0
                                                                  : 1.0,
                                                              child: Card(
                                                                elevation: 2,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(20),
                                                                          topRight:
                                                                              Radius.circular(20),
                                                                        ),
                                                                        child: Image
                                                                            .network(
                                                                          image,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.1,
                                                                          errorBuilder: (context, error, stackTrace) =>
                                                                              Icon(Icons.error),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                5.0),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            LinearProgressIndicator(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              value: percentageValue,
                                                                              // Use the calculated percentage value
                                                                              backgroundColor: Colors.grey[300],
                                                                              color: const Color.fromRGBO(225, 84, 153, 1),
                                                                              // Pink color
                                                                              minHeight: 5.0,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  '${percentageString}%',
                                                                                  // Show percentage on the left side
                                                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                                                ),
                                                                                const Text(
                                                                                  '100%',
                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          text,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                                                              ? FTextStyle.programsGridStyleTab
                                                                              : FTextStyle.programsGridStyle,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          (_filteredTopicsData != null &&
                                                  _filteredTopicsData
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Topics",
                                                          style: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? FTextStyle
                                                                  .programsHeadingStyleTab1
                                                              : FTextStyle
                                                                  .programsHeadingStyle1),
                                                      SizedBox(height: 4.sp),
                                                      GridView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 3
                                                              : 2,
                                                          crossAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 2.h
                                                              : 2,
                                                          mainAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 16.h
                                                              : 16,
                                                          childAspectRatio: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 1.2
                                                              : 1,
                                                        ),
                                                        itemCount:
                                                            _filteredTopicsData
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _filteredTopicsData[
                                                                  index];
                                                          final topicName =
                                                              item['topicName'] ??
                                                                  'No title';
                                                          final topicImage =
                                                              item['topicThumbnailImage'] ??
                                                                  '';
                                                          final saveAs =
                                                              item['saveAs'] ??
                                                                  '';
                                                          final topicId =
                                                              item['_id'] ?? '';
                                                          final contentDetails =
                                                              item['contentDetails'] ??
                                                                  '';

                                                          void _navigateToScreen(
                                                              String
                                                                  categoryName) {
                                                            Widget screen;
                                                            screen =
                                                                TopicDescription(
                                                              topicName:
                                                                  topicName,
                                                              // Pass the topicName
                                                              topicImage:
                                                                  topicImage,
                                                              contentDetails:
                                                                  contentDetails, // Pass the topicThumbnail
                                                            );
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    BlocProvider
                                                                        .value(
                                                                  value: BlocProvider
                                                                      .of<ProgramflowBloc>(
                                                                          context),
                                                                  child: screen,
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          return GestureDetector(
                                                            onTap: () {
                                                              _navigateToScreen(
                                                                  topicName); // Navigate as if it's a free program
                                                            },
                                                            child: Opacity(
                                                              opacity: (_isSubscriptionActive &&
                                                                      saveAs ==
                                                                          'LOCKED')
                                                                  ? 1.0
                                                                  : 1.0,
                                                              child: Card(
                                                                elevation: 2,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.only(
                                                                              topLeft: Radius.circular(20),
                                                                              topRight: Radius.circular(20),
                                                                            ),
                                                                            child:
                                                                                Image.network(
                                                                              topicImage,
                                                                              fit: BoxFit.cover,
                                                                              width: double.infinity,
                                                                              height: MediaQuery.of(context).size.height * 0.12,
                                                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                                                return Image.asset(
                                                                                  'assets/Images/defaultprogram.png',
                                                                                  fit: BoxFit.cover,
                                                                                  width: double.infinity,
                                                                                  height: MediaQuery.of(context).size.height * 0.12,
                                                                                );
                                                                              },
                                                                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                          ),
                                                                          if (saveAs == 'FREE' ||
                                                                              (_isSubscriptionActive && saveAs == 'LOCKED'))
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 6, top: 6),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Color.fromARGB(66, 0, 0, 0),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(5),
                                                                                      child: Text(
                                                                                        'FREE',
                                                                                        style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.completeprogressStyleTab : FTextStyle.completeprogressStyle,
                                                                                      ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          if (saveAs == 'LOCKED' &&
                                                                              !_isSubscriptionActive)
                                                                            Container(
                                                                              height: MediaQuery.of(context).size.height * 0.12,
                                                                              decoration: const BoxDecoration(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(20),
                                                                                  topRight: Radius.circular(20),
                                                                                ),
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    AppColors.gradientColorLock1,
                                                                                    AppColors.gradientColorLock2,
                                                                                  ],
                                                                                  begin: Alignment.topCenter,
                                                                                  end: Alignment.bottomCenter,
                                                                                ),
                                                                              ),
                                                                              child: Center(
                                                                                child: Image.asset(
                                                                                  'assets/Images/symbolLock.png',
                                                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : height * 0.08,
                                                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : width * 0.1,
                                                                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        child:
                                                                            Text(
                                                                          topicName,
                                                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                                                              ? FTextStyle.programsGridStyleTab
                                                                              : FTextStyle.programsGridStyle,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          (_filteredWorkoutCategoriesData !=
                                                      null &&
                                                  _filteredWorkoutCategoriesData
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Workout Categories",
                                                          style: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? FTextStyle
                                                                  .programsHeadingStyleTab1
                                                              : FTextStyle
                                                                  .programsHeadingStyle1),
                                                      SizedBox(height: 4.sp),
                                                      GridView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 3
                                                              : 2,
                                                          crossAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 2.h
                                                              : 2,
                                                          mainAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 16.h
                                                              : 16,
                                                          childAspectRatio: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 1.2
                                                              : 1,
                                                        ),
                                                        itemCount:
                                                            _filteredWorkoutCategoriesData
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _filteredWorkoutCategoriesData[
                                                                  index];
                                                          final text = item[
                                                                  'workoutSubCategoryName'] ??
                                                              '';
                                                          List<dynamic> image1 =
                                                              item['image'];
                                                          final saveAs =
                                                              item['saveAs'] ??
                                                                  '';
                                                          final workoutId =
                                                              item['_id'] ?? '';
                                                          final workoutSubCategoryName =
                                                              item['workoutSubCategoryName']
                                                                      as String? ??
                                                                  'Unknown Workout';
                                                          final image = (item['image']
                                                                          as List<
                                                                              dynamic>?)
                                                                      ?.isNotEmpty ==
                                                                  true
                                                              ? (item['image']
                                                                          [0]
                                                                      as String?) ??
                                                                  ''
                                                              : '';
                                                          final exerciseSections =
                                                              item['exerciseSections']
                                                                      as List<
                                                                          dynamic>? ??
                                                                  [];
                                                          'No Time'; // Convert int to String
                                                          final description =
                                                              item['description']
                                                                      as String? ??
                                                                  'No Description';

                                                          void _navigateToScreen(
                                                              String
                                                                  categoryName) {
                                                            Widget screen;
                                                            screen = SelectedWorkout(
                                                                id: workoutId,
                                                                workoutSubCategoryName:
                                                                    text,
                                                                image: image,
                                                                exerciseSections:
                                                                    exerciseSections,
                                                                description:
                                                                    description);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    BlocProvider
                                                                        .value(
                                                                  value: BlocProvider
                                                                      .of<ProgramflowBloc>(
                                                                          context),
                                                                  child: screen,
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          return GestureDetector(
                                                            onTap: () {
                                                              _navigateToScreen(
                                                                  text); // Navigate as if it's a free program
                                                            },
                                                            child: Opacity(
                                                              opacity: (_isSubscriptionActive &&
                                                                      saveAs ==
                                                                          'LOCKED')
                                                                  ? 1.0
                                                                  : 1.0,
                                                              child: Card(
                                                                elevation: 2,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.only(
                                                                              topLeft: Radius.circular(20),
                                                                              topRight: Radius.circular(20),
                                                                            ),
                                                                            child:
                                                                                Image.network(
                                                                              image,
                                                                              fit: BoxFit.cover,
                                                                              width: double.infinity,
                                                                              height: MediaQuery.of(context).size.height * 0.12,
                                                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                                                return Image.asset(
                                                                                  'assets/Images/defaultprogram.png',
                                                                                  fit: BoxFit.cover,
                                                                                  width: double.infinity,
                                                                                  height: MediaQuery.of(context).size.height * 0.12,
                                                                                );
                                                                              },
                                                                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                          ),
                                                                          if (saveAs == 'FREE' ||
                                                                              (_isSubscriptionActive && saveAs == 'LOCKED'))
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 6, top: 6),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Color.fromARGB(66, 0, 0, 0),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(5),
                                                                                      child: Text(
                                                                                        'FREE',
                                                                                        style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.completeprogressStyleTab : FTextStyle.completeprogressStyle,
                                                                                      ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          if (saveAs == 'LOCKED' &&
                                                                              !_isSubscriptionActive)
                                                                            Container(
                                                                              height: MediaQuery.of(context).size.height * 0.12,
                                                                              decoration: const BoxDecoration(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(20),
                                                                                  topRight: Radius.circular(20),
                                                                                ),
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    AppColors.gradientColorLock1,
                                                                                    AppColors.gradientColorLock2,
                                                                                  ],
                                                                                  begin: Alignment.topCenter,
                                                                                  end: Alignment.bottomCenter,
                                                                                ),
                                                                              ),
                                                                              child: Center(
                                                                                child: Image.asset(
                                                                                  'assets/Images/symbolLock.png',
                                                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : height * 0.08,
                                                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : width * 0.1,
                                                                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        child:
                                                                            Text(
                                                                          text,
                                                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                                                              ? FTextStyle.programsGridStyleTab
                                                                              : FTextStyle.programsGridStyle,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          (_filteredRecipesData != null &&
                                                  _filteredRecipesData
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Recipes",
                                                          style: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? FTextStyle
                                                                  .programsHeadingStyleTab1
                                                              : FTextStyle
                                                                  .programsHeadingStyle1),
                                                      SizedBox(height: 4.sp),
                                                      GridView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 3
                                                              : 2,
                                                          crossAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 2.h
                                                              : 2,
                                                          mainAxisSpacing: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 16.h
                                                              : 16,
                                                          childAspectRatio: (displayType ==
                                                                      'desktop' ||
                                                                  displayType ==
                                                                      'tablet')
                                                              ? 1.2
                                                              : 1,
                                                        ),
                                                        itemCount:
                                                            _filteredRecipesData
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _filteredRecipesData[
                                                                  index];
                                                          final text = item[
                                                                  'recipeName'] ??
                                                              '';
                                                          final image = item[
                                                              'recipeThumbnailImage'];
                                                          final saveAs =
                                                              item['saveAs'] ??
                                                                  '';
                                                          final recipeID =
                                                              item['_id'];
                                                          final preparationTime =
                                                              item[
                                                                  'preparationTime'];
                                                          final servings =
                                                              item['servings'];
                                                          final ingredientDetails =
                                                              item[
                                                                  'ingredientDetails'];
                                                          final notes =
                                                              item['notes'];
                                                          final nutrition =
                                                              item['nutrition'];
                                                          final recipeType =
                                                              item[
                                                                  'recipeType'];
                                                          final stepsList =
                                                              List<String>.from(
                                                                  item[
                                                                      'steps']);
                                                          dynamic nutritionData;
                                                          if (nutrition
                                                              is Map) {
                                                            nutritionData = Map<
                                                                    String,
                                                                    dynamic>.from(
                                                                nutrition);
                                                          } else if (nutrition
                                                              is List) {
                                                            nutritionData = List<
                                                                    Map<String,
                                                                        dynamic>>.from(
                                                                nutrition);
                                                          }
                                                          String
                                                              recipeTypeString;
                                                          if (recipeType
                                                                  is List &&
                                                              recipeType
                                                                  .isNotEmpty) {
                                                            recipeTypeString =
                                                                recipeType[0]
                                                                    .toString();
                                                          } else {
                                                            recipeTypeString =
                                                                recipeType
                                                                    .toString();
                                                          }

                                                          void _navigateToScreen(
                                                              String
                                                                  categoryName) {
                                                            Widget screen;
                                                            screen = RecipesDescription(
                                                                recipeName:
                                                                    text,
                                                                recipeThumbnailImage:
                                                                    image,
                                                                preparationTime:
                                                                    preparationTime,
                                                                servings:
                                                                    servings,
                                                                ingredientDetails:
                                                                    ingredientDetails,
                                                                notes: notes,
                                                                steps:
                                                                    stepsList,
                                                                nutrition:
                                                                    nutritionData,
                                                                recipeType:
                                                                    recipeTypeString);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    BlocProvider
                                                                        .value(
                                                                  value: BlocProvider
                                                                      .of<ProgramflowBloc>(
                                                                          context),
                                                                  child: screen,
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          return GestureDetector(
                                                            onTap: () {
                                                              _navigateToScreen(
                                                                  text); // Navigate as if it's a free program
                                                            },
                                                            child: Opacity(
                                                              opacity: (_isSubscriptionActive &&
                                                                      saveAs ==
                                                                          'LOCKED')
                                                                  ? 1.0
                                                                  : 1.0,
                                                              child: Card(
                                                                elevation: 2,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.only(
                                                                              topLeft: Radius.circular(20),
                                                                              topRight: Radius.circular(20),
                                                                            ),
                                                                            child:
                                                                                Image.network(
                                                                              image,
                                                                              fit: BoxFit.cover,
                                                                              width: double.infinity,
                                                                              height: MediaQuery.of(context).size.height * 0.12,
                                                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                                                return Image.asset(
                                                                                  'assets/Images/defaultprogram.png',
                                                                                  fit: BoxFit.cover,
                                                                                  width: double.infinity,
                                                                                  height: MediaQuery.of(context).size.height * 0.12,
                                                                                );
                                                                              },
                                                                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                          ),
                                                                          if (saveAs == 'FREE' ||
                                                                              (_isSubscriptionActive && saveAs == 'LOCKED'))
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 6, top: 6),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Color.fromARGB(66, 0, 0, 0),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(5),
                                                                                      child: Text(
                                                                                        'FREE',
                                                                                        style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.completeprogressStyleTab : FTextStyle.completeprogressStyle,
                                                                                      ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          if (saveAs == 'LOCKED' &&
                                                                              !_isSubscriptionActive)
                                                                            Container(
                                                                              height: MediaQuery.of(context).size.height * 0.12,
                                                                              decoration: const BoxDecoration(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(20),
                                                                                  topRight: Radius.circular(20),
                                                                                ),
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    AppColors.gradientColorLock1,
                                                                                    AppColors.gradientColorLock2,
                                                                                  ],
                                                                                  begin: Alignment.topCenter,
                                                                                  end: Alignment.bottomCenter,
                                                                                ),
                                                                              ),
                                                                              child: Center(
                                                                                child: Image.asset(
                                                                                  'assets/Images/symbolLock.png',
                                                                                  height: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : height * 0.08,
                                                                                  width: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : width * 0.1,
                                                                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        child:
                                                                            Text(
                                                                          text,
                                                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                                                              ? FTextStyle.programsGridStyleTab
                                                                              : FTextStyle.programsGridStyle,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                    ),
                                  ))
                        : Expanded(
                            child: _filteredProgramData.isEmpty
                                ? Center(
                                    // child:CircularProgressIndicator()
                                    // Text(
                                    //   'No category found.',
                                    //   style: FTextStyle
                                    //       .dateTime, // Use your style for this message
                                    // ),
                                    )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: (displayType == 'desktop' ||
                                                displayType == 'tablet')
                                            ? 30.h
                                            : 16),
                                    child:
                                        PrefUtils.getUserStage() == "PREGNANT"
                                            ? GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? 3
                                                          : 2,
                                                  crossAxisSpacing:
                                                      (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? 2.h
                                                          : 2,
                                                  mainAxisSpacing:
                                                      (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? 16.h
                                                          : 16,
                                                  childAspectRatio:
                                                      (displayType ==
                                                                  'desktop' ||
                                                              displayType ==
                                                                  'tablet')
                                                          ? 1.2
                                                          : 1,
                                                ),
                                                itemCount: _filteredProgramData
                                                        .length +
                                                    1,
                                                // Increment item count to account for static item
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  if (index ==
                                                      _filteredProgramData
                                                          .length) {
                                                    // Add the static "Pregnancy Tracker" item at the end of the list
                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Define navigation logic for the Pregnancy Tracker
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    BlocProvider
                                                                        .value(
                                                              value: BlocProvider
                                                                  .of<ProgramflowBloc>(
                                                                      context),
                                                              child:
                                                                  Pregnancytracker(), // Replace with the appropriate widget
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Card(
                                                        elevation: 2,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/Images/pregTracker.webp',
                                                                  // Add your custom image path here
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: double
                                                                      .infinity,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.12,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child: Text(
                                                                  'Pregnancy Tracker',
                                                                  style: (displayType ==
                                                                              'desktop' ||
                                                                          displayType ==
                                                                              'tablet')
                                                                      ? FTextStyle
                                                                          .programsGridStyleTab
                                                                      : FTextStyle
                                                                          .programsGridStyle,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    // Existing logic for other API items
                                                    final item =
                                                        _filteredProgramData[
                                                            index];
                                                    final text =
                                                        item['categoryName'] ??
                                                            '';
                                                    final image =
                                                        item['image'] ?? '';
                                                    final saveAs =
                                                        item['saveAs'] ?? '';
                                                    final categoryId =
                                                        item['_id'] ?? '';

                                                    void _navigateToScreen(
                                                        String categoryName) {
                                                      PrefUtils.setCategoryId(
                                                          categoryId);
                                                      print(
                                                          'Selected Category ID Is : ${PrefUtils.getCategoryId()}');
                                                      Widget screen;
                                                      switch (categoryName) {
                                                        case 'Recipes':
                                                          screen =
                                                              RecipeCategorySub();
                                                          break;
                                                        case 'Workouts':
                                                          screen =
                                                              WorkoutPage();
                                                          break;
                                                        default:
                                                          screen =
                                                              SectionTopicListing(
                                                            categoryName:
                                                                categoryName,
                                                          );
                                                      }
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              BlocProvider
                                                                  .value(
                                                            value: BlocProvider
                                                                .of<ProgramflowBloc>(
                                                                    context),
                                                            child: screen,
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    return GestureDetector(
                                                      onTap: (saveAs == 'FREE' || (_isSubscriptionActive && saveAs == 'LOCKED'))
                                                          ? () {
                                                              _navigateToScreen(
                                                                  text); // Navigate as if it's a free program
                                                            }
                                                          : () {
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) {
                                                        //       return MultiBlocProvider(
                                                        //         providers: [
                                                        //           BlocProvider(
                                                        //             create: (context) => SubscriptionBloc(),
                                                        //           ),
                                                        //           BlocProvider(
                                                        //             create: (context) => DrawerBloc(),
                                                        //           )
                                                        //         ],
                                                        //         child: const BuySubscriptionScreen(),
                                                        //       ); // No need to wrap with BlocProvider here
                                                        //     },
                                                        //   ),
                                                        // );
                                                      },
                                                      child: Opacity(
                                                        opacity:
                                                            (_isSubscriptionActive &&
                                                                    saveAs ==
                                                                        'LOCKED')
                                                                ? 1.0
                                                                : 1.0,
                                                        child: Card(
                                                          elevation: 2,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            ),
                                                          ),
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(20),
                                                                        topRight:
                                                                            Radius.circular(20),
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        image,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width: double
                                                                            .infinity,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.12,
                                                                        errorBuilder: (BuildContext context,
                                                                            Object
                                                                                error,
                                                                            StackTrace?
                                                                                stackTrace) {
                                                                          return Image
                                                                              .asset(
                                                                            'assets/Images/defaultprogram.png',
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.12,
                                                                          );
                                                                        },
                                                                      ).animateOnPageLoad(
                                                                          animationsMap[
                                                                              'imageOnPageLoadAnimation2']!),
                                                                    ),
                                                                    if (saveAs ==
                                                                            'FREE' ||
                                                                        (_isSubscriptionActive &&
                                                                            saveAs ==
                                                                                'LOCKED'))
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                6,
                                                                            top:
                                                                                6),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Container(
                                                                              decoration: const BoxDecoration(
                                                                                color: Color.fromARGB(66, 0, 0, 0),
                                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.all(5),
                                                                                child: Text(
                                                                                  'FREE',
                                                                                  style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.completeprogressStyleTab : FTextStyle.completeprogressStyle,
                                                                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    if (saveAs ==
                                                                            'LOCKED' &&
                                                                        !_isSubscriptionActive)
                                                                      Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.12,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(20),
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                          ),
                                                                          gradient:
                                                                              LinearGradient(
                                                                            colors: [
                                                                              AppColors.gradientColorLock1,
                                                                              AppColors.gradientColorLock2,
                                                                            ],
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child: Image
                                                                              .asset(
                                                                            'assets/Images/symbolLock.png',
                                                                            height: (displayType == 'desktop' || displayType == 'tablet')
                                                                                ? 10.h
                                                                                : height * 0.08,
                                                                            width: (displayType == 'desktop' || displayType == 'tablet')
                                                                                ? 10.h
                                                                                : width * 0.1,
                                                                          ).animateOnPageLoad(
                                                                              animationsMap['imageOnPageLoadAnimation2']!),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  child: Text(
                                                                    text,
                                                                    style: (displayType ==
                                                                                'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                        ? FTextStyle
                                                                            .programsGridStyleTab
                                                                        : FTextStyle
                                                                            .programsGridStyle,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              )
                                            : PrefUtils.getUserStage() == "BEYOND" ? GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: (displayType == 'desktop' || displayType == 'tablet') ? 3 : 2,
                                                  crossAxisSpacing: (displayType == 'desktop' || displayType == 'tablet') ? 2.h : 2,
                                                  mainAxisSpacing: (displayType == 'desktop' || displayType == 'tablet') ? 16.h : 16,
                                                  childAspectRatio: (displayType == 'desktop' || displayType == 'tablet') ? 1.2 : 1,
                                                ),
                                                itemCount: _filteredProgramData.length + (_coreProgramOpted == "NOTATTEMPTED" ? 1 : 0),
                                                shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            // If core program is NOTATTEMPTED and index is 0, show the quiz card
                                            if (_coreProgramOpted == "NOTATTEMPTED" && index == 0) {
                                              // If core program is not attempted, show the Quiz Card
                                              return GestureDetector(
                                                onTap: () async {
                                                  // final updatedCoreProgramOpted = await Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) => QuizScreen()),
                                                  // );
                                                  //
                                                  // if (updatedCoreProgramOpted != null) {
                                                  //   setState(() async {
                                                  //     _coreProgramOpted = updatedCoreProgramOpted;
                                                  //     await Future.delayed(const Duration(seconds: 2));
                                                  //     refreshApi();
                                                  //   });
                                                  // }
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const QuizScreen()), // Replace with your quiz editing screen
                                                  ).then((value) async {
                                                    if(value != null) {
                                                      if(value[0]) {
                                                        _coreProgramOpted = "";
                                                        await Future.delayed(const Duration(seconds: 2));
                                                        refreshApi();
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Card(
                                                  elevation: 2,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(20),
                                                            topRight: Radius.circular(20),
                                                          ),
                                                          child: Image.asset(
                                                            'assets/Images/quiz.jpg',
                                                            fit: BoxFit.cover,
                                                            width: double.infinity,
                                                            height: MediaQuery.of(context).size.height * 0.12,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            'Quiz', // Title of the static card
                                                            style: FTextStyle.programsGridStyle, // Adjust as per your design
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }



                                            // // Check if core program has been attempted and include the Pelvic Floor or Abs Fab program
                                            // if (_coreProgramOpted != "NOTATTEMPTED") {
                                            //   // Insert Pelvic Floor & Core or Abs Fab Program card depending on the selection
                                            //   if (index == _filteredProgramData.length) {
                                            //     // Insert Pelvic Floor & Core or Abs Fab Program based on YES/NO
                                            //     final String categoryId = _coreProgramOpted == "YES" ? "673c5b1f767cfb1de745c08a" : "677236647dd0fac8b5886204";
                                            //
                                            //     // Avoid adding the program if it already exists in the filtered data
                                            //     if (_filteredProgramData.any((item) => item['_id'] == categoryId)) {
                                            //       return SizedBox();
                                            //     }
                                            //
                                            //     return GestureDetector(
                                            //       onTap: () {
                                            //         Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //             builder: (context) => SectionTopicListing(
                                            //               categoryName: _coreProgramOpted == "YES" ? 'Pelvic Floor & Core Program' : 'Abs Fab Program',
                                            //             ),
                                            //           ),
                                            //         );
                                            //       },
                                            //       child: Card(
                                            //         elevation: 2,
                                            //         shape: const RoundedRectangleBorder(
                                            //           borderRadius: BorderRadius.only(
                                            //             topLeft: Radius.circular(20),
                                            //             topRight: Radius.circular(20),
                                            //           ),
                                            //         ),
                                            //         child: Container(
                                            //           color: Colors.white,
                                            //           child: Column(
                                            //             crossAxisAlignment: CrossAxisAlignment.stretch,
                                            //             children: [
                                            //               ClipRRect(
                                            //                 borderRadius: const BorderRadius.only(
                                            //                   topLeft: Radius.circular(20),
                                            //                   topRight: Radius.circular(20),
                                            //                 ),
                                            //                 child: Image.asset(
                                            //                   _coreProgramOpted == "YES"
                                            //                       ? 'assets/Images/pelvic_floor_image.png' // Replace with actual Pelvic Floor image
                                            //                       : 'assets/Images/abs_fab_image.png', // Replace with actual Abs Fab image
                                            //                   fit: BoxFit.cover,
                                            //                   width: double.infinity,
                                            //                   height: MediaQuery.of(context).size.height * 0.12,
                                            //                 ),
                                            //               ),
                                            //               Padding(
                                            //                 padding: const EdgeInsets.all(8.0),
                                            //                 child: Text(
                                            //                   _coreProgramOpted == "YES"
                                            //                       ? 'Pelvic Floor & Core Program' // Name for YES
                                            //                       : 'Abs Fab Program', // Name for NO
                                            //                   style: FTextStyle.programsGridStyle, // Adjust as needed
                                            //                   maxLines: 1,
                                            //                   overflow: TextOverflow.ellipsis,
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     );
                                            //   }
                                            // }




                                            // Calculate the correct index for dynamic cards
                                            final adjustedIndex = _coreProgramOpted == "NOTATTEMPTED" ? index - 1 : index;
                                            // Otherwise, return dynamic card from _filteredProgramData
                                            final item = _filteredProgramData[adjustedIndex];
                                            final text = item['categoryName'] ?? '';
                                            final image = item['image'] ?? '';
                                            final saveAs = item['saveAs'] ?? '';
                                            final categoryId = item['_id'] ?? '';

                                            void _navigateToScreen(String categoryName) {
                                              PrefUtils.setCategoryId(categoryId);
                                              print('Selected Category ID Is : ${PrefUtils.getCategoryId()}');
                                              Widget screen;
                                              switch (categoryName) {
                                                case 'Recipes':
                                                  screen = RecipeCategorySub();
                                                  break;
                                                case 'Workouts':
                                                  screen = WorkoutPage();
                                                  break;
                                                case 'Workout':
                                                  screen = WorkoutPage();
                                                  break;
                                                default:
                                                  screen = SectionTopicListing(
                                                    categoryName: categoryName,
                                                  );
                                              }
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider.value(
                                                value: BlocProvider.of<ProgramflowBloc>(context),
                                                child: screen,
                                              ),
                                              ),
                                              );
                                            }

                                            return GestureDetector(
                                              onTap: (saveAs == 'FREE' || (_isSubscriptionActive && saveAs == 'LOCKED'))
                                                  ? () {
                                                _navigateToScreen(text); // Navigate as if it's a free program
                                              }
                                                  : () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                //   return MultiBlocProvider(
                                                //     providers: [
                                                //       BlocProvider(create: (context) => SubscriptionBloc(),
                                                //       ),
                                                //       BlocProvider(create: (context) => DrawerBloc(),
                                                //       )
                                                //     ],
                                                //     child: const BuySubscriptionScreen(),
                                                //   ); // No need to wrap with BlocProvider here
                                                // },
                                                // ),
                                                // );
                                              },
                                              child: Opacity(
                                                opacity: (_isSubscriptionActive && saveAs == 'LOCKED') ? 1.0 : 1.0,
                                                child: Card(
                                                  elevation: 2,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                              child: Image.network(image, fit: BoxFit.cover, width: double.infinity, height: MediaQuery.of(context).size.height * 0.12,
                                                                errorBuilder: (BuildContext context, Objecterror, StackTrace? stackTrace) {
                                                                  return Image.asset('assets/Images/defaultprogram.png', fit: BoxFit.cover,
                                                                    width: double.infinity,
                                                                    height: MediaQuery.of(context).size.height * 0.12,
                                                                  );
                                                                },
                                                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                            ),
                                                            if (saveAs == 'FREE' || (_isSubscriptionActive && saveAs == 'LOCKED'))
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 6, top: 6),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Container(
                                                                      decoration: const BoxDecoration(
                                                                        color: Color.fromARGB(66, 0, 0, 0),
                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(5),
                                                                        child: Text('FREE',
                                                                          style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.completeprogressStyleTab : FTextStyle.completeprogressStyle,
                                                                        ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            if (saveAs == 'LOCKED' && !_isSubscriptionActive)
                                                              Container(
                                                                height: MediaQuery.of(context).size.height * 0.12,
                                                                decoration: const BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(20),
                                                                    topRight: Radius.circular(20),
                                                                  ),
                                                                  gradient: LinearGradient(
                                                                    colors: [
                                                                      AppColors.gradientColorLock1,
                                                                      AppColors.gradientColorLock2,
                                                                    ],
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Image.asset(
                                                                    'assets/Images/symbolLock.png',
                                                                    height: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : height * 0.08,
                                                                    width: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : width * 0.1,
                                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.all(8),
                                                          child: Text(text,
                                                            style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.programsGridStyleTab : FTextStyle.programsGridStyle,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )

                                            : GridView.builder(gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: (displayType == 'desktop' || displayType == 'tablet') ? 3 : 2,
                                            crossAxisSpacing: (displayType == 'desktop' || displayType == 'tablet') ? 2.h : 2,
                                            mainAxisSpacing: (displayType == 'desktop' || displayType == 'tablet') ? 16.h : 16,
                                            childAspectRatio: (displayType == 'desktop' || displayType == 'tablet') ? 1.2 : 1,
                                          ),
                                          itemCount: _filteredProgramData.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final item = _filteredProgramData[index];
                                            final text = item['categoryName'] ?? '';
                                            final image = item['image'] ?? '';
                                            final saveAs = item['saveAs'] ?? '';
                                            final categoryId = item['_id'] ?? '';
                                            void _navigateToScreen(String categoryName) {
                                              PrefUtils.setCategoryId(categoryId);
                                              print('Selected Category ID Is : ${PrefUtils.getCategoryId()}');
                                              Widget screen;
                                              switch (categoryName) {
                                                case 'Recipes':
                                                  screen = RecipeCategorySub();
                                                  break;
                                                case 'Workouts':
                                                  screen = WorkoutPage();
                                                  break;
                                                case 'Workout':
                                                  screen = WorkoutPage();
                                                  break;
                                                default:
                                                  screen = SectionTopicListing(categoryName: categoryName);
                                              }
                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  BlocProvider.value(
                                                    value: BlocProvider.of<ProgramflowBloc>(context),
                                                    child: screen,
                                                  ),
                                                ),
                                              );
                                            }

                                            return GestureDetector(
                                              onTap: (saveAs == 'FREE' || (_isSubscriptionActive && saveAs == 'LOCKED')) ? () {_navigateToScreen(text); // Navigate as if it's a free program
                                              } : () {
                                                // Navigator.push(context, MaterialPageRoute(
                                                //     builder: (context) {
                                                //       return MultiBlocProvider(
                                                //         providers: [
                                                //           BlocProvider(create: (context) => SubscriptionBloc(),
                                                //           ),
                                                //           BlocProvider(create: (context) => DrawerBloc(),
                                                //           )
                                                //         ],
                                                //         child: const BuySubscriptionScreen(),
                                                //       ); // No need to wrap with BlocProvider here
                                                //     },
                                                //   ),
                                                // );
                                              },
                                              child: Opacity(
                                                opacity: (_isSubscriptionActive && saveAs == 'LOCKED') ? 1.0 : 1.0,
                                                child: Card(elevation: 2,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                                                  ),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                                                              child: Image.network(image, fit: BoxFit.cover,
                                                                width: double.infinity,
                                                                height: MediaQuery.of(context).size.height * 0.12,
                                                                errorBuilder: (BuildContext context, Objecterror, StackTrace? stackTrace) {
                                                                  return Image.asset('assets/Images/defaultprogram.png',
                                                                    fit: BoxFit.cover,
                                                                    width: double.infinity,
                                                                    height: MediaQuery.of(context).size.height * 0.12,
                                                                  );
                                                                },
                                                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                            ),
                                                            if (saveAs == 'FREE' || (_isSubscriptionActive && saveAs == 'LOCKED'))
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 6, top: 6),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                      const BoxDecoration(
                                                                        color: Color.fromARGB(66, 0, 0, 0),
                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(5),
                                                                        child: Text(
                                                                          'FREE',
                                                                          style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.completeprogressStyleTab : FTextStyle.completeprogressStyle,
                                                                        ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            if (saveAs == 'LOCKED' && !_isSubscriptionActive)
                                                              Container(
                                                                height: MediaQuery.of(context).size.height * 0.12,
                                                                decoration: const BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(20),
                                                                    topRight: Radius.circular(20),
                                                                  ),
                                                                  gradient: LinearGradient(
                                                                    colors: [
                                                                      AppColors.gradientColorLock1,
                                                                      AppColors.gradientColorLock2,
                                                                    ],
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                  ),
                                                                ),
                                                                child:
                                                                Center(
                                                                  child: Image.asset('assets/Images/symbolLock.png',
                                                                    height: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : height * 0.08,
                                                                    width: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : width * 0.1,
                                                                  ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.all(8),
                                                          child: Text(text,
                                                            style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.programsGridStyleTab : FTextStyle.programsGridStyle,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                  ),
                          ),
                  ],
                ))));
  }

  void refreshApi() {
    _programData.clear();
    BlocProvider.of<AuthenticationBloc>(context).add(SelectStageRequested(stage: PrefUtils.getUserStage()));
  }
}

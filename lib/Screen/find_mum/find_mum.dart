import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find_mum/find_friend.dart';
import 'package:health2mama/Screen/find_mum/chat_screen.dart';
import 'package:health2mama/Screen/find_mum/mum_details.dart';
import 'package:health2mama/Screen/find_mum/mum_requests.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/StageConverter.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';

class FindMumData extends StatefulWidget {
  const FindMumData({super.key});

  @override
  State<FindMumData> createState() => _FindMumDataState();
}

class _FindMumDataState extends State<FindMumData> {
  bool serviceVisible = false;
  String yourStage1 = "";
  String servicesStage = "";
  bool isButtonEnabled1 = false;
  bool isDropdownVisible1 = false;
  bool isDropdownVisible2 = false;
  bool isDropdownVisible3 = false;
  bool isDropdownVisible4 = false;
  String yourStage2 = "";
  String yourStage3 = "";
  String yourStage4 = "";
  // Track button enabled state
  bool isButtonEnabled2 = false; // Track button enabled state
  bool isButtonEnabled3 = false; // Track button enabled state
  bool isButtonEnabled4 = false;

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

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }

  List<Map<String, dynamic>> serviceStages = [
    {"title": "2 km", "value": "2 km", "selected": false},
    {"title": "4 km ", "value": "4 km ", "selected": false},
    {"title": "6 km", "value": "6 km", "selected": false},
    {"title": "8 km", "value": "8 km", "selected": false},
  ];
  final List<Map<String, dynamic>> findMumData = [];
  List<Map<String, dynamic>> result = [];
  final _scrollController = ScrollController();
  int currentPage = 1;
  int limit = 10;
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool hasMoreData = true;
  bool isLoadingMore = false;
  int totalPages = 0;

  void initState() {
    super.initState();
    _loadContent();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          currentPage < totalPages &&
          !isLoadingMore) {
        _loadMoreContent(); // Trigger to load more content
      }
    });
  }

  void _loadContent() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    BlocProvider.of<FindMumBloc>(context)
        .add(getConnectedMums(page: currentPage, limit: limit));
  }

  Future<void> _onRefresh() async {
    setState(() {
      currentPage = 1; // Reset to first page
      result.clear(); // Clear the existing list
    });
    _loadContent();
  }
  void _loadMoreContent() {
    if (currentPage < totalPages) {
      setState(() {
        isLoadingMore = true;
      });
      currentPage++;
      print('Current Page: $currentPage'); // Print the updated page number
      _loadContent();
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final screenWidth = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Find a Mum",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                (displayType == 'desktop' || displayType == 'tablet')
                    ? 4.w
                    : screenWidth * 0.03,
                vertical: (displayType == 'desktop' || displayType == 'tablet')
                    ? 2.w
                    : screenWidth * 0.01,
              ),
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
        body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    height: 1,
                    color: AppColors.findMumBorderColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: serviceVisible
                                            ? AppColors.boarderColour
                                            : AppColors.boarderColour,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors
                                            .boarderColour, // Color when the field is focused
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors
                                            .boarderColour, // Color when the field is not focused
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    suffixIcon: const Icon(
                                      Icons
                                          .arrow_drop_down, // or Icons.arrow_drop_up based on your condition
                                      color: AppColors.pinkButton,
                                      size: 30,
                                    ),
                                    hintText:
                                    "Select range", // Set an empty hintText initially
                                    hintStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.loginFieldHintTextStyleTablet
                                        : FTextStyle.loginFieldHintTextStyle,
                                    errorStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.formFieldErrorTxtStyleTablet
                                        : FTextStyle
                                        .formFieldErrorTxtStyle, // Set hint color to grey if userPregnancyStage is empty, otherwise black
                                  ),
                                  readOnly:
                                  true, // Making it read-only to show the selected value
                                  controller: TextEditingController(
                                      text: servicesStage), // Setting initial value
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle.cardSubtitleTablet
                                      : FTextStyle.cardSubtitle,
                                  maxLines: 1,
                                  onTap: () {
                                    setState(() {
                                      serviceVisible = !serviceVisible;
                                    });
                                  },
                                ),
                                Visibility(
                                  visible: serviceVisible,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 35),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: AppColors.lightGreyColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: serviceStages.map((stage) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  servicesStage = stage['value']!;
                                                  serviceStages.forEach((s) {
                                                    s['selected'] = (s == stage);
                                                  });
                                                });
                                              },
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    servicesStage = stage['value']!;
                                                    serviceStages.forEach((s) {
                                                      s['selected'] = (s == stage);
                                                    });
                                                  });
                                                  setState(() {
                                                    serviceVisible = !serviceVisible;
                                                  });
                                                  final distanceValue = int.tryParse(
                                                      servicesStage
                                                          .split(' ')[0]) ??
                                                      0;
                                                  print(distanceValue);
                                                  currentPage = 1;
                                                  BlocProvider.of<FindMumBloc>(context)
                                                      .add(
                                                    getConnectedMums(
                                                      page: currentPage,
                                                      limit: limit,
                                                      maxDistance:
                                                      distanceValue, // Pass distance as int
                                                      latitude: PrefUtils.getLatitude(),
                                                      longitude:
                                                      PrefUtils.getLongitude(),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Container(
                                                        width:
                                                        24, // Adjust the width as needed
                                                        height:
                                                        24, // Adjust the height as needed
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              3), // Adjust the radius as needed
                                                          border: Border.all(
                                                            color: stage[
                                                            'selected'] ==
                                                                true
                                                                ? AppColors
                                                                .primaryColorPink
                                                                : AppColors
                                                                .boarderColour,
                                                            width:
                                                            1.5, // Adjust the width as needed
                                                          ),
                                                          color:
                                                          stage['selected'] == true
                                                              ? AppColors
                                                              .primaryColorPink
                                                              : Colors.white,
                                                        ),
                                                        child: stage['selected'] == true
                                                            ? const Icon(
                                                          Icons.check_box,
                                                          color: Colors.white,
                                                          size: 24,
                                                        )
                                                            : null, // No icon when unselected
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        stage['title'],
                                                        maxLines: 3,
                                                        style: (displayType ==
                                                            'desktop' ||
                                                            displayType == 'tablet')
                                                            ? FTextStyle
                                                            .rememberMeTextStyleTablet
                                                            : FTextStyle
                                                            .rememberMeTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (stage !=
                                                serviceStages
                                                    .last) // Add this condition
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 15, bottom: 10),
                                                child: Divider(
                                                  color: AppColors.darkGreyColor,
                                                  height: 0.5,
                                                ),
                                              ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                      Column(
                        children: [
                          Container(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const FindFriendProfile()),
                                ).then((result) {
                                  if (result != null && result[0]) {
                                    currentPage = 1;
                                    BlocProvider.of<FindMumBloc>(context).add(
                                        getConnectedMums(
                                            page: currentPage, limit: limit));
                                  }
                                });
                              },
                              child: Container(
                                // alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.primaryPinkColor,
                                        width: 2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Find A Mum',
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.askInfoStyleTablet
                                        : FTextStyle.askInfoStyle,
                                    textAlign: TextAlign.center,
                                  ).animateOnPageLoad(
                                      animationsMap['imageOnPageLoadAnimation2']!),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Connected Mum',
                        style: (displayType == 'desktop' || displayType == 'tablet')
                            ? FTextStyle.appTitleStyleTablet
                            : FTextStyle.appBarTitleStyle,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.32, // Adjusts the button width dynamically
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MumRequest(),
                                      ),
                                    ).then((result) {
                                      if (result != null && result[0]) {
                                        currentPage = 1;
                                        BlocProvider.of<FindMumBloc>(context).add(
                                            getConnectedMums(
                                                page: currentPage, limit: limit));
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.blueGridTextColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Text(
                                        'Requests',
                                        style: (displayType == 'desktop' ||
                                            displayType == 'tablet')
                                            ? FTextStyle.askInfoStyleTablet1
                                            : FTextStyle.askInfoStyle1,
                                        textAlign: TextAlign.center,
                                      ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                SizedBox(height: 8),
                BlocListener<FindMumBloc, FindMumState>(
                    listener: (context, state) {
                      if (state is getConnectedMumsLoading) {
                        setState(() {
                          _isLoading = true;
                          _isLoading1 = true;
                        });
                      } else if (state is getConnectedMumsLoaded) {
                        setState(() {
                          isLoadingMore = false;
                          totalPages = state.totalPages;
                          if (currentPage == 1) {
                            result.clear();
                          }
                          result.addAll(state.docs);
                          _isLoading = false;
                          _isLoading1 = false;
                        });
                        print(result);
                      } else if (state is getConnectedMumsError) {
                        setState(() {
                          _isLoading = false;
                          _isLoading1 = false;
                        });
                      }
                    },
                    child: Expanded(
                      child:
                      (displayType == 'desktop' ||
                          displayType == 'tablet')
                          ? GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: result.length +
                            (isLoadingMore ? 1 : 0),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == result.length &&
                              isLoadingMore) {
                            return Center(child: SizedBox());
                          }
                          final mum1 = result[index];
                          final connectedStatus =
                          mum1['connected'].toString() ==
                              'true'
                              ? 'connected'
                              : 'pending';

                          // Check if index is within bounds for findMumData
                          final kidsDetails = index <
                              findMumData.length
                              ? findMumData[index]['kidsDetails']
                              : 'No Details';

                          return result.isEmpty ? Image.asset('assets/Images/nodata.jpg') : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            child: Card(
                              margin: const EdgeInsets.only(
                                  bottom: 10),
                              elevation: 0.5,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MumDetails(
                                              mumData:
                                              mum1 ?? {}),
                                    ),
                                  ).then((result) {
                                    if (result != null &&
                                        result[0]) {
                                      currentPage = 1;
                                      BlocProvider.of<
                                          FindMumBloc>(
                                          context)
                                          .add(getConnectedMums(
                                          page: currentPage,
                                          limit: limit));
                                    }
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: const Offset(
                                                0, 1.5),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  top: 10),
                                              child: Container(
                                                height: 55.w,
                                                width: 55.w,
                                                decoration:
                                                BoxDecoration(
                                                  border:
                                                  Border.all(
                                                    color: AppColors
                                                        .filterBackroundColor,
                                                    width: 3,
                                                  ),
                                                  shape: BoxShape
                                                      .circle,
                                                ),
                                                child: Container(
                                                  clipBehavior: Clip
                                                      .antiAlias,
                                                  decoration:
                                                  const BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                  ),
                                                  child: mum1['profilePicture']
                                                      .isEmpty
                                                      ? Image
                                                      .asset(
                                                    'assets/Images/defaultUser.png',
                                                    fit: BoxFit
                                                        .fill,
                                                  )
                                                      : Image
                                                      .network(
                                                    mum1[
                                                    'profilePicture'],
                                                    fit: BoxFit
                                                        .cover,
                                                  ).animateOnPageLoad(
                                                    animationsMap[
                                                    'imageOnPageLoadAnimation2']!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(15.0),
                                              child: Align(
                                                alignment:
                                                Alignment
                                                    .topLeft,
                                                child: Text(
                                                  truncateText(
                                                      mum1['fullName'] ??
                                                          'No Name',
                                                      20),
                                                  style: (displayType ==
                                                      'desktop' ||
                                                      displayType ==
                                                          'tablet')
                                                      ? FTextStyle
                                                      .tabToStart2TextStyleTablet
                                                      : FTextStyle
                                                      .tabToStart2TextStyle,
                                                ).animateOnPageLoad(
                                                  animationsMap[
                                                  'imageOnPageLoadAnimation2']!,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                      15.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            mum1['stage'] ??
                                                                'No Stage',
                                                            style: (displayType == 'desktop' || displayType == 'tablet')
                                                                ? FTextStyle.findMum2StyleTablet
                                                                : FTextStyle.findMum2Style,
                                                          ).animateOnPageLoad(
                                                            animationsMap[
                                                            'imageOnPageLoadAnimation2']!,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            top:
                                                            7),
                                                        child:
                                                        Row(
                                                          children: [
                                                            Text(
                                                              kidsDetails,
                                                              style: (displayType == 'desktop' || displayType == 'tablet')
                                                                  ? FTextStyle.findMum2StyleTablet
                                                                  : FTextStyle.findMum2Style,
                                                            ).animateOnPageLoad(
                                                              animationsMap['imageOnPageLoadAnimation2']!,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            top:
                                                            7,
                                                            bottom:
                                                            10),
                                                        child:
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Status: ',
                                                                style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style),
                                                            const SizedBox(
                                                                width: 5),
                                                            Container(
                                                              constraints:
                                                              BoxConstraints(
                                                                maxWidth: MediaQuery.of(context).size.width * 0.2,
                                                              ),
                                                              height:
                                                              50,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: mum1['connected'].toString() == 'pending' ? AppColors.blueGridTextColor : AppColors.primaryColorPink,
                                                                border: Border.all(
                                                                  width: 1.0,
                                                                  color: mum1['connected'].toString() == 'pending' ? AppColors.blueGridTextColor : AppColors.primaryColorPink,
                                                                ),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child:
                                                              Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    connectedStatus,
                                                                    style: FTextStyle.newMum,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      InkWell(
                                                        onTap:
                                                            () {
                                                          Navigator
                                                              .push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MumDetails(
                                                                    mumData: mum1 ?? {},
                                                                  ),
                                                            ),
                                                          ).then(
                                                                  (result) {
                                                                if (result != null &&
                                                                    result[0]) {
                                                                  currentPage =
                                                                  1;
                                                                  BlocProvider.of<FindMumBloc>(context).add(getConnectedMums(
                                                                      page: currentPage,
                                                                      limit: limit));
                                                                }
                                                              });
                                                        },
                                                        child:
                                                        Image(
                                                          image: const AssetImage(
                                                              'assets/Images/nextIcon.png'),
                                                          height: (displayType == 'desktop' ||
                                                              displayType == 'tablet')
                                                              ? 50
                                                              : 42,
                                                          width: (displayType == 'desktop' ||
                                                              displayType == 'tablet')
                                                              ? 50
                                                              : 42,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height:
                                                          5),
                                                      if (connectedStatus ==
                                                          'connected')
                                                        InkWell(
                                                          onTap:
                                                              () {
                                                            Navigator
                                                                .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ChatScreen(
                                                                  name: mum1['fullName'],
                                                                  image: mum1['profilePicture'],
                                                                  userId: PrefUtils.getUserId(),
                                                                  receiverId: mum1['_id'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                          Stack(
                                                            clipBehavior:
                                                            Clip.none,
                                                            children: [
                                                              Image(
                                                                image: const AssetImage('assets/Images/chat-bubble.png'),
                                                                height: (displayType == 'desktop' || displayType == 'tablet') ? 47 : 30,
                                                                width: (displayType == 'desktop' || displayType == 'tablet') ? 47 : 30,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ).animateOnPageLoad(
                                                  animationsMap[
                                                  'imageOnPageLoadAnimation2']!,
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
                            ),
                          );
                        },
                      )
                          : SizedBox(
                        height:
                        MediaQuery.of(context).size.height *
                            0.75, // Adjust height as needed
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: result.length + 1,
                            itemBuilder: (context, index) {
                              if (index == result.length) {
                                return Center(child: SizedBox());
                              }
                              final mum1 = result[index];
                              final connectedStatus =
                              mum1['connected'].toString() ==
                                  'true'
                                  ? 'connected'
                                  : 'pending';
                              return   (currentPage == 1 && _isLoading)
                                  ? SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.pink),
                                ),
                              ) : result.isNotEmpty
                                  ? Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 5.0),
                                child: Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.only(
                                          bottom: 10),
                                      elevation: 0.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MumDetails(
                                                      mumData:
                                                      mum1 ?? {}),
                                            ),
                                          ).then((result) {
                                            if (result != null &&
                                                result[0]) {
                                              currentPage = 1;
                                              BlocProvider.of<
                                                  FindMumBloc>(
                                                  context)
                                                  .add(getConnectedMums(
                                                  page:
                                                  currentPage,
                                                  limit: limit));
                                            }
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration:
                                              BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(
                                                        0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset:
                                                    const Offset(
                                                        0, 1.5),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .all(10.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                vertical:
                                                                40),
                                                            child:
                                                            Container(
                                                              height:
                                                              72,
                                                              width:
                                                              72,
                                                              decoration:
                                                              BoxDecoration(
                                                                border:
                                                                Border.all(
                                                                  color:
                                                                  AppColors.filterBackroundColor,
                                                                  width:
                                                                  3,
                                                                ),
                                                                shape:
                                                                BoxShape.circle,
                                                              ),
                                                              child:
                                                              ClipOval(
                                                                child: mum1['profilePicture'].isEmpty
                                                                    ? Image.asset(
                                                                  'assets/Images/defaultUser.png',
                                                                  fit: BoxFit.fill,
                                                                )
                                                                    : Image.network(
                                                                  mum1['profilePicture'],
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                top:
                                                                20,
                                                                left:
                                                                14),
                                                            child:
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  truncateText(mum1['fullName'] ?? 'No Name',
                                                                      20),
                                                                  style:
                                                                  FTextStyle.tabToStart2TextStyle,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(top: 8),
                                                                  child:
                                                                  Text(
                                                                    mum1['stage'] ?? 'No Stage',
                                                                    style: FTextStyle.findMum2Style,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(top: 8),
                                                                  child:
                                                                  Text(
                                                                    mum1['kids'].isNotEmpty ? 'Have ${mum1['kids']} Kids' : 'Have no kids',
                                                                    style: FTextStyle.findMum2Style,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(top: 8, bottom: 10),
                                                                  child:
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Status: ',
                                                                        style: FTextStyle.findMum2Style,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Container(
                                                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.21),
                                                                        // Set max width dynamically
                                                                        height: 30,
                                                                        // Fixed height
                                                                        decoration: BoxDecoration(
                                                                          color: mum1['connected'].toString() == 'pending' ? AppColors.blueGridTextColor : AppColors.primaryColorPink,
                                                                          border: Border.all(
                                                                            width: 1.0,
                                                                            color: mum1['connected'].toString() == 'pending' ? AppColors.blueGridTextColor : AppColors.primaryColorPink,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(4.0),
                                                                          child: Center(
                                                                            child: Text(connectedStatus, style: FTextStyle.newMum // Change text color for 'Connect'
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.end,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.symmetric(vertical: 30),
                                                                  child:
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => MumDetails(mumData: mum1 ?? {}),
                                                                        ),
                                                                      ).then((result) {
                                                                        if (result != null && result[0]) {
                                                                          currentPage = 1;
                                                                          BlocProvider.of<FindMumBloc>(context).add(getConnectedMums(page: currentPage, limit: limit));
                                                                        }
                                                                      });
                                                                    },
                                                                    child: const Image(
                                                                      image: AssetImage('assets/Images/nextIcon.png'),
                                                                      height: 42,
                                                                      width: 42,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 4),
                                                                if (connectedStatus ==
                                                                    'connected') // Check status here
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => ChatScreen(
                                                                            name: mum1['fullName'],
                                                                            image: mum1['profilePicture'],
                                                                            userId: PrefUtils.getUserId(),
                                                                            receiverId: mum1['_id'],
                                                                          ),
                                                                        ),
                                                                      );
                                                                      print(PrefUtils.getUserId());
                                                                      print(mum1['_id']);
                                                                    },
                                                                    child: Stack(
                                                                      clipBehavior: Clip.none, // Allows the badge to be partially outside the Stack
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 8),
                                                                          child: Image(image: const AssetImage('assets/Images/chat-bubble.png'), height: (displayType == 'desktop' || displayType == 'tablet') ? 40 : 25, width: (displayType == 'desktop' || displayType == 'tablet') ? 40 : 25),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ).animateOnPageLoad(
                                                              animationsMap[
                                                              'imageOnPageLoadAnimation2']!)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Center(child:Image.asset('assets/Images/nodata.jpg'));

                            }),
                      ),
                    )),
                if(currentPage != 1 && _isLoading)
                  Center(
                    child: CircularProgressIndicator(color: AppColors.pink),
                  ),
              ],
            )),
      ),
    );
  }
}

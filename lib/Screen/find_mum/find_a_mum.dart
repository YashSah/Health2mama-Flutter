import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find_mum/mum_details_screen.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/StageConverter.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';

import '../../Utils/pref_utils.dart';

class FindMum extends StatefulWidget {
  final List<String> Other;
  final List<String> Interest;
  final List<String> Exercise;
  final List<String> Language;
  String areYou;
  String Age;

  FindMum(
      {Key? key,
      required this.Other,
      required this.Interest,
      required this.Exercise,
      required this.Language,
      required this.areYou,
      required this.Age})
      : super(key: key);

  @override
  State<FindMum> createState() => _FindMumState();
}

class _FindMumState extends State<FindMum> {
  int currentPage = 1;
  int limit = 12;
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  List<Map<String, dynamic>> result = [];
  final _scrollController = ScrollController();
  int totalPages = 0;

  @override
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
    BlocProvider.of<FindMumBloc>(context).add(FindAFriend(
      Other: widget.Interest,
      Interest: widget.Other,
      Exercise: widget.Exercise,
      Language: widget.Language,
      Age: widget.Age,
      areYou: widget.areYou,
      page: currentPage,
      limit: limit,
    ));
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
      _loadContent();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool serviceVisible = false;
  bool isButtonEnabled1 = false;
  String servicesStage = "";
  bool isDropdownVisible1 = false;
  bool isDropdownVisible2 = false;
  bool isDropdownVisible3 = false;
  bool isDropdownVisible4 = false;
  String yourStage1 = "";
  String yourStage2 = "";
  String yourStage3 = "";
  String yourStage4 = "";
  bool isButtonEnabled2 = false; // Track button enabled state
  bool isButtonEnabled3 = false; // Track button enabled state
  bool isButtonEnabled4 = false; // Track button enabled state

  List<Map<String, dynamic>> serviceStages = [
    {"title": "2 km", "value": "2 km", "selected": false},
    {"title": "4 km ", "value": "4 km ", "selected": false},
    {"title": "6 km", "value": "6 km", "selected": false},
    {"title": "8 km", "value": "8 km", "selected": false},
  ];

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Find A Mum",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.appTitleStyleTablet
                    : FTextStyle.appBarTitleStyle)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, [true]);
            Navigator.pop(context, [true]);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (displayType == 'desktop' || displayType == 'tablet')
                  ? 4.w
                  : screenWidth * 0.03,
              vertical: (displayType == 'desktop' || displayType == 'tablet')
                  ? 2.w
                  : screenWidth * 0.01,
            ),
            child: Image.asset(
              'assets/Images/back.png', // Replace with your image path
              width: (displayType == 'desktop' || displayType == 'tablet')
                  ? 35.w
                  : 35, // Set width as needed
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 35.h
                  : 35, // Set height as needed
            ),
          ),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Column(
          children: [
            Container(
              height: 1,
              color: AppColors.findMumBorderColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                              Icons.arrow_drop_down,
                              // or Icons.arrow_drop_up based on your condition
                              color: AppColors.pinkButton,
                              size: 30,
                            ),
                            hintText: "Select range",
                            // Set an empty hintText initially
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
                          readOnly: true,
                          // Making it read-only to show the selected value
                          controller:
                              TextEditingController(text: servicesStage),
                          // Setting initial value
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

                                        setState(() {
                                          serviceVisible = !serviceVisible;
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
                                            FindAFriend(
                                              Other: widget.Interest,
                                              Interest: widget.Other,
                                              Exercise: widget.Exercise,
                                              Language: widget.Language,
                                              Age: widget.Age,
                                              areYou: widget.areYou,
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
                                                width: 24,
                                                // Adjust the width as needed
                                                height: 24,
                                                // Adjust the height as needed
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  // Adjust the radius as needed
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
                                                        size: 30,
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
                ],
              ),
            ),
            BlocListener<FindMumBloc, FindMumState>(
                listener: (context, state) {
                  if (state is findAFriendLoading) {
                    setState(() {
                      _isLoading = true;
                      _isLoading1 = true;
                    });
                  } else if (state is findAFriendLoaded) {
                    setState(() {
                      if (currentPage == 1) {
                        result.clear();
                      }
                      isLoadingMore = false;
                      totalPages = state.totalPages;
                      result.addAll(state.docs);
                      _isLoading = false;
                      _isLoading1 = false;
                    });
                  }
                },
                child: _isLoading1
                    ? Center(child: CircularProgressIndicator(color: AppColors.pink))
                    : result.isEmpty
                        ? Center(child: Image.asset('assets/Images/nodata.jpg'))
                        : Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child:
                                  (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                      ? GridView.builder(
                                          controller: _scrollController,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 10,
                                          ),
                                          itemCount: result.length +
                                              (isLoadingMore ? 1 : 0),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            if (index == result.length &&
                                                isLoadingMore) {
                                              return Center(child: SizedBox());
                                            }
                                            final mum1 = result[index];
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 5.0),
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FindMumDetails(
                                                            other: mum1[
                                                                'otherWork'],
                                                            interest:
                                                                mum1['others'],
                                                            exercise: mum1[
                                                                'exercise'],
                                                            language: mum1[
                                                                'languages'],
                                                            areYou:
                                                                mum1['stage'],
                                                            ProfilePic: mum1[
                                                                'profilePicture'],
                                                            name: mum1[
                                                                'fullName'],
                                                            stage: StageConverter
                                                                .formatStage(mum1[
                                                                    'stage']),
                                                            kids: mum1['kids'],
                                                            id: mum1['_id'],
                                                          ),
                                                        ),
                                                      ).then((result) {
                                                        if (result != null &&
                                                            result[0]) {
                                                          currentPage = 1;
                                                          BlocProvider.of<
                                                                      FindMumBloc>(
                                                                  context)
                                                              .add(FindAFriend(
                                                            Other:
                                                                widget.Interest,
                                                            Interest:
                                                                widget.Other,
                                                            Exercise:
                                                                widget.Exercise,
                                                            Language:
                                                                widget.Language,
                                                            Age: widget.Age,
                                                            areYou:
                                                                widget.areYou,
                                                            page: currentPage,
                                                            limit: limit,
                                                          ));
                                                        }
                                                      });
                                                    },
                                                    child: Card(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10),
                                                        elevation: 0.5,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 3,
                                                                  offset:
                                                                      const Offset(
                                                                          0,
                                                                          1.5),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      15.0),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        55.w,
                                                                    width: 55.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle),
                                                                    child:
                                                                        Container(
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
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
                                                                              fit: BoxFit.fill,
                                                                            )
                                                                          : Image
                                                                              .network(
                                                                              mum1['profilePicture'],
                                                                              errorBuilder: (context, error, stackTrace) {
                                                                                print('Image load error: $error');
                                                                                return Center(child: Icon(Icons.error, color: Colors.red));
                                                                              },
                                                                            ),
                                                                    ).animateOnPageLoad(
                                                                            animationsMap['imageOnPageLoadAnimation2']!),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 8.0),
                                                                            child:
                                                                                Text(
                                                                              truncateText(mum1['fullName'] ?? 'No Name', 20),
                                                                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.tabToStart2TextStyleTablet : FTextStyle.tabToStart2TextStyle,
                                                                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 8),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(StageConverter.formatStage(mum1['stage'] ?? 'No Stage'), style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 7),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(mum1['kids'].isNotEmpty ? 'Have ${mum1['kids']} Kids' : 'Have no kids', style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            15.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => FindMumDetails(
                                                                                        other: mum1['otherWork'],
                                                                                        interest: mum1['others'],
                                                                                        exercise: mum1['exercise'],
                                                                                        language: mum1['languages'],
                                                                                        areYou: mum1['stage'],
                                                                                        id: mum1['_id'],
                                                                                        ProfilePic: mum1['profilePicture'],
                                                                                        name: mum1['fullName'],
                                                                                        stage: StageConverter.formatStage(mum1['stage']),
                                                                                        kids: mum1['kids'],
                                                                                      )),
                                                                            ).then((result) {
                                                                              if (result != null && result[0]) {
                                                                                currentPage = 1;
                                                                                BlocProvider.of<FindMumBloc>(context).add(FindAFriend(
                                                                                  Other: widget.Interest,
                                                                                  Interest: widget.Other,
                                                                                  Exercise: widget.Exercise,
                                                                                  Language: widget.Language,
                                                                                  Age: widget.Age,
                                                                                  areYou: widget.areYou,
                                                                                  page: currentPage,
                                                                                  limit: limit,
                                                                                ));
                                                                              }
                                                                            });
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            minimumSize:
                                                                                Size(100.w, 40.h),
                                                                            backgroundColor:
                                                                                AppColors.pink,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "Connect",
                                                                            style:
                                                                                FTextStyle.buttonSizeTablet,
                                                                          ),
                                                                        ).animateOnPageLoad(
                                                                            animationsMap['imageOnPageLoadAnimation2']!),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 8.0),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => FindMumDetails(
                                                                                          other: mum1['otherWork'],
                                                                                          id: mum1['_id'],
                                                                                          interest: mum1['others'],
                                                                                          exercise: mum1['exercise'],
                                                                                          language: mum1['languages'],
                                                                                          areYou: mum1['stage'],
                                                                                          ProfilePic: mum1['profilePicture'],
                                                                                          name: mum1['fullName'],
                                                                                          stage: StageConverter.formatStage(mum1['stage']),
                                                                                          kids: mum1['kids'],
                                                                                        )),
                                                                              ).then((result) {
                                                                                if (result != null && result[0]) {
                                                                                  currentPage = 1;
                                                                                  BlocProvider.of<FindMumBloc>(context).add(FindAFriend(
                                                                                    Other: widget.Interest,
                                                                                    Interest: widget.Other,
                                                                                    Exercise: widget.Exercise,
                                                                                    Language: widget.Language,
                                                                                    Age: widget.Age,
                                                                                    areYou: widget.areYou,
                                                                                    page: currentPage,
                                                                                    limit: limit,
                                                                                  ));
                                                                                }
                                                                              });
                                                                            },
                                                                            child:
                                                                                const Image(
                                                                              image: AssetImage('assets/Images/IconNext.png'),
                                                                              height: 45,
                                                                              width: 45,
                                                                            ),
                                                                          ),
                                                                        ).animateOnPageLoad(
                                                                            animationsMap['imageOnPageLoadAnimation2']!),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )))));
                                          },
                                        )
                                      : ListView.builder(
                                          controller: _scrollController,
                                          itemCount: result.length + 1,
                                          itemBuilder: (context, index) {
                                            if (index == result.length) {
                                              return Center(child: SizedBox());
                                            }
                                            final mum1 = result[index];
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 5.0),
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FindMumDetails(
                                                                  other: mum1[
                                                                      'otherWork'],
                                                                  interest: mum1[
                                                                      'others'],
                                                                  exercise: mum1[
                                                                      'exercise'],
                                                                  id: mum1[
                                                                      '_id'],
                                                                  language: mum1[
                                                                      'languages'],
                                                                  areYou: mum1[
                                                                      'stage'],
                                                                  ProfilePic: mum1[
                                                                      'profilePicture'],
                                                                  name: mum1[
                                                                      'fullName'],
                                                                  stage: StageConverter
                                                                      .formatStage(
                                                                          mum1[
                                                                              'stage']),
                                                                  kids: mum1[
                                                                      'kids'],
                                                                )),
                                                      ).then((result) {
                                                        if (result != null &&
                                                            result[0]) {
                                                          currentPage = 1;
                                                          BlocProvider.of<
                                                                      FindMumBloc>(
                                                                  context)
                                                              .add(FindAFriend(
                                                            Other:
                                                                widget.Interest,
                                                            Interest:
                                                                widget.Other,
                                                            Exercise:
                                                                widget.Exercise,
                                                            Language:
                                                                widget.Language,
                                                            Age: widget.Age,
                                                            areYou:
                                                                widget.areYou,
                                                            page: currentPage,
                                                            limit: limit,
                                                          ));
                                                        }
                                                      });
                                                    },
                                                    child: Card(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10),
                                                        elevation: 0.5,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 3,
                                                                  offset:
                                                                      const Offset(
                                                                          0,
                                                                          1.5),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10),
                                                                                  child: Container(
                                                                                    height: 72,
                                                                                    width: 72,
                                                                                    decoration: BoxDecoration(shape: BoxShape.circle),
                                                                                    child: Container(
                                                                                      clipBehavior: Clip.antiAlias,
                                                                                      decoration: const BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                      ),
                                                                                      child: mum1['profilePicture'].isEmpty
                                                                                          ? Image.asset(
                                                                                              'assets/Images/defaultUser.png',
                                                                                              fit: BoxFit.fill,
                                                                                            )
                                                                                          : Image.network(
                                                                                              mum1['profilePicture'],
                                                                                              errorBuilder: (context, error, stackTrace) {
                                                                                                print('Image load error: $error');
                                                                                                return Center(child: Icon(Icons.error, color: Colors.red));
                                                                                              },
                                                                                            ),
                                                                                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 10, left: 15),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(truncateText(mum1['fullName'] ?? 'No Name', 20), style: FTextStyle.MumsTitle).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                        ],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(top: 7),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              mum1['stage'] ?? 'NO Stage',
                                                                                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.tabToStart2TextStyleTablet : FTextStyle.tabToStart2TextStyle,
                                                                                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(top: 7),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              mum1['kids'].isNotEmpty ? 'Have ${mum1['kids']} Kids' : 'Have no kids',
                                                                                              style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.tabToStart2TextStyleTablet : FTextStyle.tabToStart2TextStyle,
                                                                                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => FindMumDetails(
                                                                                                  other: mum1['otherWork'],
                                                                                                  interest: mum1['others'],
                                                                                                  exercise: mum1['exercise'],
                                                                                                  language: mum1['languages'],
                                                                                                  areYou: mum1['stage'],
                                                                                                  ProfilePic: mum1['profilePicture'],
                                                                                                  name: mum1['fullName'],
                                                                                                  stage: StageConverter.formatStage(mum1['stage']),
                                                                                                  kids: mum1['kids'],
                                                                                                  id: mum1['_id'],
                                                                                                )),
                                                                                      ).then((result) {
                                                                                        if (result != null && result[0]) {
                                                                                          currentPage = 1;
                                                                                          BlocProvider.of<FindMumBloc>(context).add(FindAFriend(
                                                                                            Other: widget.Interest,
                                                                                            Interest: widget.Other,
                                                                                            Exercise: widget.Exercise,
                                                                                            Language: widget.Language,
                                                                                            Age: widget.Age,
                                                                                            areYou: widget.areYou,
                                                                                            page: currentPage,
                                                                                            limit: limit,
                                                                                          ));
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      minimumSize: Size(screenWidth * 0.66, screenHeight * 0.04),
                                                                                      backgroundColor: AppColors.pink,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                                      ),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.014),
                                                                                      child: Text(
                                                                                        "Connect",
                                                                                        style: FTextStyle.ForumsButtonStyling,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => FindMumDetails(
                                                                                                other: mum1['otherWork'],
                                                                                                interest: mum1['others'],
                                                                                                id: mum1['_id'],
                                                                                                exercise: mum1['exercise'],
                                                                                                language: mum1['languages'],
                                                                                                areYou: mum1['stage'],
                                                                                                ProfilePic: mum1['profilePicture'],
                                                                                                name: mum1['fullName'],
                                                                                                stage: StageConverter.formatStage(mum1['stage']),
                                                                                                kids: mum1['kids'],
                                                                                              )),
                                                                                    ).then((result) {
                                                                                      if (result != null && result[0]) {
                                                                                        currentPage = 1;
                                                                                        BlocProvider.of<FindMumBloc>(context).add(FindAFriend(
                                                                                          Other: widget.Interest,
                                                                                          Interest: widget.Other,
                                                                                          Exercise: widget.Exercise,
                                                                                          Language: widget.Language,
                                                                                          Age: widget.Age,
                                                                                          areYou: widget.areYou,
                                                                                          page: currentPage,
                                                                                          limit: limit,
                                                                                        ));
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: const Image(
                                                                                    image: AssetImage('assets/Images/IconNext.png'),
                                                                                    height: 45,
                                                                                    width: 45,
                                                                                  ),
                                                                                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ]))))));
                                          },
                                        ),
                            ),
                          ))
          ],
        ),
      ),
    );
  }
}

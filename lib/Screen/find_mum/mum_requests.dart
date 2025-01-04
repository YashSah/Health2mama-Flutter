import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/find_mum/mum_request_details.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/StageConverter.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/find_mum/find_mum_bloc.dart';

class MumRequest extends StatefulWidget {
  const MumRequest({super.key});

  @override
  State<MumRequest> createState() => _MumRequestState();
}

class _MumRequestState extends State<MumRequest> {
  bool serviceVisible = false;
  bool isButtonEnabled1 = false;
  bool _isLoading = false;
  bool _isLoading1 = false;
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
  int currentPage = 1;
  int limit = 10;
  bool hasMoreData = true;
  List<dynamic> result = [];
  final _scrollController = ScrollController();
  int totalPages = 0;

  void initState() {
    BlocProvider.of<FindMumBloc>(context)
        .add(FetchPendingRequests(page: currentPage, limit: limit));
    _loadMoreFriends();
    super.initState();
  }

  void _loadMoreFriends() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage < totalPages && !_isLoading) {
          currentPage++;
          BlocProvider.of<FindMumBloc>(context)
              .add(FetchPendingRequests(page: currentPage, limit: limit));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
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
            child: Text("Mum Requests",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.appTitleStyleTablet
                    : FTextStyle.appBarTitleStyle)),
        leading: GestureDetector(
          onTap: () {
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
      body: BlocListener<FindMumBloc, FindMumState>(
        listener: (context, state) {
          if (state is FetchPendingRequestsLoading) {
            setState(() {
              _isLoading = true;
              _isLoading1 = true;
            });
          } else if (state is FetchPendingRequestsLoaded) {
            setState(() {
              totalPages = state.totalPages;
              if (currentPage == 1) {
                result.clear();
              }
              result.addAll(state.requests);

              if (currentPage >= totalPages) {
                hasMoreData = false;
              }

              _isLoading = false;
              _isLoading1 = false;
            });
          } else if (state is FetchPendingRequestsError) {
            setState(() {
              _isLoading = false;
              _isLoading1 = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: Column(
            children: [
              Container(
                height: 1,
                color: AppColors.findMumBorderColor,
              ),
              Expanded(
                child: _isLoading1
                    ? Center(child: CircularProgressIndicator(color: AppColors.pink))
                    : result.isEmpty
                        ? Center(child: Image.asset('assets/Images/nodata.jpg'))
                        : Container(
                            padding: const EdgeInsets.all(12),
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
                                        itemCount: result.length + 1,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          if (index == result.length) {
                                            return Center(child: SizedBox());
                                          }
                                          final mumRequest = result[index];
                                          final sender =
                                              mumRequest['sender'] ?? {};
                                          final profilePictureUrl =
                                              sender['profilePicture']
                                                      as String? ??
                                                  '';
                                          final hasProfilePicture =
                                              profilePictureUrl.isNotEmpty;
                                          final fullName =
                                              sender['fullName'] as String? ??
                                                  'No Name';
                                          final kids =
                                              sender['kids'] as String?;
                                          final kidsText =
                                              (kids != null && kids.isNotEmpty)
                                                  ? 'Have $kids Kids'
                                                  : 'Have no kids';

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
                                                                MumRequestDetails(
                                                                  other: sender[
                                                                              'otherWork']
                                                                          as List<
                                                                              dynamic>? ??
                                                                      [],
                                                                  interest: sender[
                                                                              'others']
                                                                          as List<
                                                                              dynamic>? ??
                                                                      [],
                                                                  exercise: sender[
                                                                              'exercise']
                                                                          as List<
                                                                              dynamic>? ??
                                                                      [],
                                                                  id: mumRequest[
                                                                              '_id']
                                                                          as String? ??
                                                                      '',
                                                                  language: sender[
                                                                              'languages']
                                                                          as List<
                                                                              dynamic>? ??
                                                                      [],
                                                                  areYou: sender[
                                                                              'stage']
                                                                          as String? ??
                                                                      '',
                                                                  ProfilePic:
                                                                      sender['profilePicture']
                                                                              as String? ??
                                                                          '',
                                                                  name: sender[
                                                                              'fullName']
                                                                          as String? ??
                                                                      '',
                                                                  stage: StageConverter
                                                                      .formatStage(
                                                                          sender['stage'] as String? ??
                                                                              ''),
                                                                  kids: sender[
                                                                              'kids']
                                                                          as String? ??
                                                                      '',
                                                                ))).then(
                                                        (result) {
                                                      if (result != null &&
                                                          result[0]) {
                                                        currentPage = 1;
                                                        BlocProvider.of<
                                                                    FindMumBloc>(
                                                                context)
                                                            .add(FetchPendingRequests(
                                                                page:
                                                                    currentPage,
                                                                limit: limit));
                                                      }
                                                    });
                                                  },
                                                  child: Card(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
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
                                                            color: Colors.white,
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
                                                                    .all(15.0),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                    height:
                                                                        55.w,
                                                                    width: 55.w,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child:
                                                                        Container(
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          ClipOval(
                                                                        child: hasProfilePicture
                                                                            ? Image.network(
                                                                                profilePictureUrl,
                                                                                fit: BoxFit.cover,
                                                                                errorBuilder: (context, error, stackTrace) {
                                                                                  print('Image load error: $error');
                                                                                  return Center(
                                                                                    child: Icon(Icons.error, color: Colors.red),
                                                                                  );
                                                                                },
                                                                              )
                                                                            : Image.asset(
                                                                                'assets/Images/defaultUser.png',
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['imageOnPageLoadAnimation2']!),
                                                                    )),
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 8.0),
                                                                          child:
                                                                              Text(
                                                                            truncateText(fullName,
                                                                                20),
                                                                            style: (displayType == 'desktop' || displayType == 'tablet')
                                                                                ? FTextStyle.tabToStart2TextStyleTablet
                                                                                : FTextStyle.tabToStart2TextStyle,
                                                                          ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(StageConverter.formatStage(sender['stage'] ?? 'No Stage'), style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style)
                                                                              .animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 7),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(kidsText, style: (displayType == 'desktop' || displayType == 'tablet') ? FTextStyle.findMum2StyleTablet : FTextStyle.findMum2Style)
                                                                              .animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
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
                                                                                  builder: (context) => MumRequestDetails(
                                                                                        other: sender['otherWork'] as List<dynamic>? ?? [],
                                                                                        interest: sender['others'] as List<dynamic>? ?? [],
                                                                                        exercise: sender['exercise'] as List<dynamic>? ?? [],
                                                                                        id: mumRequest['_id'] as String? ?? '',
                                                                                        language: sender['languages'] as List<dynamic>? ?? [],
                                                                                        areYou: sender['stage'] as String? ?? '',
                                                                                        ProfilePic: sender['profilePicture'] as String? ?? '',
                                                                                        name: sender['fullName'] as String? ?? '',
                                                                                        stage: StageConverter.formatStage(sender['stage'] as String? ?? ''),
                                                                                        kids: sender['kids'] as String? ?? '',
                                                                                      ))).then((result) {
                                                                            if (result != null &&
                                                                                result[0]) {
                                                                              currentPage = 1;
                                                                              BlocProvider.of<FindMumBloc>(context).add(FetchPendingRequests(page: currentPage, limit: limit));
                                                                            }
                                                                          });
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          minimumSize: Size(
                                                                              100.w,
                                                                              40.h),
                                                                          backgroundColor:
                                                                              AppColors.pink,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Accept",
                                                                          style:
                                                                              FTextStyle.buttonSizeTablet,
                                                                        ),
                                                                      ).animateOnPageLoad(
                                                                          animationsMap[
                                                                              'imageOnPageLoadAnimation2']!),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                8.0),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => MumRequestDetails(
                                                                                          other: sender['otherWork'] as List<dynamic>? ?? [],
                                                                                          interest: sender['others'] as List<dynamic>? ?? [],
                                                                                          exercise: sender['exercise'] as List<dynamic>? ?? [],
                                                                                          id: mumRequest['_id'] as String? ?? '',
                                                                                          language: sender['languages'] as List<dynamic>? ?? [],
                                                                                          areYou: sender['stage'] as String? ?? '',
                                                                                          ProfilePic: sender['profilePicture'] as String? ?? '',
                                                                                          name: sender['fullName'] as String? ?? '',
                                                                                          stage: StageConverter.formatStage(sender['stage'] as String? ?? ''),
                                                                                          kids: sender['kids'] as String? ?? '',
                                                                                        ))).then((result) {
                                                                              if (result != null && result[0]) {
                                                                                currentPage = 1;
                                                                                BlocProvider.of<FindMumBloc>(context).add(FetchPendingRequests(page: currentPage, limit: limit));
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Image(
                                                                            image:
                                                                                AssetImage('assets/Images/IconNext.png'),
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                45,
                                                                          ),
                                                                        ),
                                                                      ).animateOnPageLoad(
                                                                          animationsMap[
                                                                              'imageOnPageLoadAnimation2']!),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )))));
                                        },
                                      )
                                    : ListView.builder(
                                        itemCount: result.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == result.length) {
                                            return Center(child: SizedBox());
                                          }
                                          final mumRequest = result[index];
                                          final sender =
                                              mumRequest['sender'] ?? {};
                                          final profilePictureUrl =
                                              sender['profilePicture']
                                                      as String? ??
                                                  '';
                                          final hasProfilePicture =
                                              profilePictureUrl.isNotEmpty;
                                          final fullName =
                                              sender['fullName'] as String? ??
                                                  'No Name';
                                          final kids =
                                              sender['kids'] as String?;
                                          final kidsText =
                                              (kids != null && kids.isNotEmpty)
                                                  ? 'Have $kids Kids'
                                                  : 'Have no kids';

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
                                                            MumRequestDetails(
                                                          other: sender[
                                                                      'otherWork']
                                                                  as List<
                                                                      dynamic>? ??
                                                              [],
                                                          interest: sender[
                                                                      'others']
                                                                  as List<
                                                                      dynamic>? ??
                                                              [],
                                                          exercise: sender[
                                                                      'exercise']
                                                                  as List<
                                                                      dynamic>? ??
                                                              [],
                                                          id: mumRequest['_id']
                                                                  as String? ??
                                                              '',
                                                          language: sender[
                                                                      'languages']
                                                                  as List<
                                                                      dynamic>? ??
                                                              [],
                                                          areYou: sender[
                                                                      'stage']
                                                                  as String? ??
                                                              '',
                                                          ProfilePic: sender[
                                                                      'profilePicture']
                                                                  as String? ??
                                                              '',
                                                          name: sender[
                                                                      'fullName']
                                                                  as String? ??
                                                              '',
                                                          stage: StageConverter
                                                              .formatStage(sender[
                                                                          'stage']
                                                                      as String? ??
                                                                  ''),
                                                          kids: sender['kids']
                                                                  as String? ??
                                                              '',
                                                        ),
                                                      ),
                                                    ).then((result) {
                                                      if (result != null &&
                                                          result[0]) {
                                                        currentPage = 1;
                                                        BlocProvider.of<
                                                                    FindMumBloc>(
                                                                context)
                                                            .add(FetchPendingRequests(
                                                                page:
                                                                    currentPage,
                                                                limit: limit));
                                                      }
                                                    });
                                                  },
                                                  child: Card(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
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
                                                            color: Colors.white,
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
                                                                      .all(8.0),
                                                              child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 15),
                                                                                child: Container(
                                                                                  height: 72,
                                                                                  width: 72,
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Container(
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: const BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                    ),
                                                                                    child: ClipOval(
                                                                                      child: hasProfilePicture
                                                                                          ? Image.network(
                                                                                              profilePictureUrl,
                                                                                              fit: BoxFit.cover,
                                                                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                                                                return Container(
                                                                                                    child: Image.asset(
                                                                                                  'assets/Images/defaultUser.png',
                                                                                                  fit: BoxFit.fill,
                                                                                                ));
                                                                                              },
                                                                                            )
                                                                                          : Image.asset(
                                                                                              'assets/Images/defaultUser.png',
                                                                                              fit: BoxFit.cover,
                                                                                            ),
                                                                                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 10, left: 15),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          truncateText(fullName, 20),
                                                                                          style: FTextStyle.MumsTitle,
                                                                                        ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                      ],
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(top: 8),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            StageConverter.formatStage(sender['stage'] ?? 'No Stage'),
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
                                                                                            kidsText,
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
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => MumRequestDetails(
                                                                                                  other: sender['otherWork'] as List<dynamic>? ?? [],
                                                                                                  interest: sender['others'] as List<dynamic>? ?? [],
                                                                                                  exercise: sender['exercise'] as List<dynamic>? ?? [],
                                                                                                  id: mumRequest['_id'] as String? ?? '',
                                                                                                  language: sender['languages'] as List<dynamic>? ?? [],
                                                                                                  areYou: sender['stage'] as String? ?? '',
                                                                                                  ProfilePic: sender['profilePicture'] as String? ?? '',
                                                                                                  name: sender['fullName'] as String? ?? '',
                                                                                                  stage: StageConverter.formatStage(sender['stage'] as String? ?? ''),
                                                                                                  kids: sender['kids'] as String? ?? '',
                                                                                                ))).then((result) {
                                                                                      if (result != null && result[0]) {
                                                                                        currentPage = 1;
                                                                                        BlocProvider.of<FindMumBloc>(context).add(FetchPendingRequests(page: currentPage, limit: limit));
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    minimumSize: Size(screenWidth * 0.60, screenHeight * 0.04),
                                                                                    backgroundColor: AppColors.pink,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.014),
                                                                                    child: Text(
                                                                                      "Accept",
                                                                                      style: FTextStyle.ForumsButtonStyling,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => MumRequestDetails(
                                                                                                  other: sender['otherWork'] as List<dynamic>? ?? [],
                                                                                                  interest: sender['others'] as List<dynamic>? ?? [],
                                                                                                  exercise: sender['exercise'] as List<dynamic>? ?? [],
                                                                                                  id: mumRequest['_id'] as String? ?? '',
                                                                                                  language: sender['languages'] as List<dynamic>? ?? [],
                                                                                                  areYou: sender['stage'] as String? ?? '',
                                                                                                  ProfilePic: sender['profilePicture'] as String? ?? '',
                                                                                                  name: sender['fullName'] as String? ?? '',
                                                                                                  stage: StageConverter.formatStage(sender['stage'] as String? ?? ''),
                                                                                                  kids: sender['kids'] as String? ?? '',
                                                                                                ))).then((result) {
                                                                                      if (result != null && result[0]) {
                                                                                        currentPage = 1;
                                                                                        BlocProvider.of<FindMumBloc>(context).add(FetchPendingRequests(page: currentPage, limit: limit));
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: const Image(
                                                                                    image: AssetImage('assets/Images/IconNext.png'),
                                                                                    height: 45,
                                                                                    width: 45,
                                                                                  ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

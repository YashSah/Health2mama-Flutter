import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/forums/forums_topics_details.dart';
import 'package:health2mama/Utils/StageConverter.dart';
import 'package:health2mama/Utils/common_popups.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/forums/forums_bloc.dart';
import 'package:intl/intl.dart';
import '../../Utils/CommonFuction.dart';
import 'forums_topics.dart';

class ForumsTopics extends StatefulWidget {
  const ForumsTopics({Key? key}) : super(key: key);

  @override
  State<ForumsTopics> createState() => _ForumsTopicsState();
}

class _ForumsTopicsState extends State<ForumsTopics> {
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
  void _navigateToForumListing() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ForumsBloc(),
          child: ForumsListing(),
        ),
      ),
    );

    // Check if the result indicates that a forum was added
    if (result != null && result[0] == true) {
      // Fetch forums again to update the list
      BlocProvider.of<ForumsBloc>(context).add(FetchForums());
    }
  }
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  final int _limit = 10;
  List<dynamic> _forums = []; // Store forums in a list

  @override
  void initState() {
    super.initState();
    _fetchForums();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchForums({String? searchQuery}) {
    BlocProvider.of<ForumsBloc>(context).add(
      FetchForums(searchQuery: searchQuery, page: _currentPage, limit: _limit),
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _currentPage = 1;
      _forums.clear(); // Clear previous forums
      _fetchForums(searchQuery: _searchController.text);
    });
  }

  void _loadMore() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      _fetchForums();
    }
  }

  String formatDate(String? createdAt) {
    if (createdAt == null) return 'No Date';
    DateTime parsedDate = DateTime.parse(createdAt);
    return DateFormat('dd MMM yyyy hh:mm a').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    final bool isTabletOrDesktop = displayType == 'desktop' || displayType == 'tablet';

    return Scaffold(
      backgroundColor: AppColors.scaffholdColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Forums",
            style: isTabletOrDesktop ? FTextStyle.appTitleStyleTablet : FTextStyle.appBarTitleStyle,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: isTabletOrDesktop ? 15.h : 15,
              top: isTabletOrDesktop ? 3.h : 3,
            ),
            child: Image.asset(
              'assets/Images/back.png',
              width: isTabletOrDesktop ? 24.w : 24,
              height: isTabletOrDesktop ? 24.h : 24,
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Text(
                  StageConverter.formatStage(PrefUtils.getUserStage()),
                  style: isTabletOrDesktop ? FTextStyle.appTitleStyleTablet : FTextStyle.appBarTitleStyle,
                ),
              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: isTabletOrDesktop ? 50.h : 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.dark1,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search by title',
                                hintStyle: isTabletOrDesktop ? FTextStyle.ForumsHintStyleTablet : FTextStyle.ForumsHintStyle,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    'assets/Images/Search.png',
                                    width: isTabletOrDesktop ? 20.w : 20,
                                    height: isTabletOrDesktop ? 20.w : 20,
                                  ),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        _searchController.clear();
                        _navigateToForumListing();
                      },
                      child: Image.asset(
                        'assets/Images/IconPlus.png',
                        width: isTabletOrDesktop ? 20.w : 30,
                        height: isTabletOrDesktop ? 20.w : 30,
                      ),
                    ),
                  ],
                ),
              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
              BlocConsumer<ForumsBloc, ForumsState>(
                listener: (context, state) {
                  if (state is ForumsError) {
                    CommonPopups.showCustomPopup(context, 'An error occurred.');
                  } else if (state is CommonServerFailure) {
                    Center(
                      child: Image.asset('assets/Images/somethingwentwrong.png'),
                    );
                  } else if (state is CheckNetworkConnection) {
                    CommonPopups.showCustomPopup(context, 'No internet connection.');
                  } else if (state is ForumsLoaded) {
                    if (_currentPage == 1) {
                      _forums = state.docs; // Reset forums on the first page
                    } else {
                      _forums.addAll(state.docs); // Add new forums to the existing list
                    }
                    setState(() {
                      _isLoadingMore = false; // Reset loading more flag
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ForumsLoading && _currentPage == 1) {
                    return Center(child: CircularProgressIndicator(color: AppColors.pink));
                  } else if (_forums.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No forum found.',
                          style: isTabletOrDesktop ? FTextStyle.dateTimeTablet : FTextStyle.dateTime,
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoadingMore) {
                          _loadMore();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: _forums.length + (_isLoadingMore ? 1 : 0), // Add loading indicator if loading more
                        itemBuilder: (context, index) {
                          if (index == _forums.length) {
                            return Center(child: CircularProgressIndicator(color: AppColors.pink));
                          }

                          final forum = _forums[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 10),
                            elevation: 0.2,
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              title: Text(
                                forum['topicTitle'] ?? 'No Title',
                                style: isTabletOrDesktop ? FTextStyle.forumTopicsTitleTablet : FTextStyle.forumTopicsTitle,
                              ).animateOnPageLoad(
                                animationsMap['imageOnPageLoadAnimation2']!,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    forum['description'] ?? 'No Description',
                                    style: isTabletOrDesktop
                                        ? FTextStyle.forumTopicsSubTitleTablet
                                        : FTextStyle.forumTopicsSubTitle,
                                  ).animateOnPageLoad(
                                      animationsMap['imageOnPageLoadAnimation2']!),
                                  SizedBox(height: 10),
                                  Text(
                                    formatDate(forum['createdAt']),
                                    style: isTabletOrDesktop
                                        ? FTextStyle.dateTimeTablet
                                        : FTextStyle.dateTime,
                                  ).animateOnPageLoad(
                                      animationsMap['imageOnPageLoadAnimation2']!),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => ForumsBloc(),
                                      child: ForumsDetails(forumId: forum['_id'] ?? ''), // Handle potential null ID
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

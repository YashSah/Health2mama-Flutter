import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/forums/forums_topics.dart';
import 'package:health2mama/Screen/program_flow/topic_description.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/forums/forums_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';
import '../../Utils/pref_utils.dart';

class SubDataScreen extends StatefulWidget {
  final String programId;
  final String programName;

  const SubDataScreen({
    Key? key,
    required this.programId,
    required this.programName,
  }) : super(key: key);

  @override
  State<SubDataScreen> createState() => _SubDataScreenState();
}

class _SubDataScreenState extends State<SubDataScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allTopics = []; // Store all topics
  List<dynamic> _filteredTopics = []; // Store filtered topics

  @override
  void initState() {
    super.initState();
    final programId = widget.programId;
    BlocProvider.of<ProgramflowBloc>(context).add(FetchTopics(programId));
    _searchController.addListener(_filterTopics); // Add listener for search
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTopics = _allTopics.where((topic) {
        final topicName = topic['topicName']?.toLowerCase() ?? '';
        return topicName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (displayType == 'desktop' || displayType == 'tablet')
                      ? 4.w
                      : screenWidth * 0.03,
                  vertical: (displayType == 'desktop' || displayType == 'tablet')
                      ? 2.w
                      : screenWidth * 0.01,
                ),
                child: Container(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context,[true]);
                        },
                        icon: Image.asset(
                          'assets/Images/iconBack.png',
                          width: (displayType == 'desktop' ||
                              displayType == 'tablet')
                              ? 24.w
                              : 35,
                          height: (displayType == 'desktop' ||
                              displayType == 'tablet')
                              ? 24.h
                              : 35,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: (displayType == 'desktop' ||
                              displayType == 'tablet')
                              ? 40.h
                              : screenHeight * 0.060,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(screenHeight * 0.011),
                            color: AppColors.scaffholdColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  child: TextField(
                                    controller: _searchController,
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle.ProgramSearchTextStyleTab
                                        : FTextStyle.ProgramSearchTextStyle,
                                    decoration: InputDecoration(
                                      hintText: 'Search here...',
                                      hintStyle: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? FTextStyle.ProgramSearchHintStyleTab
                                          : FTextStyle.ProgramSearchHintStyle,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _filterTopics,
                                icon: Image.asset(
                                  'assets/Images/Search.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: (displayType == 'desktop' || displayType == 'tablet')
                            ? 18.w
                            : screenHeight * 0.05,
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: AppColors.pink),
                          borderRadius: BorderRadius.circular(screenHeight * 0.010),
                        ),
                        child: Builder(
                          builder: (context) => TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => ForumsBloc(),
                                      child: ForumsListing(),
                                    )),
                              );
                            },
                            child: Text(
                              'Ask ?',
                              style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                                  ? FTextStyle.newProgramAskButtonStyleTablet
                                  : FTextStyle.ProgramAskButtonStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                  thickness: screenHeight * 0.0015,
                  color: const Color(0XFFF6F6F6)),
              Padding(
                padding: EdgeInsets.only(
                  left: (displayType == 'desktop' || displayType == 'tablet')
                      ? 30.h
                      : screenWidth * 0.05,
                  top: (displayType == 'desktop' || displayType == 'tablet')
                      ? 12.h
                      : 12,
                  right: (displayType == 'desktop' || displayType == 'tablet')
                      ? 10.h
                      : screenWidth * 0.1,
                  bottom: (displayType == 'desktop' || displayType == 'tablet')
                      ? 20.h
                      : screenWidth * 0.04,
                ),
                child: Text(
                  widget.programName,
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.programsHeadingStyleTab
                      : FTextStyle.programsHeadingStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (displayType == 'desktop' || displayType == 'tablet')
                      ? 20.h
                      : screenWidth * 0.03,
                  vertical: (displayType == 'desktop' || displayType == 'tablet')
                      ? 10.h
                      : screenHeight * 0.01,
                ),
                child: BlocBuilder<ProgramflowBloc, ProgramflowState>(
                  builder: (context, state) {
                    if (state is TopicLoading) {
                      return Center(child: CircularProgressIndicator(color: AppColors.pink));
                    } else if (state is TopicLoaded) {
                      final topics =
                          state.topicsuccessResponse['result'] as List? ?? [];

                      if (_allTopics.isEmpty) {
                        _allTopics = topics; // Initialize the list
                        _filteredTopics = topics; // Set initial filtered list
                      }

                      return _filteredTopics.isEmpty
                          ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.3,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'No topic found',
                            style: FTextStyle.dateTime,
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount: _filteredTopics.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final topic = _filteredTopics[index];
                          final topicName = topic['topicName'] ?? 'No title';
                          final topicImage = topic['topicThumbnailImage'] ?? '';
                          final topicId = topic['_id'] as String? ?? '';
                          final contentDetails = topic['contentDetails'] ?? '';

                          return GestureDetector(
                            onTap: () async {
                              PrefUtils.setitemId(topicId);
                              print("Selected Topic ID Is : ${PrefUtils.getitemId()}");

                              // Use .then to handle the result after navigation
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => ProgramflowBloc(),
                                    child: TopicDescription(
                                      topicName: topicName,
                                      topicImage: topicImage,
                                      contentDetails: contentDetails,
                                    ),
                                  ),
                                ),
                              ).then((result) {
                                if (result != null && result[0]) {
                                  // Trigger the event to fetch updated topics
                                  BlocProvider.of<ProgramflowBloc>(context).add(FetchTopics(widget.programId));

                                  // Reset the lists
                                  setState(() {
                                    _allTopics = [];
                                    _filteredTopics = [];
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all((displayType == 'desktop' || displayType == 'tablet') ? 5.h : screenHeight * 0.005),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: topicImage.isNotEmpty
                                        ? Image.network(
                                      topicImage,
                                      fit: BoxFit.cover,
                                      height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : screenHeight * 0.06,
                                      width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : screenHeight * 0.07,
                                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                        return Container(
                                          color: Colors.grey,
                                          height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : screenHeight * 0.06,
                                          width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : screenHeight * 0.07,
                                          child: Image.network(
                                              'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png',
                                              fit: BoxFit.cover),
                                        );
                                      },
                                    )
                                        : Container(
                                      color: Colors.grey,
                                      height: (displayType == 'desktop' || displayType == 'tablet') ? 40.h : screenHeight * 0.06,
                                      width: (displayType == 'desktop' || displayType == 'tablet') ? 40.w : screenHeight * 0.07,
                                      child: Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: (displayType == 'desktop' || displayType == 'tablet') ? 20.h : screenWidth * 0.02),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : screenWidth * 0.01),
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: topic['isCompleted'] == true ? AppColors.appBlue1 : AppColors.cardBack,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : screenHeight * 0.021,
                                            horizontal: (displayType == 'desktop' || displayType == 'tablet') ? 10.h : screenWidth * 0.04,
                                          ),
                                          child: Text(
                                            topicName,
                                            style: (displayType == 'desktop' || displayType == 'tablet')
                                                ? FTextStyle.programsListStyleTab
                                                : FTextStyle.programsListStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );


                        },
                      );
                    } else if (state is TopicError) {
                      return Center(
                          child: Column(
                            children: [
                              Center(child: Image.asset('assets/Images/nodata.jpg')),
                              Text(
                                  '${state.topicfailureResponse['responseMessage'] ?? 'Unknown error'}',
                                  style: FTextStyle.dateTime),
                            ],
                          ));
                    } else {
                      return Center(child: Image.asset('assets/Images/nodata.jpg'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

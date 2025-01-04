import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/video_player.dart';
import 'package:html/parser.dart' show parse;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/pregnnacy/pregnnacy_tracker.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/apis/pregnancy/pregnancy_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SearchResult extends StatefulWidget {
  final int weekNumber;
  const SearchResult(
      {super.key,
        required this.weekNumber}); // Include the weekNumber in the constructor.

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final ScrollController _scrollController = ScrollController();
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
  @override
  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }

  String convertHtmlToPlainText(String html) {
    final document = parse(html);
    final String plainText =
        parse(document.body?.text ?? '').documentElement?.text ?? '';
    return plainText;
  }

  String videoKey = '';
  int? expandedIndex;
  int? _expandedIndex;

  @override
  void initState() {
    BlocProvider.of<PregnancyBloc>(context)
        .add(ViewWeekByTrimester(weekNumber: widget.weekNumber.toString()));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Weeks & Trimesters",
                style: (displayType == 'desktop' || displayType == 'tablet')
                    ? FTextStyle.appTitleStyleTablet
                    : FTextStyle.appBarTitleStyle)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Pregnancytracker()));
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
      body: BlocBuilder<PregnancyBloc, PregnancyState>(
        builder: (context, state) {
          if (state is ViewWeekLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ViewWeekLoaded) {
            print(state.weekData);
            final weekData = state.weekData;
            final int weekNumber = weekData['weekNumber'] ?? 0;
            final List<dynamic> descriptions = weekData['description'] ?? [];

            final List<String> images = [];
            final List<Map<String, dynamic>> videos =
            []; // Adjusted for multiple videos
            final List<Map<String, dynamic>> contentDetails = [];
            final List<Map<String, dynamic>> accordianFeatures = [];
            final List<Map<String, dynamic>> accordianInformation = [];
            final List<Map<String, dynamic>> symptoms = [];
            final List<Map<String, dynamic>> tips = [];
            final List<Map<String, dynamic>> faq = [];
            String textDescription = '';

            for (var description in descriptions) {
              if (description is Map<String, dynamic>) {
                images.addAll((description['Images'] as List<dynamic>?)
                    ?.map((img) => img.toString()) ??
                    []);
                String htmlTextDescription =
                    description['TextDescription'] ?? '';
                textDescription +=
                    parse(htmlTextDescription).documentElement?.text ?? '';

                // Process the videos array
                if (description['Videos'] != null) {
                  for (var video in description['Videos']) {
                    String videoKey = video['videohls']?.toString() ?? '';
                    String fixedString = '13120427';
                    if (videoKey.endsWith(fixedString)) {
                      videoKey = videoKey.substring(
                          0, videoKey.length - fixedString.length);
                    }
                    videos.add({
                      'video': video['video']?.toString() ?? '',
                      'image': videoKey
                    });
                  }
                }

                contentDetails.addAll(
                    (description['ContentDetails'] as List<dynamic>?)
                        ?.map((item) => item as Map<String, dynamic>) ??
                        []);

                accordianFeatures.addAll(
                    (description['AccordianFeatures'] as List<dynamic>?)
                        ?.map((item) => item as Map<String, dynamic>) ??
                        []);

                accordianInformation.addAll(
                    (description['AccordianInformation'] as List<dynamic>?)
                        ?.map((item) => item as Map<String, dynamic>) ??
                        []);

                symptoms.addAll((description['Symptoms'] as List<dynamic>?)
                    ?.map((item) => item as Map<String, dynamic>) ??
                    []);

                tips.addAll((description['Tips'] as List<dynamic>?)
                    ?.map((item) => item as Map<String, dynamic>) ??
                    []);

                faq.addAll((description['FAQ'] as List<dynamic>?)
                    ?.map((item) => item as Map<String, dynamic>) ??
                    []);
              }
            }

            return images.isEmpty &&
                symptoms.isEmpty &&
                textDescription.isEmpty &&
                videos.isEmpty &&
                contentDetails.isEmpty &&
                accordianFeatures.isEmpty &&
                accordianInformation.isEmpty &&
                tips.isEmpty &&
                faq.isEmpty
                ? Center(child: Image.asset('assets/Images/nodata.jpg'))
                : ListView(
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                                  ? 220
                                  : 180,
                              color: AppColors.searchResultBgColor,
                            ),
                            Container(
                              height: 80,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${weekNumber} Week Pregnant',
                                    style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .searchResult1StyleTablet
                                        : FTextStyle.searchResult1Style,
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!)
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 65),
                                child: SizedBox(
                                  height: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? 100.w
                                      : 100,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double totalWidth =
                                          constraints.maxWidth;
                                      double itemWidth = (totalWidth -
                                          (images.length + 1) * 16) /
                                          images
                                              .length; // Calculate width of each item

                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: List.generate(
                                            images.length, (index) {
                                          return Row(
                                            children: [
                                              if (index > 0)
                                                SizedBox(
                                                    width:
                                                    16.0), // Add spacing between images
                                              Container(
                                                width: itemWidth,
                                                height: (displayType ==
                                                    'desktop' ||
                                                    displayType ==
                                                        'tablet')
                                                    ? 100.w
                                                    : 100,
                                                clipBehavior:
                                                Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(10),
                                                  border: Border.all(
                                                    color: AppColors
                                                        .primaryColorPink,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(8),
                                                  child: Image.network(
                                                    images[index],
                                                    fit: BoxFit.cover,
                                                    width: itemWidth,
                                                    height: (displayType ==
                                                        'desktop' ||
                                                        displayType ==
                                                            'tablet')
                                                        ? 60.w
                                                        : 100,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    textDescription.isEmpty
                        ? SizedBox()
                        : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Text(
                            textDescription,
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle
                                .recipeDescriptionSubTextStyleTablet
                                : FTextStyle
                                .recipeDescriptionSubTextStyle,
                            textAlign: TextAlign.justify,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    // Render all videos
                    videos.isEmpty
                        ? SizedBox()
                        : Column(
                      children: videos.map((video) {
                        String videoKey = video['image'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Container(
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoPlayerWidget(
                                        videoUrl: APIEndPoints.dynTubeBaseUrl +
                                            videoKey));
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Column(
                      children: [
                        // Display the first content detail item
                        contentDetails.isEmpty
                            ? SizedBox()
                            : Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 22,
                                      top: 10,
                                      bottom: 10),
                                  child: Text(
                                    truncateText(
                                      contentDetails[0]['title'] ??
                                          '',
                                      38,
                                    ),
                                    style: (displayType ==
                                        'desktop' ||
                                        displayType == 'tablet')
                                        ? FTextStyle
                                        .searchResult4StylTablet
                                        : FTextStyle
                                        .searchResult4Style,
                                  ).animateOnPageLoad(animationsMap[
                                  'imageOnPageLoadAnimation2']!),
                                ),
                              ],
                            ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
            children: [
            ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
            child: HtmlWidget(
            contentDetails.isNotEmpty && contentDetails[0]['description'] != null
            ? contentDetails[0]['description']
                : '', // Fallback for null or empty description
            textStyle: (displayType == 'desktop' || displayType == 'tablet')
            ? FTextStyle.recipeDescriptionSubTextStyleTablet
                : FTextStyle.recipeDescriptionSubTextStyle,
            ).animateOnPageLoad(
            animationsMap['imageOnPageLoadAnimation2']!,
            ),
            ),
            ],
            ),
          ),

          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Image.network(
                                      contentDetails[0]['image'],
                                      height: (displayType ==
                                          'desktop' ||
                                          displayType ==
                                              'tablet')
                                          ? 100.w
                                          : 180,
                                      width: (displayType ==
                                          'desktop' ||
                                          displayType ==
                                              'tablet')
                                          ? 100.w
                                          : 180,
                                      fit: BoxFit.cover,
                                    ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // Display all accordions
                        accordianFeatures.isEmpty
                            ? SizedBox()
                            : Column(
                          children: [
                            ListView.builder(
                              physics:
                              NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: accordianFeatures.length,
                              itemBuilder: (context, index) {
                                bool isExpanded =
                                    expandedIndex == index;
                                return Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 21,
                                      vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      color: AppColors.cardBack,
                                      border: Border.all(
                                          color: AppColors.cardBack,
                                          width: 2),
                                    ),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              expandedIndex =
                                              isExpanded
                                                  ? null
                                                  : index;
                                            });
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .all(12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  truncateText(
                                                    accordianFeatures[
                                                    index]
                                                    [
                                                    'title'] ??
                                                        '',
                                                    38,
                                                  ),
                                                  style: (displayType ==
                                                      'desktop' ||
                                                      displayType ==
                                                          'tablet')
                                                      ? FTextStyle
                                                      .searchResult5StyleTablet
                                                      : FTextStyle
                                                      .searchResult5Style,
                                                ).animateOnPageLoad(
                                                    animationsMap[
                                                    'imageOnPageLoadAnimation2']!),
                                                Image(
                                                  image: const AssetImage(
                                                      'assets/Images/dropDown.png'),
                                                  width:
                                                  displayType ==
                                                      "mobile"
                                                      ? 10
                                                      : 15.0,
                                                  height:
                                                  displayType ==
                                                      "mobile"
                                                      ? 5
                                                      : 12.0,
                                                  color: AppColors
                                                      .searchResultdropDownColor,
                                                ).animateOnPageLoad(
                                                    animationsMap[
                                                    'imageOnPageLoadAnimation2']!),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (isExpanded)
                                          Padding(

                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Align(
                                              alignment: Alignment
                                                  .centerLeft,
                                              child: Text(
                                                convertHtmlToPlainText(
                                                  accordianFeatures[
                                                  index]
                                                  [
                                                  'description'] ??
                                                      '',
                                                ),
                                                style: (displayType ==
                                                    'desktop' ||
                                                    displayType ==
                                                        'tablet')
                                                    ? FTextStyle
                                                    .searchResult5StyleTablet
                                                    : FTextStyle
                                                    .searchResult5Style,
                                                textAlign:
                                                TextAlign.left,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).animateOnPageLoad(animationsMap[
                            'imageOnPageLoadAnimation2']!),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // Display remaining content details (except the first item)
                        contentDetails.length <= 1
                            ? SizedBox()
                            : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: contentDetails.length - 1,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          left: 22,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        truncateText(
                                          contentDetails[index + 1]
                                          ['title'] ??
                                              '',
                                          38,
                                        ),
                                        style: (displayType ==
                                            'desktop' ||
                                            displayType ==
                                                'tablet')
                                            ? FTextStyle
                                            .searchResult4StylTablet
                                            : FTextStyle
                                            .searchResult4Style,
                                      ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation2']!),
                                    ),
                                  ],
                                ),
                            Row(
                            children: [
                            Padding(
                            padding: const EdgeInsets.only(left: 22),
                            child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
                            child: HtmlWidget(
                            contentDetails.isNotEmpty && contentDetails[index + 1]['description'] != null
                            ? contentDetails[index + 1]['description']
                                : '', // Fallback for null or empty description
                            textStyle: (displayType == 'desktop' || displayType == 'tablet')
                            ? FTextStyle.recipeDescriptionSubTextStyleTablet
                                : FTextStyle.recipeDescriptionSubTextStyle,
                            customStylesBuilder: (element) {
                            // Add any custom styles if needed for specific HTML tags
                            return null;
                            },
                            buildAsync: true, // Renders asynchronously for better performance
                            ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!,
                            ),
                            ),
                            ),
                            ],
                            ),
                            Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Image.network(
                                          contentDetails[index + 1]
                                          ['image'],
                                          height: (displayType ==
                                              'desktop' ||
                                              displayType ==
                                                  'tablet')
                                              ? 100.w
                                              : 180,
                                          width: (displayType ==
                                              'desktop' ||
                                              displayType ==
                                                  'tablet')
                                              ? 100.w
                                              : 180,
                                          fit: BoxFit.cover,
                                        ).animateOnPageLoad(
                                            animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ).animateOnPageLoad(animationsMap[
                        'imageOnPageLoadAnimation2']!),
                      ],
                    ),
                    symptoms.isEmpty
                        ? SizedBox()
                        : Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 21, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Possible Symptoms',
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle
                                .searchResult2StyleTablet
                                : FTextStyle.searchResult2Style,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!)
                        ],
                      ),
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: symptoms.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: [
                              Card(
                                child: GestureDetector(
                                  onTap: () => _launchURL(symptoms[index]
                                  ['redirectUrl'] ??
                                      "https://health2mama-web.mobiloitte.io/"),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.r)),
                                    child: Image.network(
                                      symptoms[index]['image'],
                                      height: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? 100.w
                                          : 100,
                                      width: (displayType == 'desktop' ||
                                          displayType == 'tablet')
                                          ? 100.w
                                          : 100,
                                      fit: BoxFit.cover,
                                    ).animateOnPageLoad(animationsMap[
                                    'imageOnPageLoadAnimation2']!),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Text(
                                  symptoms[index]['title'].length > 10
                                      ? symptoms[index]['title']
                                      .substring(0, 10) +
                                      '...'
                                      : symptoms[index]['title'],
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle
                                      .searchResult6StyleTablet
                                      : FTextStyle.searchResult6Style,
                                ).animateOnPageLoad(animationsMap[
                                'imageOnPageLoadAnimation2']!),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    tips.isEmpty
                        ? SizedBox()
                        : Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 21, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${tips.length} Top Tips',
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle
                                .searchResult2StyleTablet
                                : FTextStyle.searchResult2Style,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage('assets/Images/backpink.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 21, vertical: 10),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tips.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                          '${index + 1}. ${tips[index]['title']}',
                                          style: (displayType ==
                                              'desktop' ||
                                              displayType == 'tablet')
                                              ? FTextStyle
                                              .searchResult7StyleTablet
                                              : FTextStyle
                                              .searchResult7Style),
                                    )
                                  ],
                                ),
                              );
                            },
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ),
                      ),
                    ),
                    faq.isEmpty
                        ? SizedBox()
                        : Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 21, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'FAQ’s',
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle
                                .searchResult2StyleTablet
                                : FTextStyle.searchResult2Style,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 21, vertical: 5),
                      child: ListView.builder(
                        itemCount: faq.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String imageUrl = faq[index]['image'] ?? "";
                          bool isExpanded = _expandedIndex == index;
                          return Padding(
                            padding: EdgeInsets.all(
                                (displayType == 'desktop' ||
                                    displayType == 'tablet')
                                    ? 5.h
                                    : screenHeight * 0.005),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.cardBack,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _expandedIndex = isExpanded
                                            ? null
                                            : index; // Toggle expansion
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                              ? 10.h
                                              : screenHeight * 0.021),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => _launchURL(faq[
                                            index]
                                            ['redirectUrl'] ??
                                                "https://health2mama-web.mobiloitte.io/"), // launches URL on image tap
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  5),
                                              child: imageUrl.isEmpty
                                                  ? SizedBox()
                                                  : Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                height: (displayType ==
                                                    'desktop' ||
                                                    displayType ==
                                                        'tablet')
                                                    ? 40.h
                                                    : screenHeight *
                                                    0.06,
                                                width: (displayType ==
                                                    'desktop' ||
                                                    displayType ==
                                                        'tablet')
                                                    ? 40.w
                                                    : screenHeight *
                                                    0.07,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: (displayType ==
                                                'desktop' ||
                                                displayType ==
                                                    'tablet')
                                                ? 20.h
                                                : screenWidth * 0.02,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: (displayType ==
                                                    'desktop' ||
                                                    displayType ==
                                                        'tablet')
                                                    ? 10.h
                                                    : screenWidth * 0.01,
                                              ),
                                              child: Container(
                                                clipBehavior:
                                                Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(8),
                                                  color:
                                                  AppColors.cardBack,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets
                                                      .symmetric(
                                                    vertical: (displayType ==
                                                        'desktop' ||
                                                        displayType ==
                                                            'tablet')
                                                        ? 10.h
                                                        : screenHeight *
                                                        0.021,
                                                    horizontal: (displayType ==
                                                        'desktop' ||
                                                        displayType ==
                                                            'tablet')
                                                        ? 10.h
                                                        : screenWidth *
                                                        0.04,
                                                  ),
                                                  child: Text(
                                                    faq[index][
                                                    'question'] ??
                                                        '',
                                                    style: (displayType ==
                                                        'desktop' ||
                                                        displayType ==
                                                            'tablet')
                                                        ? FTextStyle
                                                        .programsListStyleTab
                                                        : FTextStyle
                                                        .programsListStyle,
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                right: 12.0),
                                            child: Image(
                                              image: const AssetImage(
                                                  'assets/Images/dropDown.png'),
                                              width:
                                              displayType == "mobile"
                                                  ? 10
                                                  : 15.0,
                                              height:
                                              displayType == "mobile"
                                                  ? 5
                                                  : 12.0,
                                              color: AppColors
                                                  .searchResultdropDownColor,
                                            ).animateOnPageLoad(
                                              animationsMap[
                                              'imageOnPageLoadAnimation2']!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isExpanded)
                                    Padding(
                                      padding: EdgeInsets.all(
                                          (displayType == 'desktop' ||
                                              displayType == 'tablet')
                                              ? 10.h
                                              : screenHeight * 0.021),
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 4.w),
                                        child: Text(
                                          faq[index]['answer'] ?? '',
                                          style: (displayType ==
                                              'desktop' ||
                                              displayType == 'tablet')
                                              ? FTextStyle
                                              .programsListStyleTab
                                              : FTextStyle
                                              .programsListStyle,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
                      child: Text(
                        'Information Section',
                        style: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? FTextStyle.searchResult2StyleTablet
                            : FTextStyle.searchResult2Style,
                      ).animateOnPageLoad(
                          animationsMap['imageOnPageLoadAnimation2']!),
                    ),
                    accordianInformation.isEmpty
                        ? SizedBox()
                        : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accordianInformation.length,
                      itemBuilder: (context, index) {
                        bool isExpanded = expandedIndex == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 21, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              color: AppColors.cardBack,
                              border: Border.all(
                                  color: AppColors.cardBack,
                                  width: 2),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      expandedIndex =
                                      isExpanded ? null : index;
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          truncateText(
                                            accordianInformation[
                                            index]
                                            ['title'] ??
                                                '',
                                            38,
                                          ),
                                          style: (displayType ==
                                              'desktop' ||
                                              displayType ==
                                                  'tablet')
                                              ? FTextStyle
                                              .searchResult5StyleTablet
                                              : FTextStyle
                                              .searchResult5Style,
                                        ).animateOnPageLoad(
                                            animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                        Image(
                                          image: const AssetImage(
                                              'assets/Images/dropDown.png'),
                                          width: displayType ==
                                              "mobile"
                                              ? 10
                                              : 15.0,
                                          height: displayType ==
                                              "mobile"
                                              ? 5
                                              : 12.0,
                                          color: AppColors
                                              .searchResultdropDownColor,
                                        ).animateOnPageLoad(
                                            animationsMap[
                                            'imageOnPageLoadAnimation2']!),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isExpanded)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        bottom: 12),
                                    child: Align(
                                      alignment:
                                      Alignment.centerLeft,
                                      child: Text(
                                        convertHtmlToPlainText(
                                          accordianInformation[
                                          index]
                                          ['description'] ??
                                              '',
                                        ),
                                        style: (displayType ==
                                            'desktop' ||
                                            displayType ==
                                                'tablet')
                                            ? FTextStyle
                                            .searchResult5StyleTablet
                                            : FTextStyle
                                            .searchResult5Style,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 40.h
                            : 45.0,
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                const Color(0xFFF58CA9)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'Next Topic  >',
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle.tabToStartButtonTablet
                                : FTextStyle.tabToStartButton,
                          ).animateOnPageLoad(animationsMap[
                          'imageOnPageLoadAnimation2']!),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Back to Section',
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle
                                .recipeDescriptionSubTextStyleTablet
                                : FTextStyle
                                .recipeDescriptionSubTextStyle,
                            textAlign: TextAlign.start,
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: (displayType == 'desktop' ||
                            displayType == 'tablet')
                            ? 40.h
                            : 45.0,
                        child: TextButton(
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
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                            '<  Previous Topic',
                            style: (displayType == 'desktop' ||
                                displayType == 'tablet')
                                ? FTextStyle.tabToStartButtonTablet
                                : FTextStyle.tabToStartButton,
                          ),
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                  ],
                ),
              ],
            );
          } else if (state is ViewWeekError) {
            // Show an error message if something went wrong
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else {
            // Handle other states or return a default UI
            return Center(
              child: Text('Week Data Found'),
            );
          }
        },
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/submisson_dialog.dart';
import 'package:health2mama/apis/forums/forums_bloc.dart';
import 'package:intl/intl.dart';
import '../../Utils/CommonFuction.dart';

class ForumsListing extends StatefulWidget {
  const ForumsListing({Key? key}) : super(key: key);

  @override
  State<ForumsListing> createState() => _ForumsListingState();
}

class _ForumsListingState extends State<ForumsListing> {
  bool isDropdownVisible = false;
  String selectedTopic = '';
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _titleError;
  String? _descriptionError;
  final int maxTitleLength = 50;
  final int maxDescriptionLength = 200;
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

  bool get allFieldsFilled =>
      _titleController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty;

  void _submit(BuildContext context) {
    // Check if both title and description are not empty
    if (allFieldsFilled) {
      BlocProvider.of<ForumsBloc>(context).add(CreateForumEvent(
          title: _titleController.text,
          description: _descriptionController.text));
    }
  }
  String formatDate(String createdAt) {
    // Parse the given date string
    DateTime parsedDate = DateTime.parse(createdAt);
    // Format the date to "26 Aug 2024 10:06 AM" style
    String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(parsedDate);

    return formattedDate;
  }
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ForumsBloc>(context).add(FetchForums());
    _searchController.addListener(() {
      final searchQuery = _searchController.text;
     });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Ask Away",
                  style: (displayType == 'desktop' || displayType == 'tablet')
                      ? FTextStyle.appTitleStyleTablet
                      : FTextStyle.appBarTitleStyle)),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              // Clear search suggestions or search controller when navigating back.
              _searchController.clear();
              Navigator.pop(context,[true]);
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
        body: BlocListener<ForumsBloc, ForumsState>(
            listener: (context, state) {
              if (state is CreateForumsLoaded) {
                // Show success dialog or message
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SubmissionDialog(message: 'Thanks For Submitting');
                  },
                ).then((_) {
                  // Optionally clear form fields or navigate away after submission
                  _titleController.clear();
                  _descriptionController.clear();
                  // Update the state to fetch the forums
                  setState(() {
                    BlocProvider.of<ForumsBloc>(context).add(FetchForums());
                  });
                });
              } else if (state is CreateForumsError) {
                // Show error dialog or message
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SubmissionDialog(
                        message: 'Error: ${state.failureResponse}');
                  },
                );
              }
            },
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Divider(
                    thickness: screenHeight * 0.0012,
                    color: const Color(0XFFF6F6F6),
                  ), // Separator line

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.0125),
                        Text(
                          'Create Your Known Topic',
                          textAlign: TextAlign.left,
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.appTitleStyleTablet
                              : FTextStyle.appBarTitleStyle,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.00625),
                        Text(
                          'Please enter the details.',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.dateTimeTablet
                              : FTextStyle.dateTime,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.03125),
                        Text(
                          'Topic Title',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.loginEmailFieldHeadingStyleTablet
                              : FTextStyle.loginEmailFieldHeadingStyle,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.00625),
                        Container(
                          height: screenHeight * 0.0625,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.0325),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: const Color(0XFFEFEFF4)),
                          ),
                          child: Center(
                            child: TextFormField(
                              readOnly: true,
                              style: FTextStyle.ForumsTextField,
                              controller: _titleController,
                              decoration: InputDecoration(
                               suffixIcon: isDropdownVisible ? Icon(
                                Icons.arrow_drop_up,
                                color: Colors.grey,
                                size: 30,
                              ) : Icon(
                                 Icons.arrow_drop_down,
                                 color: Colors.grey,
                                 size: 30,
                               ),
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'Select Topic',
                                hintStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.loginFieldHintTextStyleTablet
                                    : FTextStyle.loginFieldHintTextStyle,
                                errorStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.formFieldErrorTxtStyleTablet
                                    : FTextStyle.formFieldErrorTxtStyle,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () {
                                setState(() {
                                  BlocProvider.of<ForumsBloc>(context).add(FetchExistingTopics());
                                  isDropdownVisible =
                                  !isDropdownVisible;
                                },
                                );
                              }
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        if (_titleError != null && _titleError != '')
                          Padding(
                            padding: const EdgeInsets.only(top: 12, left: 8),
                            child: Text(
                              _titleError!,
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.formFieldErrorTxtStyleTablet
                                  : FTextStyle.formFieldErrorTxtStyle,
                            ),
                          ),
                        BlocBuilder<ForumsBloc, ForumsState>(
                          builder: (context, state) {
                            if (state is ExistingTopicLoaded) {
                              return AnimatedOpacity(
                                opacity: isDropdownVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 2000), // Duration for the fade-in/out animation
                                child: Visibility(
                                  visible: isDropdownVisible,
                                  child: IntrinsicHeight(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: state.topics.map<Widget>((topic) {
                                          // Truncate topic name if longer than 39 characters
                                          final String topicName = topic['topicName'] ?? '';
                                          final String displayName = topicName.length > 30
                                              ? '${topicName.substring(0, 30)}...'
                                              : topicName;

                                          final bool isSelected = selectedTopic == topicName;

                                          return Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      // Update selectedTopic to the new selection
                                                      selectedTopic = topicName;

                                                      // Update the TextFormField with the selected topic
                                                      String displayText = selectedTopic;
                                                      if (displayText.length > 35) {
                                                        displayText = displayText.substring(0, 35) + "...";
                                                      }

                                                      // Hide title error and close the dropdown with animation
                                                      _titleError = null; // Hide title error
                                                      Future.delayed(const Duration(milliseconds: 300), () {
                                                        setState(() {
                                                          isDropdownVisible = false;
                                                        });
                                                      });
                                                      _titleController.text = selectedTopic;

                                                      // Print the selected topic
                                                      print("Selected Topic Is: $selectedTopic");
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(3),
                                                            border: Border.all(
                                                              color: isSelected
                                                                  ? AppColors.primaryColorPink
                                                                  : AppColors.boarderColour,
                                                              width: 1.5,
                                                            ),
                                                            color: isSelected
                                                                ? AppColors.primaryColorPink
                                                                : Colors.white,
                                                          ),
                                                          child: isSelected
                                                              ? const Icon(
                                                            Icons.check_box,
                                                            color: Colors.white,
                                                            size: 24,
                                                          )
                                                              : null,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(displayName).animateOnPageLoad(
                                          animationsMap['imageOnPageLoadAnimation2']!),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else if (state is ExistingTopicError) {
                              return Text(state.message);
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),

                        SizedBox(height: screenHeight * 0.025),
                        Text(
                          'Description',
                          style: (displayType == 'desktop' ||
                                  displayType == 'tablet')
                              ? FTextStyle.loginEmailFieldHeadingStyleTablet
                              : FTextStyle.loginEmailFieldHeadingStyle,
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        SizedBox(height: screenHeight * 0.00625),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.0325),
                          height: screenHeight * 0.1375,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: const Color(0XFFEFEFF4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              style: FTextStyle.ForumsTextField,
                              controller: _descriptionController,
                              maxLines: 10,
                              maxLength: maxDescriptionLength,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: 'Ask question',
                                hintStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.loginFieldHintTextStyleTablet
                                    : FTextStyle.loginFieldHintTextStyle,
                                errorStyle: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.formFieldErrorTxtStyleTablet
                                    : FTextStyle.formFieldErrorTxtStyle,
                              ),
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation2']!),
                        if (_descriptionError != null &&
                            _descriptionError != '')
                          Padding(
                            padding: const EdgeInsets.only(top: 2, left: 12),
                            child: Text(
                              _descriptionError!,
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.formFieldErrorTxtStyleTablet
                                  : FTextStyle.formFieldErrorTxtStyle,
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.025),
                        Container(
                          height: screenHeight * 0.065,
                          width: screenWidth * 0.30,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _titleError = _titleController.text.isEmpty
                                    ? '*Please enter title.'
                                    : null;
                                _descriptionError =
                                    _descriptionController.text.isEmpty
                                        ? '*Please enter description.'
                                        : null;
                              });
                              if (_titleError == null &&
                                  _descriptionError == null) {
                                _submit(context);
                              }
                            },
                            child: Text(
                              'Submit',
                              style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                  ? FTextStyle.tabToStartButtonTablet
                                  : FTextStyle.ForumsButtonStyling,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue1,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['imageOnPageLoadAnimation2']!),
                        ),
                        SizedBox(height: screenHeight * 0.025),
                      ],
                    ),
                  ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 18.0),
//                     child: Center(
//                       child: Text(
//                         "Previous Topics",
//                         style: (displayType == 'desktop' ||
//                                 displayType == 'tablet')
//                             ? FTextStyle.appTitleStyleTablet
//                             : FTextStyle.appBarTitleStyle,
//                       ),
//                     ),
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       top: 10,
//                       bottom: 20,
//                       left: 22,
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           height: (displayType == 'desktop' ||
//                                   displayType == 'tablet')
//                               ? 50.h
//                               : 50,
//                           width: MediaQuery.of(context).size.width -
//                               36, // Adjusting for padding/margin
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: AppColors.dark1,
//                           ),
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 15.0),
//                               child: TextField(
//                                 controller: _searchController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Search by title',
//                                   hintStyle: (displayType == 'desktop' ||
//                                           displayType == 'tablet')
//                                       ? FTextStyle.ForumsHintStyleTablet
//                                       : FTextStyle.ForumsHintStyle,
//                                   suffixIcon: Padding(
//                                     padding: const EdgeInsets.only(right: 10),
//                                     child: Image.asset(
//                                       'assets/Images/Search.png',
//                                       width: (displayType == 'desktop' ||
//                                               displayType == 'tablet')
//                                           ? 20.w
//                                           : 20,
//                                       height: (displayType == 'desktop' ||
//                                               displayType == 'tablet')
//                                           ? 20.w
//                                           : 20,
//                                     ),
//                                   ),
//                                   border: InputBorder.none, // Remove underline
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ).animateOnPageLoad(
//                       animationsMap['imageOnPageLoadAnimation2']!),
//
//                   BlocBuilder<ForumsBloc, ForumsState>(
//                       builder: (context, state) {
//                     if (state is ForumsLoading) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (state is ForumsLoaded) {
//                       final forums =
//                           state.successResponse['result']['docs'] as List<dynamic>;
// // Check if the search result is empty
//                       if (forums.isEmpty) {
//                         return Center(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 60),
//                             child: Text(
//                               'No forums found.',
//                               style: (displayType == 'desktop' || displayType == 'tablet')
//                                   ? FTextStyle.dateTimeTablet
//                                   : FTextStyle.dateTime,
//                             ),
//                           ),
//                         );
//                       }
//                       return Container(
//                         color: AppColors.scaffholdColor,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 18.0, vertical: 18),
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: forums.length,
//                             itemBuilder: (context, index) {
//                               final forum = forums[index];
//                               return Card(
//                                 margin: EdgeInsets.only(bottom: 10),
//                                 elevation: 0.2,
//                                 shadowColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: ListTile(
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 9, top: 4, right: 9, bottom: 4),
//                                   title: Text(
//                                     forum['topicTitle'] ?? 'No Title',
//                                     style: (displayType == 'desktop' ||
//                                             displayType == 'tablet')
//                                         ? FTextStyle.forumTopicsTitleTablet
//                                         : FTextStyle.forumTopicsTitle,
//                                   ).animateOnPageLoad(animationsMap[
//                                       'imageOnPageLoadAnimation2']!),
//                                   subtitle: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         forum['description'] ??
//                                             'No Description',
//                                         style: (displayType == 'desktop' ||
//                                                 displayType == 'tablet')
//                                             ? FTextStyle
//                                                 .forumTopicsSubTitleTablet
//                                             : FTextStyle.forumTopicsSubTitle,
//                                       ).animateOnPageLoad(animationsMap[
//                                           'imageOnPageLoadAnimation2']!),
//                                       SizedBox(height: 10),
//                                       Text(
//                                         formatDate(forum['createdAt']) ?? 'No Date',
//                                         style: (displayType == 'desktop' ||
//                                                 displayType == 'tablet')
//                                             ? FTextStyle.dateTimeTablet
//                                             : FTextStyle.dateTime,
//                                       ).animateOnPageLoad(animationsMap[
//                                           'imageOnPageLoadAnimation2']!),
//                                     ],
//                                   ),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ForumsDetails(forumId: forum['_id']),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       );
//                     } else if (state is ForumsError) {
//                       return Center(
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 60),
//                           child: Image.asset('assets/Images/nodata.jpg')
//                         ),
//                       );
//                     } else {
//                       return Center(
//                         child: Image.asset('assets/Images/nodata.jpg')
//                       );
//                     }
//                   })


                ])))));
  }
}

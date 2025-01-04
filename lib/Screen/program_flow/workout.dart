import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/program_flow/selected_workout.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';

class WorkoutPage extends StatefulWidget {
  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<dynamic> activeWorkoutCategories = [];
  int currentPage = 1;
  int limit = 4;
  bool hasMoreData = true;
  int totalPages = 0;
  bool _isLoading = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProgramflowBloc>(context).add(
      FetchWorkoutCategories(page: currentPage, limit: limit),
    );
    _loadMoreData();
  }

  void _loadMoreData() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage < totalPages && hasMoreData && !_isLoading) {
          setState(() {
            _isLoading = true;
          });
          currentPage++;
          BlocProvider.of<ProgramflowBloc>(context).add(
            FetchWorkoutCategories(page: currentPage, limit: limit),
          );
        }
      }

      // Detect if user scrolls to top to load previous page
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        if (currentPage > 1 && !_isLoading) {
          setState(() {
            _isLoading = true;
          });
          currentPage--;
          BlocProvider.of<ProgramflowBloc>(context).add(
            FetchWorkoutCategories(page: currentPage, limit: limit),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final animationsMap = {
    'categoryOnPageLoad': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 600.ms,
            begin: 0.0,
            end: 1.0),
        MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 600.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0)),
      ],
    ),
    'subCategoryOnPageLoad': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.ms,
            duration: 600.ms,
            begin: 0.0,
            end: 1.0),
        MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.ms,
            duration: 600.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0)),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreyColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Workout",
            style: FTextStyle.appBarTitleStyle,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Image.asset(
              'assets/Images/back.png',
              width: 35.w,
              height: 35.h,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocListener<ProgramflowBloc, ProgramflowState>(
        listener: (context, state) {
          if (state is WorkoutCategoryLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is WorkoutCategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${state.failureResponse['responseMessage']}',
                ),
              ),
            );
          } else if (state is WorkoutCategoryLoaded) {
            final workoutCategories = state.workoutCategories;

            setState(() {
              // Append new categories to the existing list to preserve old data
              if (currentPage == 1) {
                activeWorkoutCategories.clear();
              }
              activeWorkoutCategories.addAll(workoutCategories);

              // Update pagination state
              totalPages = state.pagination['totalPages'];
              hasMoreData = currentPage < totalPages;
              _isLoading = false;
            });
          }
        },
        child: _isLoading && activeWorkoutCategories.isEmpty
            ? Center(child: CircularProgressIndicator(color: AppColors.pink))
            : activeWorkoutCategories.isEmpty
                ? Center(child: Image.asset('assets/Images/nodata.jpg'))
                : Container(
                    padding: EdgeInsets.only(
                      left:
                          (displayType == 'desktop' || displayType == 'tablet')
                              ? 30.h
                              : 16,
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: hasMoreData
                          ? activeWorkoutCategories.length + 1
                          : activeWorkoutCategories.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index == activeWorkoutCategories.length) {
                          return Center(child: CircularProgressIndicator(color: AppColors.pink));
                        }
                        final category = activeWorkoutCategories[index]
                                as Map<String, dynamic>? ??
                            {};
                        final workoutCategoryName = category['workoutCategory']
                                ?['workoutCategoryName'] as String? ??
                            'No Category Name';
                        final workoutSubCategories =
                            category['workoutSubCategories']
                                    as List<dynamic>? ??
                                [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? 20.h
                                    : 8.h,
                                top: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? 16.h
                                    : 14,
                              ),
                              child: Text(
                                workoutCategoryName.length > 35
                                    ? '${workoutCategoryName.substring(0, 35)}...'
                                    : workoutCategoryName,
                                style: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                    ? FTextStyle.recipeHeadingTextStyleTab
                                    : FTextStyle.recipeHeadingTextStyle,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: workoutSubCategories
                                    .where((subCategory) =>
                                        subCategory['status'] == 'ACTIVE')
                                    .map<Widget>((subCategory) {
                                  final subCategoryId =
                                      subCategory['_id'] as String?;
                                  final subCategoryName =
                                      subCategory['workoutSubCategoryName']
                                              as String? ??
                                          'No Subcategory Name';
                                  final imageUrlList =
                                      subCategory['image'] as List<dynamic>? ??
                                          [];
                                  final image = imageUrlList.isNotEmpty
                                      ? imageUrlList[0] as String
                                      : '';
                                  final exerciseSections =
                                      subCategory['exerciseSections']
                                              as List<dynamic>? ??
                                          [];
                                  final description =
                                      subCategory['description'] as String? ??
                                          'No Description';

                                  return GestureDetector(
                                      onTap: () {
                                        PrefUtils.setitemId(subCategoryId!);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => ProgramflowBloc(),
                                              child: SelectedWorkout(
                                                id: subCategoryId,
                                                workoutSubCategoryName: subCategoryName,
                                                image: image,
                                                exerciseSections: exerciseSections,
                                                description: description,
                                              ),
                                            ),
                                          ),
                                        ).then((result) {
                                          if (result == true) {
                                            // Trigger a Bloc event or update the state to refresh the list
                                            BlocProvider.of<ProgramflowBloc>(context).add(
                                              FetchWorkoutCategories(page: currentPage, limit: limit),
                                            );
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
                                          width: (displayType == 'desktop' || displayType == 'tablet')
                                              ? MediaQuery.of(context).size.width * 0.21
                                              : MediaQuery.of(context).size.width * 0.43,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20),
                                                    topRight: Radius.circular(20),
                                                  ),
                                                  child: Stack(
                                                    alignment: Alignment.center, // Center the checkmark within the Stack
                                                    children: [
                                                      image.isNotEmpty
                                                          ? Image.network(
                                                        image,
                                                        height: (displayType == 'desktop' || displayType == 'tablet')
                                                            ? MediaQuery.of(context).size.width * 0.13
                                                            : MediaQuery.of(context).size.height * 0.13,
                                                        fit: BoxFit.fill,
                                                      )
                                                          : Container(
                                                        height: 100,
                                                        width: double.infinity,
                                                        color: Colors.grey[200],
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.image,
                                                            size: 40,
                                                          ),
                                                        ),
                                                      ),
                                                      // Checkmark conditionally added here
                                                      if (subCategory["isCompleted"])
                                                        Image.asset("assets/Images/check.png")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
                                                child: Text(
                                                  subCategoryName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: (displayType == 'desktop' || displayType == 'tablet')
                                                      ? FTextStyle.smallTextBlackTablet
                                                      : FTextStyle.smallTextBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )

                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

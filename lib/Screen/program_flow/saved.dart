import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/program_flow/recipes_description.dart';
import 'package:health2mama/Screen/program_flow/selected_workout.dart';
import 'package:health2mama/Screen/program_flow/topic_description.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';

class SavedItem extends StatefulWidget {
  const SavedItem({super.key});

  @override
  State<SavedItem> createState() => _SavedItemState();
}

class _SavedItemState extends State<SavedItem> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProgramflowBloc>(context)
        .add(FetchSavedTopicsEvent(PrefUtils.getCategoryId()));
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

  @override
  Widget build(BuildContext context) {
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Saved Items", style: FTextStyle.appBarTitleStyle),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // Add your action here, if needed
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
                    ? 35.w
                    : 35,
                height: (displayType == 'desktop' || displayType == 'tablet')
                    ? 35.h
                    : 35,
              ),
            ),
          ),
        ),
        body: BlocBuilder<ProgramflowBloc, ProgramflowState>(
          builder: (context, state) {
            if (state is SavedTopicsLoading) {
              // return Center(child: CircularProgressIndicator());
              return SizedBox();
            } else if (state is SavedTopicsLoaded) {
              final filteredTopics = state.savedTopics
                  .where((topic) =>
              topic['isSaved'] == true &&
                  topic.containsKey('topicDetails') &&
                  topic['topicDetails'] != null &&
                  topic['topicDetails'].isNotEmpty
              ).toList();

              // Check if there are no saved items
              if (filteredTopics.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/Images/nodata.jpg',
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    (displayType == 'desktop' ||
                        displayType == 'tablet')
                        ? 4
                        : 2,
                    crossAxisSpacing:
                    (displayType == 'desktop' ||
                        displayType == 'tablet')
                        ? 2.h
                        : 2,
                    mainAxisSpacing:
                    (displayType == 'desktop' ||
                        displayType == 'tablet')
                        ? 2.h
                        : 2,
                    childAspectRatio:
                    (displayType == 'desktop' ||
                        displayType == 'tablet')
                        ? 1.2
                        : 1,
                  ),
                  itemCount: filteredTopics.length,
                  itemBuilder: (context, index) {
                    final topic = filteredTopics[index];
                    final details = topic['topicDetails'];

                    // Fallback image logic
                    final image = details != null &&
                        details.containsKey('image') &&
                        details['image'] != null &&
                        details['image'].isNotEmpty
                        ? details['image'][0]
                        : (details != null &&
                        details.containsKey('programThumbnailImage') &&
                        details['programThumbnailImage'] != null
                        ? details['programThumbnailImage']
                        : (details != null &&
                        details.containsKey('topicThumbnailImage') &&
                        details['topicThumbnailImage'] != null
                        ? details['topicThumbnailImage']
                        : (details != null &&
                        details.containsKey('recipeThumbnailImage') &&
                        details['recipeThumbnailImage'] != null
                        ? details['recipeThumbnailImage']
                        : 'https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg')));

                    // Display name logic
                    final displayName = details != null &&
                        details.containsKey('workoutSubCategoryName') &&
                        details['workoutSubCategoryName'] != null
                        ? details['workoutSubCategoryName']
                        : (details != null &&
                        details.containsKey('programName') &&
                        details['programName'] != null
                        ? details['programName']
                        : (details != null &&
                        details.containsKey('topicName') &&
                        details['topicName'] != null
                        ? details['topicName']
                        : (details != null &&
                        details.containsKey('recipeName') &&
                        details['recipeName'] != null
                        ? details['recipeName']
                        : 'Unknown Recipe/Topic')));



                    return GestureDetector(
                      onTap: () {
                        if (details != null) {
                          if (details.containsKey('recipeThumbnailImage') && details.containsKey('recipeName')) {
                            final recipeId = details['_id'];
                            PrefUtils.setitemId(recipeId);
                            final recipeName = details['recipeName'] is String ? details['recipeName'] : 'Unknown Recipe';
                            final recipeThumbnailImage = details[
                            'recipeThumbnailImage'] is String
                                ? details['recipeThumbnailImage']
                                : 'https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg';
                            final preparationTime =
                            details['preparationTime'] is int
                                ? details['preparationTime']
                                : 0;
                            final servings = details['servings'] is int
                                ? details['servings']
                                : 0;
                            final ingredientDetails =
                            details['ingredientDetails'] is String
                                ? details['ingredientDetails']
                                : 'No ingredients available';
                            final notes = details['notes'] is String
                                ? details['notes']
                                : 'No notes available';
                            final steps = details['steps'] is List
                                ? details['steps'].cast<String>()
                                : [];
                            final nutrition = details['nutrition'] is List
                                ? details['nutrition']
                                .cast<Map<String, dynamic>>()
                                : [];
                            final recipeType = details['recipeType'] is String
                                ? details['recipeType']
                                : 'Unknown';

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProgramflowBloc(),
                                  child: RecipesDescription(
                                    recipeName: recipeName,
                                    recipeThumbnailImage: recipeThumbnailImage,
                                    preparationTime: preparationTime,
                                    servings: servings,
                                    ingredientDetails: ingredientDetails,
                                    notes: notes,
                                    steps: steps,
                                    nutrition: nutrition,
                                    recipeType: recipeType,
                                  ),
                                ),
                              ),
                            );
                          } else if ((details.containsKey('programName') || details.containsKey('topicName')) &&
                              (details.containsKey('programThumbnailImage') || details.containsKey('topicThumbnailImage'))) {
                            // Safely retrieve values with fallback
                            final topicId = details['_id'];
                            PrefUtils.setitemId(topicId);

                            // Check and assign `programName` or `topicName`
                            final topicName = details['programName'] is String
                                ? details['programName']
                                : (details['topicName'] is String ? details['topicName'] : 'Unknown Topic');

                            // Check and assign `programThumbnailImage` or `topicThumbnailImage`
                            final topicImage = details['programThumbnailImage'] is String
                                ? details['programThumbnailImage']
                                : (details['topicThumbnailImage'] is String
                                ? details['topicThumbnailImage']
                                : 'https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg');

                            // Retrieve content details if it's a list, otherwise use an empty string
                            final contentDetails = details['contentDetails'] is List<dynamic> ? details['contentDetails'] : '';

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
                            );
                          } else if (details.containsKey('workoutSubCategoryName') && details.containsKey('image')) {
                            // Workout details found, navigate to SelectedWorkout screen
                            final id = details['_id'];
                            PrefUtils.setitemId(id);
                            final workoutSubCategoryName = details['workoutSubCategoryName'] as String? ?? 'Unknown Workout';
                            final image = (details['image'] as List<dynamic>?)?.isNotEmpty == true
                                ? (details['image'][0] as String?) ?? ''
                                : '';
                            final exerciseSections = details['exerciseSections'] as List<dynamic>? ?? [];'No Time'; // Convert int to String
                            final description = details['description'] as String? ?? 'No Description';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProgramflowBloc(),
                                  child: SelectedWorkout(
                                    workoutSubCategoryName:
                                    workoutSubCategoryName,
                                    image: image,
                                    description: description,
                                    id: topic['_id'],
                                    exerciseSections: exerciseSections,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Card(
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.zero,
                          width: (displayType == 'desktop' ||   displayType == 'tablet')
                              ? MediaQuery.of(context).size.width * 0.21
                              : MediaQuery.of(context).size.width * 0.43,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Padding is added here, but we need to account for it in the image size
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      15), // Reduced to fit within padding
                                  child: Image.network(
                                    image,
                                    height: (displayType == 'desktop' ||
                                        displayType == 'tablet')
                                        ? MediaQuery.of(context).size.width *
                                        0.13 -
                                        10 // Subtract padding
                                        : MediaQuery.of(context).size.height *
                                        0.13 -
                                        10, // Subtract padding
                                    width: double
                                        .infinity, // Ensure it fills the width of its parent
                                    fit: BoxFit
                                        .cover, // Use cover to maintain aspect ratio
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12, left: 10, right: 10),
                                child: Text(
                                  displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: (displayType == 'desktop' ||
                                      displayType == 'tablet')
                                      ? FTextStyle.reListStyleTab
                                      : FTextStyle.reListStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return Center(
                child: Column(
                    children: [Image.asset('assets/Images/nodata.jpg')]));
          },
        ));
  }
}

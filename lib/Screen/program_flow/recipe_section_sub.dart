import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/FluterFlow/flutter_flow_animations.dart';
import 'package:health2mama/Screen/program_flow/recipes_description.dart';
import 'package:health2mama/Utils/CommonFuction.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';

class RecipeCategorySub extends StatefulWidget {
  const RecipeCategorySub({super.key});

  @override
  State<RecipeCategorySub> createState() => _RecipeCategorySubState();
}

class _RecipeCategorySubState extends State<RecipeCategorySub> {
  bool isRecipeLoading = false;
  bool isFilterRecipeLoading = false;
  List<dynamic> recipeData = [];

  List<dynamic> allRecipes = [];
  int currentPage = 1;
  int limit = 3;
  bool hasMoreData = true;
  int totalPages = 0;
  bool _isLoading = false;
  final _scrollController = ScrollController();

  void resetFilter() {
    setState(() {
      // Clear the TextFormField
      _dietaryTextEditingController.text = '';
      _cuisineTextEditingController.text = '';
      _dietTextEditingController.text = '';

      // Unselect all checkboxes
      _selectedDietaryPreferences.clear();
      _selectedCuisinePreferences.clear();
      _selectedDietPreferences.clear();
      selectedDietaryIds.clear();
      selectedDietIds.clear();
      selectedCuisineIds.clear();

      // Hide the dropdown if it's visible
      isDropdownVisible1 = false;
      isDropdownVisible2 = false;
      isDropdownVisible3 = false;
    });
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
          BlocProvider.of<ProgramflowBloc>(context).add(FetchRecipesEvent(page: currentPage, limit: limit));
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
          BlocProvider.of<ProgramflowBloc>(context).add(FetchRecipesEvent(page: currentPage, limit: limit));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ProgramflowBloc>(context)
        .add(FilterRecipeEvent(PrefUtils.getUserStage()));
    BlocProvider.of<ProgramflowBloc>(context).add(FetchRecipesEvent(page: currentPage, limit: limit));
    _dietaryTextEditingController.text = _getFormattedPreferences(_selectedDietaryPreferences);
    _cuisineTextEditingController.text = _getFormattedPreferences(_selectedCuisinePreferences);
    _dietTextEditingController.text = _getFormattedPreferences(_selectedDietPreferences);
    _loadMoreData();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getFormattedPreferences(List<String> preferences) {
    // Join selected dietary preferences with commas
    String formattedPreferences = preferences.join(', ');

    // Truncate if it exceeds 30 characters and append "..."
    if (formattedPreferences.length > 30) {
      return '${formattedPreferences.substring(0, 30)}...';
    } else {
      return formattedPreferences;
    }
  }
  TextEditingController _dietaryTextEditingController = TextEditingController();
  TextEditingController _cuisineTextEditingController = TextEditingController();
  TextEditingController _dietTextEditingController = TextEditingController();
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
  final formKey = GlobalKey<FormState>();
  bool isDropdownVisible1 = false;
  bool isDropdownVisible2 = false;
  bool isDropdownVisible3 = false;
  bool applyButtonEnabled = true;
  List<String> dietaryNames = [];
  Map<String, String> dietaryNameToIdMap = {};
  List<String> dietaryIds = [];
  List<String> selectedDietaryIds = [];
  List<String> _selectedDietaryPreferences = [];
  List<String> dietNames = [];
  Map<String, String> dietNameToIdMap = {};
  List<String> dietIds = [];
  List<String> selectedDietIds = [];
  List<String> _selectedDietPreferences = [];
  List<String> cuisineNames = [];
  Map<String, String> cuisineNameToIdMap = {};
  List<String> cuisineIds = [];
  List<String> selectedCuisineIds = [];
  List<String> _selectedCuisinePreferences = [];

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
              child: Text("Recipes", style: FTextStyle.appBarTitleStyle)),
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
                'assets/Images/back.png',
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
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              height: (displayType == 'desktop' || displayType == 'tablet')
                  ? 65
                  : MediaQuery.of(context).size.height * 0.06,
              width: (displayType == 'desktop' || displayType == 'tablet')
                  ? MediaQuery.of(context).size.height * 0.650
                  : MediaQuery.of(context).size.height * 0.415,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.filterBackroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Filter Recipes',
                      style:
                      (displayType == 'desktop' || displayType == 'tablet')
                          ? FTextStyle.filterTextStyley
                          : FTextStyle.filterTextStyle,
                    ),
                  ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation2']!),
                  InkWell(
                    onTap: () {
                      showGeneralDialog(
                          context: this.context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.91,
                                        height:
                                        MediaQuery.of(context).size.height * 0.52,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/Images/filterbg.png'),
                                              fit: BoxFit.fill),
                                        ),
                                        child: Material(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 0),
                                              child: Column(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    color: Colors.transparent,
                                                  ),
                                                  width: (displayType == 'desktop' ||
                                                      displayType == 'tablet')
                                                      ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.91.h
                                                      : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.91,
                                                  height: (displayType == 'desktop' ||
                                                      displayType == 'tablet')
                                                      ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.4.h
                                                      : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.5,
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 20.0),
                                                      child: Form(
                                                          child: ListView(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom: 8.0),
                                                                    child: Text(
                                                                      'Dietary Preferences',
                                                                      style: (displayType ==
                                                                          'desktop' ||
                                                                          displayType ==
                                                                              'tablet')
                                                                          ? FTextStyle
                                                                          .filterLabelTextStyleTab
                                                                          : FTextStyle
                                                                          .filterLabelTextStyle,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                        'imageOnPageLoadAnimation2']!),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 10),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                  ),
                                                                  child: TextFormField(
                                                                    decoration: InputDecoration(
                                                                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                                                                      hintText: 'Select dietary preference',
                                                                      hintStyle: (displayType == 'desktop' || displayType == 'tablet')
                                                                          ? FTextStyle.filterHintTextStyleTab
                                                                          : FTextStyle.filterHintTextStyle,
                                                                      border: InputBorder.none,
                                                                      suffixIcon: Padding(
                                                                        padding: const EdgeInsets.all(20),
                                                                        child: Image(
                                                                          image: const AssetImage('assets/Images/dropDown.png'),
                                                                          width: (displayType == 'desktop' || displayType == 'tablet') ? 16.h : 14,
                                                                          height: (displayType == 'desktop' || displayType == 'tablet') ? 8.h : 7,
                                                                          color: AppColors.filterDropDownColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    readOnly: true,
                                                                    controller: _dietaryTextEditingController,
                                                                    style: (displayType == 'desktop' || displayType == 'tablet')
                                                                        ? FTextStyle.cardSubtitleTab
                                                                        : FTextStyle.cardSubtitle,
                                                                    maxLines: 1,
                                                                    onTap: () {
                                                                      setState(() {
                                                                        isDropdownVisible1 = !isDropdownVisible1;
                                                                      });
                                                                    },
                                                                  )),
                                                              Visibility(
                                                                visible: isDropdownVisible1,
                                                                child: Container(
                                                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
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
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: dietaryNames.map((dietaryName) {
                                                                          int index = dietaryNames.indexOf(dietaryName);
                                                                          bool isSelected = _selectedDietaryPreferences.contains(dietaryName);
                                                                          String dietaryId = dietaryNameToIdMap[dietaryName] ?? '';
                                                                          return Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        if (!isSelected) {
                                                                                          _selectedDietaryPreferences.add(dietaryName);
                                                                                          selectedDietaryIds.add(dietaryId);
                                                                                          print('Dietary Name Is: $dietaryName And Dietary ID Is: $dietaryId');

                                                                                        } else {
                                                                                          _selectedDietaryPreferences.remove(dietaryName);
                                                                                          selectedDietaryIds.remove(dietaryId);
                                                                                        }
                                                                                        // Update TextEditingController with formatted preferences
                                                                                        _dietaryTextEditingController.text = _getFormattedPreferences(_selectedDietaryPreferences);
                                                                                      });
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(right: 8.0),
                                                                                      child: Container(
                                                                                        width: (displayType == 'desktop' || displayType == 'tablet') ? 24.h : 24,
                                                                                        height: (displayType == 'desktop' || displayType == 'tablet') ? 24.h : 24,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(3),
                                                                                          border: Border.all(
                                                                                            color: isSelected ? AppColors.primaryPinkColor : AppColors.boarderColour,
                                                                                            width: 1.5,
                                                                                          ),
                                                                                          color: isSelected ? AppColors.primaryPinkColor : Colors.white,
                                                                                        ),
                                                                                        child: isSelected
                                                                                            ? Icon(
                                                                                          Icons.check_box,
                                                                                          color: Colors.white,
                                                                                          size: (displayType == 'desktop' || displayType == 'tablet') ? 24.h : 24,
                                                                                        )
                                                                                            : null,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      dietaryName,
                                                                                      maxLines: 3,
                                                                                      style: (displayType == 'desktop' || displayType == 'tablet')
                                                                                          ? FTextStyle.rememberMeTextStyleTab
                                                                                          : FTextStyle.rememberMeTextStyle,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              if (index != dietaryNames.length - 1)
                                                                                const Padding(
                                                                                  padding: EdgeInsets.only(top: 15, bottom: 10),
                                                                                  child: Divider(
                                                                                    color: AppColors.darkGreyColor,
                                                                                    height: 0.5,
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          );
                                                                        }).toList(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    top: 10, bottom: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Cuisine',
                                                                      style: (displayType ==
                                                                          'desktop' ||
                                                                          displayType ==
                                                                              'tablet')
                                                                          ? FTextStyle
                                                                          .filterLabelTextStyleTab
                                                                          : FTextStyle
                                                                          .filterLabelTextStyle,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                        'imageOnPageLoadAnimation2']!),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 10),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(10)),
                                                                child: TextFormField(
                                                                  decoration:
                                                                  InputDecoration(
                                                                    contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                      vertical: 13,
                                                                    ),
                                                                    hintText:
                                                                    'Select cuisine',
                                                                    hintStyle: (displayType ==
                                                                        'desktop' ||
                                                                        displayType ==
                                                                            'tablet')
                                                                        ? FTextStyle
                                                                        .filterHintTextStyleTab
                                                                        : FTextStyle
                                                                        .filterHintTextStyle,
                                                                    border:
                                                                    InputBorder.none,
                                                                    suffixIcon: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(20),
                                                                      child: Image(
                                                                        image: const AssetImage(
                                                                            'assets/Images/dropDown.png'),
                                                                        width: (displayType ==
                                                                            'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                            ? 16.h
                                                                            : 14,
                                                                        height: (displayType ==
                                                                            'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                            ? 8.h
                                                                            : 7,
                                                                        color: AppColors
                                                                            .filterDropDownColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  readOnly: true,
                                                                  // Making it read-only to show the selected value
                                                                  controller:_cuisineTextEditingController,
                                                                  // Setting initial value
                                                                  style: (displayType ==
                                                                      'desktop' ||
                                                                      displayType ==
                                                                          'tablet')
                                                                      ? FTextStyle
                                                                      .cardSubtitleTab
                                                                      : FTextStyle
                                                                      .cardSubtitle,
                                                                  maxLines: 1,
                                                                  onTap: () {
                                                                    setState(() {
                                                                      isDropdownVisible2 =
                                                                      !isDropdownVisible2;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: isDropdownVisible2,
                                                                child: Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical: 20,
                                                                      horizontal: 35),
                                                                  margin:
                                                                  const EdgeInsets.only(
                                                                      bottom: 10),
                                                                  alignment:
                                                                  Alignment.center,
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    color: AppColors
                                                                        .lightGreyColor,
                                                                    borderRadius:
                                                                    BorderRadius.only(
                                                                      bottomLeft:
                                                                      Radius.circular(
                                                                          10),
                                                                      bottomRight:
                                                                      Radius.circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        children:
                                                                        cuisineNames.map(
                                                                                (cuisine) {
                                                                              int index =
                                                                              cuisineNames
                                                                                  .indexOf(
                                                                                  cuisine); // Get the index of the current cuisine
                                                                              bool isSelected =
                                                                              _selectedCuisinePreferences
                                                                                  .contains(
                                                                                  cuisine);
                                                                              String cuisineId =
                                                                                  cuisineNameToIdMap[
                                                                                  cuisine] ??
                                                                                      ''; // Fetch the corresponding cuisine ID

                                                                              return Column(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        onTap:
                                                                                            () {
                                                                                          setState(
                                                                                                  () {
                                                                                                if (!isSelected) {
                                                                                                  _selectedCuisinePreferences.add(cuisine);
                                                                                                  selectedCuisineIds.add(cuisineId); // Add cuisine ID
                                                                                                  print('Cuisine Name Is: $cuisine And Cuisine ID Is: $cuisineId');
                                                                                                } else {
                                                                                                  _selectedCuisinePreferences.remove(cuisine);
                                                                                                  selectedCuisineIds.remove(cuisineId); // Remove cuisine ID
                                                                                                }
                                                                                                // Update TextEditingController with formatted preferences
                                                                                                _cuisineTextEditingController.text = _getFormattedPreferences(_selectedCuisinePreferences);
                                                                                              });
                                                                                        },
                                                                                        child:
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .only(
                                                                                              right: 8.0),
                                                                                          child:
                                                                                          Container(
                                                                                            width: (displayType == 'desktop' || displayType == 'tablet')
                                                                                                ? 24.h
                                                                                                : 24,
                                                                                            height: (displayType == 'desktop' || displayType == 'tablet')
                                                                                                ? 24.h
                                                                                                : 24,
                                                                                            decoration:
                                                                                            BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(3),
                                                                                              border: Border.all(
                                                                                                color: isSelected ? AppColors.primaryPinkColor : AppColors.boarderColour,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                              color: isSelected ? AppColors.primaryPinkColor : Colors.white,
                                                                                            ),
                                                                                            child: isSelected
                                                                                                ? Icon(
                                                                                              Icons.check_box,
                                                                                              color: Colors.white,
                                                                                              size: (displayType == 'desktop' || displayType == 'tablet') ? 24.h : 24,
                                                                                            )
                                                                                                : null,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child:
                                                                                        Text(
                                                                                          cuisine,
                                                                                          maxLines:
                                                                                          3,
                                                                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                                                                              ? FTextStyle.rememberMeTextStyleTab
                                                                                              : FTextStyle.rememberMeTextStyle,
                                                                                        ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  // Add divider conditionally except for the last item
                                                                                  if (index !=
                                                                                      cuisineNames
                                                                                          .length -
                                                                                          1)
                                                                                    const Padding(
                                                                                      padding: EdgeInsets.only(
                                                                                          top:
                                                                                          15,
                                                                                          bottom:
                                                                                          10),
                                                                                      child:
                                                                                      Divider(
                                                                                        color: AppColors
                                                                                            .darkGreyColor,
                                                                                        height:
                                                                                        0.5,
                                                                                      ),
                                                                                    ),
                                                                                ],
                                                                              );
                                                                            }).toList(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    top: 15, bottom: 8),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Diet Types',
                                                                      style: (displayType ==
                                                                          'desktop' ||
                                                                          displayType ==
                                                                              'tablet')
                                                                          ? FTextStyle
                                                                          .filterLabelTextStyleTab
                                                                          : FTextStyle
                                                                          .filterLabelTextStyle,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                        'imageOnPageLoadAnimation2']!),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 10),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(10)),
                                                                child: TextFormField(
                                                                  decoration:
                                                                  InputDecoration(
                                                                    contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                      vertical: 13,
                                                                    ),
                                                                    hintText:
                                                                    'Select diet types',
                                                                    hintStyle: (displayType ==
                                                                        'desktop' ||
                                                                        displayType ==
                                                                            'tablet')
                                                                        ? FTextStyle
                                                                        .filterHintTextStyleTab
                                                                        : FTextStyle
                                                                        .filterHintTextStyle,
                                                                    border:
                                                                    InputBorder.none,
                                                                    suffixIcon: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(20),
                                                                      child: Image(
                                                                        image: const AssetImage(
                                                                            'assets/Images/dropDown.png'),
                                                                        width: (displayType ==
                                                                            'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                            ? 16.h
                                                                            : 14,
                                                                        height: (displayType ==
                                                                            'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                            ? 8.h
                                                                            : 7,
                                                                        color: AppColors
                                                                            .filterDropDownColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  readOnly: true,
                                                                  controller:
                                                                  _dietTextEditingController,
                                                                  // Setting initial value
                                                                  style: (displayType ==
                                                                      'desktop' ||
                                                                      displayType ==
                                                                          'tablet')
                                                                      ? FTextStyle
                                                                      .cardSubtitleTab
                                                                      : FTextStyle
                                                                      .cardSubtitle,
                                                                  maxLines: 1,
                                                                  onTap: () {
                                                                    setState(() {
                                                                      isDropdownVisible3 =
                                                                      !isDropdownVisible3;
                                                                    });
                                                                  },
                                                                ).animateOnPageLoad(
                                                                    animationsMap[
                                                                    'imageOnPageLoadAnimation2']!),
                                                              ),
                                                              Visibility(
                                                                visible: isDropdownVisible3,
                                                                child: Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical: 20,
                                                                      horizontal: 35),
                                                                  margin:
                                                                  const EdgeInsets.only(
                                                                      bottom: 10),
                                                                  alignment:
                                                                  Alignment.center,
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    color: AppColors
                                                                        .lightGreyColor,
                                                                    borderRadius:
                                                                    BorderRadius.only(
                                                                      bottomLeft:
                                                                      Radius.circular(
                                                                          10),
                                                                      bottomRight:
                                                                      Radius.circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        children: dietNames
                                                                            .map(
                                                                                (dietName) {
                                                                              int index = dietNames
                                                                                  .indexOf(
                                                                                  dietName); // Get the index of the current diet
                                                                              bool isSelected =
                                                                              _selectedDietPreferences
                                                                                  .contains(
                                                                                  dietName); // Check if the diet is selected
                                                                              String dietId =
                                                                                  dietNameToIdMap[
                                                                                  dietName] ??
                                                                                      ''; // Fetch the corresponding diet ID

                                                                              return Column(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        onTap:
                                                                                            () {
                                                                                          setState(
                                                                                                  () {
                                                                                                if (!isSelected) {
                                                                                                  _selectedDietPreferences.add(dietName);
                                                                                                  selectedDietIds.add(dietId);
                                                                                                  // Print dietary ID only when checkbox is selected
                                                                                                  print('Diet Name Is: $dietName And Diet ID Is: $dietId');
                                                                                                } else {
                                                                                                  _selectedDietPreferences.remove(dietName);
                                                                                                  selectedDietIds.remove(dietId);
                                                                                                }
                                                                                                // Update TextEditingController with formatted preferences
                                                                                                _dietTextEditingController.text = _getFormattedPreferences(_selectedDietPreferences);
                                                                                              });
                                                                                        },
                                                                                        child:
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .only(
                                                                                              right: 8.0),
                                                                                          child:
                                                                                          Container(
                                                                                            width: (displayType == 'desktop' || displayType == 'tablet')
                                                                                                ? 24.h
                                                                                                : 24,
                                                                                            height: (displayType == 'desktop' || displayType == 'tablet')
                                                                                                ? 24.h
                                                                                                : 24,
                                                                                            decoration:
                                                                                            BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(3),
                                                                                              border: Border.all(
                                                                                                color: isSelected ? AppColors.primaryPinkColor : AppColors.boarderColour,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                              color: isSelected ? AppColors.primaryPinkColor : Colors.white,
                                                                                            ),
                                                                                            child: isSelected
                                                                                                ? Icon(
                                                                                              Icons.check_box,
                                                                                              color: Colors.white,
                                                                                              size: (displayType == 'desktop' || displayType == 'tablet') ? 24.h : 24,
                                                                                            )
                                                                                                : null,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child:
                                                                                        Text(
                                                                                          dietName,
                                                                                          maxLines:
                                                                                          3,
                                                                                          style: (displayType == 'desktop' || displayType == 'tablet')
                                                                                              ? FTextStyle.rememberMeTextStyleTab
                                                                                              : FTextStyle.rememberMeTextStyle,
                                                                                        ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  // Add divider conditionally except for the last item
                                                                                  if (index !=
                                                                                      dietNames
                                                                                          .length -
                                                                                          1)
                                                                                    const Padding(
                                                                                      padding: EdgeInsets.only(
                                                                                          top:
                                                                                          15,
                                                                                          bottom:
                                                                                          10),
                                                                                      child:
                                                                                      Divider(
                                                                                        color: AppColors
                                                                                            .darkGreyColor,
                                                                                        height:
                                                                                        0.5,
                                                                                      ),
                                                                                    ),
                                                                                ],
                                                                              );
                                                                            }).toList(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: 15,
                                                                    left: (displayType ==
                                                                        'desktop' ||
                                                                        displayType ==
                                                                            'tablet')
                                                                        ? 30.h
                                                                        : 0,
                                                                    right: (displayType ==
                                                                        'desktop' ||
                                                                        displayType ==
                                                                            'tablet')
                                                                        ? 30.h
                                                                        : 0),
                                                                child: Container(
                                                                  height: (displayType ==
                                                                      'desktop' ||
                                                                      displayType ==
                                                                          'tablet')
                                                                      ? 65
                                                                      : MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.06,
                                                                  width: (displayType ==
                                                                      'desktop' ||
                                                                      displayType ==
                                                                          'tablet')
                                                                      ? MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.650
                                                                      : MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.415,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(10),
                                                                      color: applyButtonEnabled
                                                                          ? Colors
                                                                          .transparent
                                                                          : AppColors
                                                                          .filterBackroundColor),
                                                                  child: ElevatedButton(
                                                                    onPressed:
                                                                    applyButtonEnabled
                                                                        ? () {
                                                                      print(selectedDietaryIds);
                                                                      print(selectedCuisineIds);
                                                                      print(selectedDietIds);
                                                                      BlocProvider.of<ProgramflowBloc>(
                                                                          context)
                                                                          .add(
                                                                        FetchRecipesEvent(
                                                                          dietaryIds:
                                                                          selectedDietaryIds,
                                                                          cuisineIds:
                                                                          selectedCuisineIds,
                                                                          dietIds:
                                                                          selectedDietIds, page: currentPage, limit: limit,
                                                                        ),
                                                                      );
                                                                      Navigator.of(context).pop();
                                                                    }
                                                                        : null,
                                                                    // Button is disabled initially
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      padding:
                                                                      EdgeInsets.zero,
                                                                      backgroundColor:
                                                                      applyButtonEnabled
                                                                          ? AppColors
                                                                          .filterBackroundColor
                                                                          : Colors
                                                                          .transparent,
                                                                      // Adjust color for disabled state
                                                                      minimumSize: Size(
                                                                        (displayType ==
                                                                            'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                            ? MediaQuery.of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.650
                                                                            : MediaQuery.of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.415,
                                                                        (displayType ==
                                                                            'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                            ? 65
                                                                            : MediaQuery.of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.06,
                                                                      ),
                                                                      shape:
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                      ),
                                                                    ),

                                                                    child: Center(
                                                                      child: Text(
                                                                        'Apply',
                                                                        style: (displayType ==
                                                                            'desktop' ||
                                                                            displayType ==
                                                                                'tablet')
                                                                            ? FTextStyle
                                                                            .filterTextStyley
                                                                            : FTextStyle
                                                                            .filterTextStyle,
                                                                      ).animateOnPageLoad(
                                                                          animationsMap[
                                                                          'imageOnPageLoadAnimation2']!),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))),
                                                )
                                              ]),
                                            )),
                                      ));
                                });
                          });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Image(
                          image: AssetImage('assets/Images/filterIcon.png')),
                    ).animateOnPageLoad(
                        animationsMap['imageOnPageLoadAnimation2']!),
                  )
                ],
              ),
            ),
            BlocListener<ProgramflowBloc, ProgramflowState>(
                listener: (context, state) {
                  if (state is RecipeLoading) {
                    setState(() {
                      isRecipeLoading = true;
                      _isLoading = true;
                    });
                  } else if (state is RecipeLoaded) {
                    setState(() {
                      recipeData = state.successResponse;
                      isRecipeLoading = false;
                      _isLoading = false;
                      if (currentPage == 1) {
                        allRecipes.clear();
                      }
                      allRecipes.addAll(recipeData);

                      // Ensure totalPages is updated from the API response
                      totalPages = state.pagination['totalPages'] ?? 0; // Default to 0 if not present
                      hasMoreData = currentPage < totalPages;
                    });
                  }
                  else if (state is RecipeError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${state.failureResponse['responseMessage']}')));
                    setState(() {
                      isRecipeLoading = false;
                      _isLoading = false;
                    });
                  } else if (state is CommonServerFailure) {
                    setState(() {
                      isRecipeLoading = false;
                      _isLoading = false;
                    });
                  } else if (state is CheckNetworkConnection) {
                    setState(() {
                      isRecipeLoading = false;
                      _isLoading = false;
                    });
                  }
                  if (state is FilterRecipeLoading) {
                    setState(() {
                      isFilterRecipeLoading = true;
                    });
                  }
                  if (state is FilterRecipeLoaded) {
                    setState(() {
                      dietaryNames = state.allDietary;
                      dietaryIds = state.dietaryIds;
                      dietNames = state.allDiets;
                      dietIds = state.dietIds;
                      cuisineNames = state.allCuisines;
                      cuisineIds = state.cuisineIds;

                      // Populate the dietaryNameToIdMap
                      dietaryNameToIdMap =
                          Map.fromIterables(dietaryNames, dietaryIds);
                      // Populate the dietaryNameToIdMap
                      cuisineNameToIdMap =
                          Map.fromIterables(cuisineNames, cuisineIds);
                      // Populate the dietaryNameToIdMap
                      dietNameToIdMap = Map.fromIterables(dietNames, dietIds);
                      isFilterRecipeLoading = false;
                    });
                  } else if (state is FilterRecipeError) {
                    setState(() {
                      isFilterRecipeLoading = false;
                    });
                  }
                },
                child: isRecipeLoading && allRecipes.isEmpty
                    ? const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.pink)))
                    : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: hasMoreData
                        ? allRecipes.length + 1
                        : allRecipes.length,
                    itemBuilder: (context, index) {
                      if (index == allRecipes.length) {
                        return Center(child: CircularProgressIndicator(color: AppColors.pink));
                      }
                      final recipeTypeData = allRecipes[index]
                      as Map<String, dynamic>? ??
                          {};

                      final String recipeType =
                      recipeTypeData['typeDetails']['recipeType'];
                      final List<dynamic> recipes = recipeTypeData['recipes'];

                      // Filter recipes to include only those with ACTIVE status
                      final activeRecipes = recipes.where((recipe) => recipe['status'] == 'ACTIVE').toList();

                      // Check if there are active recipes to display
                      if (activeRecipes.isEmpty) {
                        Center(child: Image.asset('assets/Images/nodata.jpg'));
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: (displayType == 'desktop' || displayType == 'tablet')
                                    ? 30.h
                                    : 18,
                                top: (displayType == 'desktop' || displayType == 'tablet')
                                    ? 16.h
                                    : 14,
                              ),
                              child: Text(
                                recipeType,
                                style: (displayType == 'desktop' || displayType == 'tablet')
                                    ? FTextStyle.recipeHeadingTextStyleTab
                                    : FTextStyle.recipeHeadingTextStyle,
                              ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation2']!),
                            ),
                            SizedBox(height: 8.0),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: activeRecipes.map<Widget>((recipe) {
                                  final String recipeName = recipe['recipeName'];
                                  final String recipeThumbnailImage = recipe['recipeThumbnailImage'];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        final recipeID = recipe['_id'];
                                        final preparationTime = recipe['preparationTime'];
                                        final servings = recipe['servings'];
                                        final ingredientDetails = recipe['ingredientDetails'];
                                        final notes = recipe['notes'];
                                        final nutrition = recipe['nutrition'];
                                        final recipeType = recipe['recipeType'];

                                        // Convert steps to List<String> if necessary
                                        final stepsList = List<String>.from(recipe['steps']);
                                        PrefUtils.setitemId(recipeID);
                                        print('Selected Recipe ID Is :${PrefUtils.getitemId()}');

                                        // Convert nutrition to Map<String, dynamic> if it's a map, or handle as list if needed
                                        dynamic nutritionData;
                                        if (nutrition is Map) {
                                          nutritionData = Map<String, dynamic>.from(nutrition);
                                        } else if (nutrition is List) {
                                          nutritionData = List<Map<String, dynamic>>.from(nutrition);
                                        }

                                        // Handling recipeType: Extract the first element if it is a list
                                        String recipeTypeString;
                                        if (recipeType is List && recipeType.isNotEmpty) {
                                          recipeTypeString = recipeType[0].toString(); // Convert first element to string
                                        } else {
                                          recipeTypeString = recipeType.toString(); // Fallback to toString()
                                        }
                                        // Navigate to the RecipesDescription page
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
                                                steps: stepsList,
                                                nutrition: nutritionData,
                                                recipeType: recipeTypeString,
                                              ),
                                            ),
                                          ),
                                        );
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
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                              color: Colors.white,
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
                                                      alignment: Alignment.center, // This centers the checkmark inside the stack
                                                      children: [
                                                        recipeThumbnailImage.isNotEmpty
                                                            ? Image.network(
                                                          recipeThumbnailImage,
                                                          height: (displayType == 'desktop' || displayType == 'tablet')
                                                              ? MediaQuery.of(context).size.width * 0.13 - 10
                                                              : MediaQuery.of(context).size.height * 0.13 - 10,
                                                          width: double.infinity,
                                                          fit: BoxFit.cover,
                                                        )
                                                            : Container(
                                                          height: (displayType == 'desktop' || displayType == 'tablet')
                                                              ? MediaQuery.of(context).size.width * 0.13 - 10
                                                              : MediaQuery.of(context).size.height * 0.13 - 10,
                                                          width: double.infinity,
                                                          color: Colors.grey[200],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.image,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ),
                                                        if (recipe["isCompleted"]) // Conditionally show the checkmark
                                                          Image.asset("assets/Images/check.png"),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
                                                  child: Text(
                                                    recipeName,
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
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
            )
          ],
        ));
  }
}

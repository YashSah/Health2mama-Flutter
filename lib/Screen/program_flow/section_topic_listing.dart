import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Screen/program_flow/sub_data_screen.dart';
import 'package:health2mama/Screen/program_flow/topic_description.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';
import 'package:health2mama/Utils/flutter_font_style.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:health2mama/apis/program_flow/programflow_bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';
import '../../Utils/CommonFuction.dart';

class SectionTopicListing extends StatefulWidget {
  final String categoryName;

  const SectionTopicListing({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<SectionTopicListing> createState() => _SectionTopicListingState();
}

class _SectionTopicListingState extends State<SectionTopicListing> {
  List<dynamic> programs = [];
  List<Map<String, dynamic>> percentages = [];
  bool isProgramsLoading = false;
  bool isPercentagesLoading = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProgramflowBloc>(context)
        .add(FetchProgramEvent(PrefUtils.getCategoryId()));
    BlocProvider.of<ProgramflowBloc>(context)
        .add(FetchProgramPercentageEvent(PrefUtils.getCategoryId()));
  }

  // Method to get the percentage for a given programId
  double getPercentageForProgram(String programId) {
    final percentageData = percentages.firstWhere(
      (element) => element['programId'] == programId,
      orElse: () => {'percentage': '0'}, // Default to 0 if not found
    );
    return double.parse(percentageData['percentage']) /
        100; // Convert to double
  }

  @override
  Widget build(BuildContext context) {
    final valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    final displayType = valueType.toString().split('.').last;
    print('displayType>> $displayType');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.categoryName, style: FTextStyle.appTitleStyle),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'assets/Images/iconBack.png',
            width: (displayType == 'desktop' || displayType == 'tablet')
                ? 24.w
                : 35,
            height: (displayType == 'desktop' || displayType == 'tablet')
                ? 24.h
                : 35,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Divider(
                thickness: MediaQuery.of(context).size.height * 0.0015,
                color: const Color(0XFFF6F6F6),
              ),
            ),
            Expanded(
              child: BlocListener<ProgramflowBloc, ProgramflowState>(
                listener: (context, state) {
                  if (state is ProgramflowLoading) {
                    setState(() {
                      isProgramsLoading = true;
                    });
                  } else if (state is ProgramflowLoaded) {
                    setState(() {
                      // Filter programs to only include those with status 'ACTIVE'
                      programs = state.programs
                          .where((program) => program['status'] == 'ACTIVE')
                          .toList();
                      isProgramsLoading = false;
                    });
                  } else if (state is ProgramflowError ||
                      state is CommonServerFailure ||
                      state is CheckNetworkConnection) {
                    setState(() {
                      isProgramsLoading = false;
                    });
                  }

                  if (state is ProgramPercentageLoading) {
                    setState(() {
                      isPercentagesLoading = true;
                    });
                  } else if (state is ProgramPercentageLoaded) {
                    setState(() {
                      percentages = state.percentages;
                      isPercentagesLoading = false;
                    });
                  } else if (state is ProgramPercentageError) {
                    setState(() {
                      isPercentagesLoading = false;
                    });
                  }
                },
                child: isProgramsLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.pink))
                    : programs.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: displayType == "mobile"
                                ? GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: programs.length,
                              itemBuilder: (context, index) {
                                final program = programs[index] as Map<String, dynamic>?;
                                if (program == null) {
                                  return SizedBox.shrink();
                                }
                                final programName = program['programName'] as String? ?? 'No Name';
                                final programImage = program['programThumbnailImage'] as String? ?? '';
                                final programId = program['_id'] as String? ?? '';
                                final contentDetails = program['contentDetails'] ?? '';

                                // Fetch the percentage for this program
                                final percentageValue = getPercentageForProgram(programId);

                                // Check if the percentage is 100%
                                final isCompleted = (percentageValue * 100).toInt() == 100;

                                return InkWell(
                                  onTap: () {
                                    // Set the program ID
                                    PrefUtils.setitemId(programId);
                                    print(PrefUtils.getitemId());
                                    // Determine the screen to navigate to based on contentDetails
                                    if (contentDetails.isNotEmpty) {
                                      // Navigate to `TopicDescription` if `contentDetails` is not empty
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TopicDescription(
                                            contentDetails: contentDetails,
                                            topicName: programName, // Pass additional values if required
                                            topicImage: programImage, // Pass additional values if required
                                          ),
                                        ),
                                      ).then((result) {
                                        // Handle navigation result if the screen returns something
                                        if (result != null &&
                                            result is List &&
                                            result.isNotEmpty &&
                                            result[0] == true) {
                                          // Dispatch events to the ProgramflowBloc to refresh the data
                                          BlocProvider.of<ProgramflowBloc>(context)
                                              .add(FetchProgramEvent(PrefUtils.getCategoryId()));
                                          BlocProvider.of<ProgramflowBloc>(context)
                                              .add(FetchProgramPercentageEvent(PrefUtils.getCategoryId()));
                                        }
                                      }).catchError((error) {
                                        // Handle any errors during navigation gracefully
                                        print("Navigation error: $error");
                                      });
                                    } else {
                                      // Navigate to `SubDataScreen` if `contentDetails` is empty
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => ProgramflowBloc(),
                                            child: SubDataScreen(
                                              programName: programName,
                                              programId: PrefUtils.getitemId(),
                                            ),
                                          ),
                                        ),
                                      ).then((result) {
                                        // Handle navigation result if the screen returns something
                                        if (result != null &&
                                            result is List &&
                                            result.isNotEmpty &&
                                            result[0] == true) {
                                          // Dispatch events to the ProgramflowBloc to refresh the data
                                          BlocProvider.of<ProgramflowBloc>(context)
                                              .add(FetchProgramEvent(PrefUtils.getCategoryId()));
                                          BlocProvider.of<ProgramflowBloc>(context)
                                              .add(FetchProgramPercentageEvent(PrefUtils.getCategoryId()));
                                        }
                                      }).catchError((error) {
                                        // Handle any errors during navigation gracefully
                                        print("Navigation error: $error");
                                      });
                                    }
                                  },
                                  child: Card(
                                    elevation: 2,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    color: Colors.white,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            child: Image.network(
                                              programImage,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context).size.height * 0.1,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Icon(Icons.error),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 5.0),
                                            child: Column(
                                              children: [
                                                LinearProgressIndicator(
                                                  borderRadius: BorderRadius.circular(10),
                                                  value: percentageValue, // Use the fetched percentage value
                                                  backgroundColor: Colors.grey[300],
                                                  color: const Color.fromRGBO(225, 84, 153, 1),
                                                  minHeight: 5.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // Left side: dynamically update percentage label
                                                    Text(
                                                      '${(percentageValue * 100).toInt()}%', // Show percentage on the left side
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    // Right side: keep 100% static
                                                    const Text(
                                                      '100%',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10),
                                            child: Text(
                                              programName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: (displayType == 'desktop' || displayType == 'tablet')
                                                  ? FTextStyle.programsGridStyleTab
                                                  : FTextStyle.programsGridStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                                : GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 3
                                              : 2,
                                      crossAxisSpacing:
                                          (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 2.h
                                              : 2,
                                      mainAxisSpacing:
                                          (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 16.h
                                              : 16,
                                      childAspectRatio:
                                          (displayType == 'desktop' ||
                                                  displayType == 'tablet')
                                              ? 1.2
                                              : 1,
                                    ),
                                    itemCount: programs.length,
                                    itemBuilder: (context, index) {
                                      final program = programs[index]
                                          as Map<String, dynamic>?;
                                      if (program == null) {
                                        return SizedBox.shrink();
                                      }
                                      final programName =
                                          program['programName'] as String? ??
                                              'No Name';
                                      final programImage =
                                          program['programThumbnailImage']
                                                  as String? ??
                                              '';
                                      final programId =
                                          program['_id'] as String? ?? '';
                                      final contentDetails =
                                          program['contentDetails'] ?? '';

                                      // Fetch the percentage for this program
                                      final percentageValue =
                                          getPercentageForProgram(programId);
                                      final isCompleted = (percentageValue * 100).toInt() == 100;

                                      return InkWell(
                                        onTap: () {
                                          // Set the program ID
                                          PrefUtils.setitemId(programId);
                                          print(PrefUtils.getitemId());
                                          // Determine the screen to navigate to based on contentDetails
                                          if (contentDetails.isNotEmpty) {
                                            // Navigate to `TopicDescription` if `contentDetails` is not empty
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TopicDescription(
                                                  contentDetails:
                                                      contentDetails,
                                                  topicName:
                                                      programName, // Pass additional values if required
                                                  topicImage:
                                                      programImage, // Pass additional values if required
                                                ),
                                              ),
                                            ).then((result) {
                                              // Handle navigation result if the screen returns something
                                              if (result != null &&
                                                  result is List &&
                                                  result.isNotEmpty &&
                                                  result[0] == true) {
                                                // Dispatch events to the ProgramflowBloc to refresh the data
                                                BlocProvider.of<
                                                            ProgramflowBloc>(
                                                        context)
                                                    .add(FetchProgramEvent(
                                                        PrefUtils
                                                            .getCategoryId()));
                                                BlocProvider.of<
                                                            ProgramflowBloc>(
                                                        context)
                                                    .add(FetchProgramPercentageEvent(
                                                        PrefUtils
                                                            .getCategoryId()));
                                              }
                                            }).catchError((error) {
                                              // Handle any errors during navigation gracefully
                                              print("Navigation error: $error");
                                            });
                                          } else {
                                            // Navigate to `SubDataScreen` if `contentDetails` is empty
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                  create: (context) =>
                                                      ProgramflowBloc(),
                                                  child: SubDataScreen(
                                                    programName: programName,
                                                    programId:
                                                        PrefUtils.getitemId(),
                                                  ),
                                                ),
                                              ),
                                            ).catchError((error) {
                                              // Handle any errors during navigation gracefully
                                              print("Navigation error: $error");
                                            });
                                          }
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
                                            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),),color: isCompleted ? AppColors.appBlue1 : Colors.white),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                  child: Image.network(
                                                    programImage,
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(Icons.error),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 5.0),
                                                  child: Column(
                                                    children: [
                                                      LinearProgressIndicator(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        value:
                                                            percentageValue, // Use the fetched percentage value
                                                        backgroundColor:
                                                            Colors.grey[300],
                                                        color: const Color
                                                            .fromRGBO(
                                                            225, 84, 153, 1),
                                                        minHeight: 5.0,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // Left side: dynamically update percentage label
                                                          Text(
                                                            '${(percentageValue * 100).toInt()}%', // Show percentage on the left side
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          // Right side: keep 100% static
                                                          const Text(
                                                            '100%',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Text(
                                                    programName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: (displayType ==
                                                                'desktop' ||
                                                            displayType ==
                                                                'tablet')
                                                        ? FTextStyle
                                                            .programsGridStyleTab
                                                        : FTextStyle
                                                            .programsGridStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )
                        : Center(
                            child: Image.asset('assets/Images/nodata.jpg'),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

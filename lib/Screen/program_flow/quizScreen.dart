import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Model/quiz_question.dart';
import '../../Utils/flutter_colour_theams.dart';
import '../../Utils/flutter_font_style.dart';
import '../../apis/drawer/drawer_bloc.dart';
import '../../apis/program_flow/programflow_bloc.dart';
import '../../apis/program_flow/programflow_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Map to store selected answers by question id
  Map<String, String> selectedAnswers = {};
  bool isQuizSubmitted = false;

  @override
  void initState() {
    super.initState();
    // Trigger the event to fetch quiz questions only once
    BlocProvider.of<ProgramflowBloc>(context).add(FetchQuizEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreyColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Core Program Quiz",
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
      body: BlocBuilder<ProgramflowBloc, ProgramflowState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return Center(child: CircularProgressIndicator());
          }
          else if (state is QuizLoaded) {
            final List<QuizQuestion> quizQuestions = state.quizQuestions;

            return ListView.builder(
              itemCount: quizQuestions.length,
              itemBuilder: (context, index) {
                final question = quizQuestions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the serial number and question
                          Text(
                            '${index + 1}. ${question.question}',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(height: 12.h),
                          Column(
                            children: question.options.map((option) {
                              return RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: selectedAnswers[question.id],
                                onChanged: (value) {
                                  setState(() {
                                    // Update the selected answer for this question
                                    selectedAnswers[question.id] = value!;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          else if (state is QuizError) {
            return Center(child: Text("Failed to load quiz. Please try again."));
          }
          else {
            return Center(child: Text("No quiz available."));
          }
        },
      ),

      // Add the submit button and disable it if any question is not answered
      floatingActionButton: Container(
        width: 100.w, // Set a width if needed
        height: 50.h, // Set height
        child: ElevatedButton(
          onPressed: _canSubmit() ? _submitQuiz : null, // Disable if not all questions are answered
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pinkButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Submit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  // Check if all questions have been answered
  bool _canSubmit() {
    // Check if the current state is QuizLoaded
    if (BlocProvider.of<ProgramflowBloc>(context).state is QuizLoaded) {
      // Access the quizQuestions from the QuizLoaded state
      final quizQuestions = (BlocProvider.of<ProgramflowBloc>(context).state as QuizLoaded).quizQuestions;
      return selectedAnswers.length == quizQuestions.length;
    }
    // If the state is not QuizLoaded, return false
    return false;
  }

  void _submitQuiz() async {
    // Print selected answers for debugging
    selectedAnswers.forEach((questionId, selectedOption) {
      print("Question ID: $questionId, Selected Answer: $selectedOption");
    });

    // Determine coreProgramOpted based on selected answers
    String coreProgramOpted;
    if (selectedAnswers.values.any((answer) => answer.toLowerCase() == "yes")) {
      coreProgramOpted = "YES"; // Set "YES" if any answer is "Yes"
    } else {
      coreProgramOpted = "NO"; // Set "NO" if no answers are "Yes"
    }

    // Update the state to indicate quiz has been submitted
    setState(() {
      isQuizSubmitted = true;
    });

    // Dispatch event to update profile
    BlocProvider.of<DrawerBloc>(context).add(UpdateUserProfileRequested(
      coreProgramOpted: coreProgramOpted, // Set coreProgramOpted to YES or NO
    ));

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Quiz submitted successfully!")),);

    // Optionally, navigate back or show a confirmation
    Navigator.pop(context,[true]);
  }

}

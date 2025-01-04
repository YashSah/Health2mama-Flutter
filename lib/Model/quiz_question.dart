import 'package:flutter/material.dart';

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  // Factory method to create an instance of QuizQuestion from a JSON map
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['_id'],
      question: json['question'],
      options: List<String>.from(json['options']),
    );
  }
}

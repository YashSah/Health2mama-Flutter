part of 'forums_bloc.dart';

@immutable
sealed class ForumsState {}

final class ForumsInitial extends ForumsState {}

// Get All Forums API
class ForumsLoading extends ForumsState {}

class ForumsLoaded extends ForumsState {
  final List<dynamic> docs;
  final int totalDocs;
  final int totalPages;
  final int currentPage;
  final bool hasNextPage;

  ForumsLoaded({
    required this.docs,
    required this.totalDocs,
    required this.totalPages,
    required this.currentPage,
    required this.hasNextPage,
  });
}


class ForumsError extends ForumsState {
  Map<String,dynamic> failureResponse;
  ForumsError(this.failureResponse);
}

// Create Forum POST API

class CreateForumsLoading extends ForumsState {}

class CreateForumsLoaded extends ForumsState {
  Map<String,dynamic> successResponse;
  CreateForumsLoaded(this.successResponse);
}

class CreateForumsError extends ForumsState {
  Map<String,dynamic> failureResponse;
  CreateForumsError(this.failureResponse);
}


// View Forum GET API

class ViewForumsLoading extends ForumsState {}

class ViewForumsLoaded extends ForumsState {
  Map<String,dynamic> successResponse;
  ViewForumsLoaded(this.successResponse);
}

class ViewForumsError extends ForumsState {
  Map<String,dynamic> failureResponse;
  ViewForumsError(this.failureResponse);
}


// User Reply To Forum POST API

class ReplyToForumsLoading extends ForumsState {}

class ReplyToForumsLoaded extends ForumsState {
  Map<String,dynamic> successResponse;
  ReplyToForumsLoaded(this.successResponse);
}

class ReplyToForumsError extends ForumsState {
  Map<String,dynamic> failureResponse;
  ReplyToForumsError(this.failureResponse);
}


// Fetch Existing Topic GET API

class ExistingTopicLoading extends ForumsState {}

// Success state with list of topics
class ExistingTopicLoaded extends ForumsState {
  final List<dynamic> topics;
  ExistingTopicLoaded(this.topics);
}

// Error state
class ExistingTopicError extends ForumsState {
  final String message;
  ExistingTopicError(this.message);
}




class CommonServerFailure extends ForumsState {
  final String error;
  CommonServerFailure(this.error);

}
class CheckNetworkConnection extends ForumsState {
}
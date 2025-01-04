part of 'forums_bloc.dart';

@immutable
sealed class ForumsEvent {}

// Get All Forum With Search API
class FetchForums extends ForumsEvent {
  final String? searchQuery;
  final int? page;
  final int? limit;
  FetchForums({this.searchQuery,this.page,this.limit});
}

// Create Forum POST API
class CreateForumEvent extends ForumsEvent {
  final String title;
  final String description;
  CreateForumEvent({required this.title, required this.description});
}

// View Forum GET API
class ViewForumEvent extends ForumsEvent {
  final String forumId;  // Include forumId to fetch specific forum details
  ViewForumEvent(this.forumId);
}

// User Reply POST API
class UserReplyEvent extends ForumsEvent {
  final String forumId;
  final String message;

  UserReplyEvent({required this.forumId, required this.message});
}

// Fetch Existing Topics
class FetchExistingTopics extends ForumsEvent {}
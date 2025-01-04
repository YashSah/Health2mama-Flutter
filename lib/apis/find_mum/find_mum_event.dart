part of 'find_mum_bloc.dart';

@immutable
sealed class FindMumEvent {}

class FetchDropdownOptions extends FindMumEvent {
  FetchDropdownOptions();
}

class FindAFriend extends FindMumEvent {
  final List<String> Other;
  final List<String> Interest;
  final List<String> Exercise;
  final List<String> Language;
  final String Age;
  final String areYou;
  final int page;
  final int limit;
  final int? maxDistance; // Optional parameter
  final double? latitude; // Optional parameter
  final double? longitude; // Optional parameter

  FindAFriend({
    required this.Other,
    required this.Interest,
    required this.Exercise,
    required this.Language,
    required this.Age,
    required this.areYou,
    required this.page,
    required this.limit,
    this.maxDistance, // Optional parameter
    this.latitude,
    this.longitude,
  });
}

class getConnectedMums extends FindMumEvent {
  final int page;
  final int limit;
  final int? maxDistance; // Optional parameter
  final double? latitude; // Optional parameter
  final double? longitude; // Optional parameter
  getConnectedMums({
    required this.page,
    required this.limit,
    this.maxDistance, // Optional parameter
    this.latitude,
    this.longitude,
  });
}

class ConnectMums extends FindMumEvent {
  final String receiverId;
  ConnectMums({required this.receiverId});
}

class CancelMumRequest extends FindMumEvent {
  final String requestId;
  CancelMumRequest({required this.requestId});
}


class FetchPendingRequests extends FindMumEvent {
  final int page;
  final int limit;

  FetchPendingRequests({required this.page, required this.limit});
}

class AcceptMumRequest extends FindMumEvent {
  final String requestId;
  final String status;
  AcceptMumRequest({required this.requestId, required this.status});
}

class CreateNotification extends FindMumEvent {
  final String? senderId; // Make senderId optional
  final String receiverId;
  final String message;
  final String title;

  CreateNotification({
    this.senderId, // Optional parameter
    required this.receiverId,
    required this.message,
    required this.title,
  });
}

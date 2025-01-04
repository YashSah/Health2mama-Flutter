part of 'find_mum_bloc.dart';

sealed class FindMumState {}

class FindMumInitial extends FindMumState {}

class DropdownLoading extends FindMumState {}

class DropdownLoaded extends FindMumState {
  Map<String, dynamic> result;
  DropdownLoaded(this.result);
}

class DropdownError extends FindMumState {
  Map<String, dynamic> responseMessage;
  DropdownError(this.responseMessage);
}

class findAFriendLoading extends FindMumState {}

class findAFriendLoaded extends FindMumState {
  final List<Map<String, dynamic>> docs;
  final bool hasMoreData;
  final int totalPages;

  findAFriendLoaded(
    this.docs, {
    this.hasMoreData = true,
    required this.totalPages,
  });
}

class findAFriendError extends FindMumState {
  String responseMessage;
  findAFriendError(this.responseMessage);
}

class getConnectedMumsLoading extends FindMumState {}

class getConnectedMumsLoaded extends FindMumState {
  final List<Map<String, dynamic>> docs;
  final bool hasMoreData;
  final int totalPages;

  getConnectedMumsLoaded(
    this.docs, {
    this.hasMoreData = true,
    required this.totalPages,
  });
}

class getConnectedMumsError extends FindMumState {
  String responseMessage;
  getConnectedMumsError(this.responseMessage);
}

class ConnectMumsLoading extends FindMumState {}

class ConnectMumsLoaded extends FindMumState {
  Map<String, dynamic> responseMessage;
  ConnectMumsLoaded(this.responseMessage);
}

class ConnectMumsError extends FindMumState {
  Map<String, dynamic> responseMessage;
  ConnectMumsError(this.responseMessage);
}

class CancelMumRequestLoading extends FindMumState {}

class CancelMumRequestLoaded extends FindMumState {
  Map<String, dynamic> responseMessage;
  CancelMumRequestLoaded(this.responseMessage);
}

class CancelMumRequestError extends FindMumState {
  Map<String, dynamic> responseMessage;
  CancelMumRequestError(this.responseMessage);
}


class FetchPendingRequestsLoading extends FindMumState {}

class FetchPendingRequestsLoaded extends FindMumState {
  final List<dynamic> requests;
  final int totalPages;

  FetchPendingRequestsLoaded(this.requests, this.totalPages);
}

class FetchPendingRequestsError extends FindMumState {
  final String errorMessage;

  FetchPendingRequestsError(this.errorMessage);
}


class AcceptMumRequestLoading extends FindMumState {}

class AcceptMumRequestLoaded extends FindMumState {
  Map<String, dynamic> responseMessage;
  AcceptMumRequestLoaded(this.responseMessage);
}

class AcceptMumRequestError extends FindMumState {
  Map<String, dynamic> responseMessage;
  AcceptMumRequestError(this.responseMessage);
}

class CreateNotificationLoading extends FindMumState {}

class CreateNotificationLoaded extends FindMumState {
  Map<String, dynamic> responseMessage;
  CreateNotificationLoaded(this.responseMessage);
}

class CreateNotificationError extends FindMumState {
  Map<String, dynamic> responseMessage;
  CreateNotificationError(this.responseMessage);
}
part of 'find_bloc.dart';


sealed class FindState {}

class DropdownInitial extends FindState {}

class DropdownLoading extends FindState {}

class DropdownLoaded extends FindState {
  final List<Doc> options;
  DropdownLoaded(this.options);
}

class SpecialistDropdownLoading extends FindState {}

class SpecialistDropdownLoaded extends FindState {
  final List<Doc> specialists;

  SpecialistDropdownLoaded(this.specialists);
}

class SpecialistDropdownError extends FindState {
  final String message;
  SpecialistDropdownError(this.message);
}


class DropdownError extends FindState {
  final String message;
  DropdownError(this.message);
}


class SearchLoading extends FindState {}

class SearchLoaded extends FindState {
  List<Map<String, dynamic>> results;
  SearchLoaded(this.results);
}

class SearchError extends FindState {
  final String message;
  SearchError(this.message);
}

class ViewConsultLoading extends FindState {}

class ViewConsultLoaded extends FindState {
  final Map<String, dynamic> consultData;
  ViewConsultLoaded(this.consultData);
}

class ViewConsultError extends FindState {
  final String message;
  ViewConsultError(this.message);
}

class PurchaseLoading extends FindState {}

class PurchaseSuccess extends FindState {}

class PurchaseFailure extends FindState {
  final String error;
  PurchaseFailure(this.error);
}
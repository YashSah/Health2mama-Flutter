part of 'find_bloc.dart';


sealed class FindEvent {}

class FetchDropdownOptions extends FindEvent {
  final String type;
  final String status;
  FetchDropdownOptions(this.type, this.status);
}

class FetchSpecializations extends FindEvent {
  final String serviceId;

  FetchSpecializations(this.serviceId);
}


class SearchQuery extends FindEvent {
  final List<String> services;
  final List<String> specialisations;

  SearchQuery({required this.services, required this.specialisations});
}


class SearchQuery1 extends FindEvent {
  final List<String> services;
  final List<String> specialisations;
  final int maxDistance;
  final String latitude;
  final String longitude;

  SearchQuery1({required this.services, required this.specialisations, required this.maxDistance, required this.latitude, required this.longitude});
}



class ViewConsult extends FindEvent {
  final String consultId;
  ViewConsult({required this.consultId});
}

class MakePurchaseEvent extends FindEvent {
  final String consultId;
  final String user;
  final String? selectedPlan; // Can be null if a package is selected
  final String amount;
  final String date;
  final String time;
  final String status;

  MakePurchaseEvent({
    required this.consultId,
    required this.user,
    this.selectedPlan,
    required this.amount,
    required this.date,
    required this.time,
    required this.status
  });
}
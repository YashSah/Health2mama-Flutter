import 'package:bloc/bloc.dart';
import 'package:health2mama/ModelClass/find_model.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

part 'find_event.dart';
part 'find_state.dart';

class FindBloc extends Bloc<FindEvent, FindState> {
  FindBloc() : super(DropdownInitial()) {
    on<FetchDropdownOptions>(_onFetchDropdownOptions);
    on<FetchSpecializations>(_onFetchSpecializations);
    on<SearchQuery>(_onSearchQuery);
    on<ViewConsult>(_onViewConsults);
    on<MakePurchaseEvent>(_onMakePurchase);
    on<SearchQuery1>(_onSearchQuery1); // Ensure this matches the event type
  }

  Future<void> _onFetchDropdownOptions(
    FetchDropdownOptions event,
    Emitter<FindState> emit,
  ) async {
    emit(DropdownLoading());
    try {
      final response = await http.get(
        Uri.parse(
            '${APIEndPoints.getServiceSpecialization}?type=${event.type}'),
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> docsJson = data['result']['docs'];
        List<Doc> docs = docsJson.map((item) => Doc.fromJson(item)).toList();

        if (event.type == 'SERVICE') {
          emit(DropdownLoaded(docs));
        } else if (event.type == 'SPECIALIZATION') {
          emit(SpecialistDropdownLoaded(docs));
        }
      } else {
        emit(DropdownError('Failed to load options'));
      }
    } catch (e) {
      emit(DropdownError('Failed to load options'));
    }
  }


  Future<void> _onFetchSpecializations(
      FetchSpecializations event,
      Emitter<FindState> emit,
      ) async {
    emit(SpecialistDropdownLoading());
    try {
      final response = await http.get(
        Uri.parse('${APIEndPoints.listSpecialization}?serviceId=${event.serviceId}'),
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );

      if (response.statusCode == 200) {
        print("Successfull!!!!!!!!");
        final data = json.decode(response.body);

        List<dynamic> specializationsJson = data['result']['docs'];
        print(specializationsJson);
        List<Doc> specializations = specializationsJson
            .map((item) => Doc.fromJson(item))
            .toList();

        emit(SpecialistDropdownLoaded(specializations));
      } else {
        emit(SpecialistDropdownError('Failed to load specializations'));
      }
    } catch (e) {
      emit(SpecialistDropdownError('An error occurred: $e'));
    }
  }



  Future<void> _onSearchQuery(
      SearchQuery event,
      Emitter<FindState> emit,
      ) async {
    emit(SearchLoading());
    try {
      // Convert services into array format (without [])
      final servicesQuery = event.services.isNotEmpty
          ? 'services=${Uri.encodeComponent(event.services.join(","))}'
          : '';

      // Convert specialisations (IDs) into the correct query format
      final specialisationsQuery = event.specialisations.isNotEmpty
          ? event.specialisations.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value.trim();
        return 'specialisations%5B$index%5D=${Uri.encodeComponent(value)}';
      }).join('&')
          : '';

      // Combine queries into a final URL
      final queryParams = <String>[];
      if (servicesQuery.isNotEmpty) queryParams.add(servicesQuery);
      if (specialisationsQuery.isNotEmpty) queryParams.add(specialisationsQuery);

      final url = Uri.parse('${APIEndPoints.searchConsults}?${queryParams.join('&')}');

      print('URL: $url');

      final response = await http.get(
        url,
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['result'] is List) {
          List<dynamic> resultsJson = data['result'];
          List<Map<String, dynamic>> results =
          resultsJson.cast<Map<String, dynamic>>();
          emit(SearchLoaded(results));
        } else {
          emit(SearchError(data['responseMessage']));
        }
      } else {
        print('Error response: ${response.body}');
        emit(SearchError(data['responseMessage']));
      }
    } catch (e) {
      print('Exception: $e');
      emit(SearchError("No Data Found"));
    }
  }




  Future<void> _onViewConsults(
    ViewConsult event,
    Emitter<FindState> emit,
  ) async {
    emit(ViewConsultLoading());
    try {
      final url = Uri.parse(
          '${APIEndPoints.viewConsult}?consultId=${Uri.encodeComponent(event.consultId)}');
      final response = await http.get(
        url,
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['result'] is Map) {
          Map<String, dynamic> consultData = data['result'];
          print('Consult Data: $consultData');
          emit(ViewConsultLoaded(
              consultData)); // Emit with single consult object
        } else {
          emit(ViewConsultError(data['responseMessage']));
        }
      } else {
        print('Error response: ${response.body}');
        emit(ViewConsultError(data['responseMessage']));
      }
    } catch (e) {
      print('Exception: $e');
      emit(ViewConsultError("No Data Found"));
    }
  }

  Future<void> _onMakePurchase(
    MakePurchaseEvent event,
    Emitter<FindState> emit,
  ) async {
    emit(PurchaseLoading());
    try {
      final url = Uri.parse('${APIEndPoints.createBooking}');
      final body = jsonEncode({
        'consult': event.consultId,
        'plan': event.selectedPlan ?? '',
        'user': event.user,
        'amount': event.amount,
        'date': event.date,
        'time': event.time,
        'status': 'ACTIVE',
      });

      print("url>>>> $url");
      print("body>>>> $body");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': PrefUtils.getUserLoginToken(),
        },
        body: body,
      );

      if (response.statusCode == 200) {
        emit(PurchaseSuccess());
        final data = json.decode(response.body);
        print(data['responseMessage']);
      } else {
        final data = json.decode(response.body);
        emit(PurchaseFailure(
            data['responseMessage'] ?? 'Failed to make purchase'));
        print('Error ${response.statusCode}: ${data['responseMessage']}');
      }
    } catch (e) {
      emit(PurchaseFailure('An error occurred: $e'));
      print(e);
    }
  }

  Future<void> _onSearchQuery1(SearchQuery1 event, Emitter<FindState> emit) async {
    emit(SearchLoading());
    try {
      // Convert services and specialisations into array format without []
      final servicesQuery = event.services.isNotEmpty
          ? 'services=${Uri.encodeComponent(event.services.join(","))}'
          : '';

      final specialisationsQuery = event.specialisations.isNotEmpty
          ? event.specialisations.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value.trim();
        return 'specialisations%5B$index%5D=${Uri.encodeComponent(value)}';
      }).join('&')
          : '';

      final latitudeQuery = event.latitude != null
          ? 'latitude=${Uri.encodeComponent(event.latitude.toString())}'
          : '';

      final longitudeQuery = event.longitude != null
          ? 'longitude=${Uri.encodeComponent(event.longitude.toString())}'
          : '';

      final maxDistanceQuery = event.maxDistance != null
          ? 'maxDistance=${Uri.encodeComponent(event.maxDistance.toString())}'
          : '';

      // Combine queries into a final URL
      final queryParams = <String>[];
      if (servicesQuery.isNotEmpty) queryParams.add(servicesQuery);
      if (specialisationsQuery.isNotEmpty) queryParams.add(specialisationsQuery);
      if (latitudeQuery.isNotEmpty) queryParams.add(latitudeQuery);
      if (longitudeQuery.isNotEmpty) queryParams.add(longitudeQuery);
      if (maxDistanceQuery.isNotEmpty) queryParams.add(maxDistanceQuery);

      final url =
      Uri.parse('${APIEndPoints.searchConsults}?${queryParams.join('&')}');

      print('URL: $url');

      final response = await http.get(
        url,
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['result'] is List) {
          List<dynamic> resultsJson = data['result'];
          List<Map<String, dynamic>> results =
          resultsJson.cast<Map<String, dynamic>>();
          print('Results: $results');
          emit(SearchLoaded(results));
        } else {
          emit(SearchError(data['responseMessage']));
        }
      } else {
        print('Error response: ${response.body}');
        emit(SearchError(data['responseMessage']));
      }
    } catch (e) {
      print('Exception: $e');
      emit(SearchError("No Data Found"));
    }
  }

}

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'find_mum_event.dart';
part 'find_mum_state.dart';

class FindMumBloc extends Bloc<FindMumEvent, FindMumState> {
  FindMumBloc() : super(FindMumInitial()) {
    on<FetchDropdownOptions>(_onFetchDropdownOptions);
    on<FindAFriend>(_findAFriendBtn);
    on<getConnectedMums>(_getConnectedMums);
    on<ConnectMums>(_connectMums);
    on<CancelMumRequest>(_cancelMumRequest);
    on<FetchPendingRequests>(_fetchPendingRequests);
    on<AcceptMumRequest>(_acceptMumRequest);
    on<CreateNotification>(_createNotification);
  }

  Future<void> _onFetchDropdownOptions(FetchDropdownOptions event, Emitter<FindMumState> emit,) async {
    emit(DropdownLoading());
    try {
      final response = await http.get(Uri.parse(APIEndPoints.getOptions));

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        Map<String,dynamic> result = data['result'];
        emit(DropdownLoaded(result));
      } else {
        emit(DropdownError(data['responseMessage']));
      }
    } catch (e) {
      Exception('Error Occured While Fetching Data');
    }
  }

  Future<void> _findAFriendBtn(FindAFriend event, Emitter<FindMumState> emit) async {
    emit(findAFriendLoading());

    try {
      final List<String> queryParams = [];

      if (event.areYou.isNotEmpty) {
        final areYouQuery = 'stage=${Uri.encodeComponent(event.areYou)}';
        queryParams.add(areYouQuery);
      }

      if (event.Age.isNotEmpty) {
        final ageBracketQuery = 'age=${Uri.encodeComponent(event.Age)}';
        queryParams.add(ageBracketQuery);
      }

      if (event.Other.isNotEmpty) {
        final otherWorkQuery = event.Other
            .map((s) => 'otherWork[]=${Uri.encodeComponent(s.trim())}')
            .join('&');
        queryParams.add(otherWorkQuery);
      }

      if (event.Exercise.isNotEmpty) {
        final exerciseTypeQuery = event.Exercise
            .map((s) => 'exercise[]=${Uri.encodeComponent(s.trim())}')
            .join('&');
        queryParams.add(exerciseTypeQuery);
      }

      if (event.Language.isNotEmpty) {
        final languagesQuery = event.Language
            .map((s) => 'languages[]=${Uri.encodeComponent(s.trim())}')
            .join('&');
        queryParams.add(languagesQuery);
      }

      if (event.Interest.isNotEmpty) {
        final othersQuery = event.Interest
            .map((s) => 'others[]=${Uri.encodeComponent(s.trim())}')
            .join('&');
        queryParams.add(othersQuery);
      }

      if (event.maxDistance != null) {
        final distanceQuery = 'maxDistance=${Uri.encodeComponent(event.maxDistance.toString())}';
        queryParams.add(distanceQuery);
      }

      if (event.latitude != null) {
        final latitudeQuery = 'latitude=${Uri.encodeComponent(PrefUtils.getLatitude().toString())}';
        queryParams.add(latitudeQuery);
      }

      if (event.longitude != null) {
        final longitudeQuery = 'longitude=${Uri.encodeComponent(PrefUtils.getLongitude().toString())}';
        queryParams.add(longitudeQuery);
      }

      queryParams.add('page=${Uri.encodeComponent(event.page.toString())}');
      queryParams.add('limit=${Uri.encodeComponent(event.limit.toString())}');

      final url = Uri.parse('${APIEndPoints.filterMums}?${queryParams.join('&')}');

      print('URL: $url');

      final response = await http.get(
        url,
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final result = data['result'];
        int totalPages = result['page'];
        if (result['users'] is List<dynamic>) {
          List<Map<String, dynamic>> users = (result['users'] as List).map((doc) {
            if (doc is Map<String, dynamic>) {
              return {
                'fullName': doc['fullName'] ?? '',
                'stage': doc['stage'] ?? '',
                'profilePicture': doc['profilePicture'] ?? '',
                'email': doc['email'] ?? '',
                'location': doc['location'] ?? {},
                'country': doc['country'] ?? '',
                'phoneNumber': doc['phoneNumber'] ?? '',
                'countryCode': doc['countryCode'] ?? '',
                'kids': doc['kids'] ?? '',
                'connected': doc['connected'] ?? '',
                '_id': doc['_id'] ?? '',
                'languages': doc['languages'] ?? '',
                'exercise': doc['exercise'] ?? '',
                'otherWork': doc['otherWork'] ?? '',
                'others': doc['others'] ?? ''
              };
            }
            return {};
          }).toList().cast<Map<String, dynamic>>();

          final bool hasMoreData = event.page < totalPages;
          emit(findAFriendLoaded(users, hasMoreData: hasMoreData, totalPages: totalPages));
        }
      } else {
        emit(findAFriendError(data['responseMessage']));
      }
    } catch (e) {
      emit(findAFriendError('Error Occurred While Fetching Data'));
    }
  }

  Future<void> _getConnectedMums(getConnectedMums event, Emitter<FindMumState> emit) async {
    emit(getConnectedMumsLoading());

    try {
      final List<String> queryParams = [];
      queryParams.add('page=${Uri.encodeComponent(event.page.toString())}');
      queryParams.add('limit=${Uri.encodeComponent(event.limit.toString())}');

      if (event.maxDistance != null) {
        final distanceQuery = 'maxDistance=${Uri.encodeComponent(event.maxDistance.toString())}';
        queryParams.add(distanceQuery);
      }

      if (event.latitude != null) {
        final latitudeQuery = 'latitude=${Uri.encodeComponent(PrefUtils.getLatitude().toString())}';
        queryParams.add(latitudeQuery);
      }

      if (event.longitude != null) {
        final longitudeQuery = 'longitude=${Uri.encodeComponent(PrefUtils.getLongitude().toString())}';
        queryParams.add(longitudeQuery);
      }


      final url = Uri.parse('${APIEndPoints.getConnectedMums}?${queryParams.join('&')}');

      final response = await http.get(
        url,
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final result = data['result'];
        int totalPages = result['totalPages'];
        if (result['docs'] is List<dynamic>) {
          List<Map<String, dynamic>> users = (result['docs'] as List).map((doc) {
            if (doc is Map<String, dynamic>) {
              return {
                'fullName': doc['fullName'] ?? '',
                'requestId': doc['requestId'] ?? '',
                'stage': doc['stage'] ?? '',
                'profilePicture': doc['profilePicture'] ?? '',
                'email': doc['email'] ?? '',
                'location': doc['location'] ?? {},
                'country': doc['country'] ?? '',
                'phoneNumber': doc['phoneNumber'] ?? '',
                'countryCode': doc['countryCode'] ?? '',
                'kids': doc['kids'] ?? '',
                'connected': doc['connected'] ?? '',
                '_id': doc['_id'] ?? '',
                'languages': doc['languages'] ?? '',
                'exercise': doc['exercise'] ?? '',
                'otherWork': doc['otherWork'] ?? '',
                'others': doc['others'] ?? ''
              };
            }
            return {}; // Handle unexpected types
          }).toList().cast<Map<String, dynamic>>(); // Cast to List<Map<String, dynamic>>
          final bool hasMoreData = event.page < totalPages;
          emit(getConnectedMumsLoaded(users, hasMoreData: hasMoreData, totalPages: totalPages));
        } else {
          emit(getConnectedMumsError('Result is not a List'));
        }
      } else {
        emit(getConnectedMumsError(data['responseMessage'] ?? 'Unknown error'));
      }
    } catch (e) {
      print('Error Occurred While Fetching Data: $e');
      emit(getConnectedMumsError('No Connected Mums Found'));
    }
  }

  Future<void> _connectMums(ConnectMums event, Emitter<FindMumState> emit) async {
    emit(ConnectMumsLoading());

    try {
      final url = Uri.parse('${APIEndPoints.connectMums}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': PrefUtils.getUserLoginToken(),
        },
        body: json.encode({
          'receiverId': event.receiverId,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        emit(ConnectMumsLoaded(data));
      } else {
        emit(ConnectMumsError(data));
      }
    } catch (e) {
      emit(ConnectMumsError({
        'errorMessage': 'Error Occurred While Connecting to Mum',
      }));
    }
  }

  Future<void> _cancelMumRequest(CancelMumRequest event, Emitter<FindMumState> emit) async {
    emit(CancelMumRequestLoading());

    try {
      final url = Uri.parse('${APIEndPoints.CancelFriendRequest}');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': PrefUtils.getUserLoginToken(),
        },
        body: json.encode({
          'requestId': event.requestId,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        emit(CancelMumRequestLoaded(data));
      } else {
        emit(CancelMumRequestError(data));
      }
    } catch (e) {
      emit(CancelMumRequestError({
        'errorMessage': 'Error Occurred While Connecting to Mum',
      }));
    }
  }

  Future<void> _fetchPendingRequests(FetchPendingRequests event, Emitter<FindMumState> emit) async {
    emit(FetchPendingRequestsLoading());

    try {
      final url = Uri.parse('${APIEndPoints.getPendingFriendRequests}?page=${event.page}&limit=${event.limit}');
      final response = await http.get(
        url,
        headers: {
          'token': PrefUtils.getUserLoginToken(),
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final result = data['result'];
        final requests = result['requests'] as List<dynamic>;
        final totalPages = result['totalPages'];
        print(requests);
        print(totalPages);
        emit(FetchPendingRequestsLoaded(requests, totalPages));
      } else {
        emit(FetchPendingRequestsError(data['responseMessage'] ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(FetchPendingRequestsError('Error occurred while fetching pending requests'));
    }
  }

  Future<void> _acceptMumRequest(AcceptMumRequest event, Emitter<FindMumState> emit) async {
    emit(AcceptMumRequestLoading());

    try {
      final url = Uri.parse('${APIEndPoints.respondToFriendRequest}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': PrefUtils.getUserLoginToken(),
        },
        body: json.encode({
          'requestId': event.requestId,
          'status': event.status
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        emit(AcceptMumRequestLoaded(data));
      } else {
        emit(AcceptMumRequestError(data));
      }
    } catch (e) {
      emit(AcceptMumRequestError({
        'errorMessage': 'Error Occurred While Connecting to Mum',
      }));
    }
  }

  Future<void> _createNotification(CreateNotification event, Emitter<FindMumState> emit) async {
    emit(CreateNotificationLoading());

    try {
      final url = Uri.parse('${APIEndPoints.CreateNotification}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': PrefUtils.getUserLoginToken(),
        },
        body: json.encode({
          'receiverId': event.receiverId,
          'message': event.message,
          'title': event.title,
          'senderId': event.senderId
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        emit(CreateNotificationLoaded(data));
      } else {
        emit(CreateNotificationError(data));
      }
    } catch (e) {
      emit(CreateNotificationError({
        'errorMessage': 'Error Occurred While Connecting to Mum',
      }));
    }
  }

}

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;
import '../../Utils/api_constant.dart';
import '../../Utils/connectivity_service.dart';
import 'package:http/http.dart' as http;
import '../../Utils/pref_utils.dart';
part 'forums_event.dart';
part 'forums_state.dart';

class ForumsBloc extends Bloc<ForumsEvent, ForumsState> {
  ForumsBloc() : super(ForumsInitial()) {

    // Get All Forums API with optional search
    on<FetchForums>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ForumsLoading());

        try {
          // Base API URL for fetching forums
          String apiUrl = APIEndPoints.listForum;

          // Add search query, if present
          if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
            apiUrl += '?search=${Uri.encodeComponent(event.searchQuery!)}';
          }

          // Add pagination parameters (page and limit) to the URL, if present
          if (event.page != null) {
            apiUrl += '${event.searchQuery != null && event.searchQuery!.isNotEmpty ? '&' : '?'}page=${event.page}';
          }
          if (event.limit != null) {
            apiUrl += '&limit=${event.limit}';
          }

          final url = Uri.parse(apiUrl);
          developer.log("Request URL: $url");

          // Perform the HTTP GET request
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken() ?? '', // Ensure token is non-null
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);

            // Extract necessary data from the response
            final List<dynamic> docs = responseData['result']['docs'];
            final int totalDocs = responseData['result']['totalDocs'];
            final int totalPages = responseData['result']['totalPages'];
            final int currentPage = responseData['result']['page'];
            final bool hasNextPage = responseData['result']['hasNextPage'];

            // Emit the loaded state with parsed data
            emit(ForumsLoaded(
              docs: docs,
              totalDocs: totalDocs,
              totalPages: totalPages,
              currentPage: currentPage,
              hasNextPage: hasNextPage,
            ));
          } else {
            final errorData = jsonDecode(response.body);
            emit(ForumsError(errorData['responseMessage'] ?? 'An error occurred'));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });



    // Create Forums Post API
    on<CreateForumEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(CreateForumsLoading());
        try {
          final requestData = json.encode({
            "topicTitle": event.title,
            "description": event.description,
          });

          final url = Uri.parse(APIEndPoints.createForumTopic);
          developer.log("Request URL: $url");

          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
            body: requestData,
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(CreateForumsLoaded(responseData));
          } else {
            final errorData = jsonDecode(response.body);
            emit(CreateForumsError(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // View Forum GET API
    on<ViewForumEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ViewForumsLoading());
        try {
          String apiUrl = '${APIEndPoints.viewForum}?forumId=${event.forumId}'; // Construct URL with forumId
          final url = Uri.parse(apiUrl);
          developer.log("Request URL: $url");
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Ensure this token is valid
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(ViewForumsLoaded(responseData)); // Emit success state
          } else {
            final errorData = jsonDecode(response.body);
            emit(ViewForumsError(errorData)); // Emit error state
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString())); // Emit failure state
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection()); // Emit no internet state
        developer.log("No internet connection.");
      }
    });

    // User Reply To Forum POST API
    on<UserReplyEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ReplyToForumsLoading());
        try {
          final requestData = json.encode({
            "forumId": event.forumId,
            "message": event.message,
          });

          final url = Uri.parse(APIEndPoints.userReplyInForum);
          developer.log("Request URL: $url");

          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
            body: requestData,
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(ReplyToForumsLoaded(responseData));
          } else {
            final errorData = jsonDecode(response.body);
            emit(ReplyToForumsError(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Existing Topics GET API

    on<FetchExistingTopics>((event, emit) async {
      // Check network connectivity
      if (await ConnectivityService.isConnected()) {
        emit(ExistingTopicLoading()); // Emit loading state

        try {
          // Construct the API URL
          String apiUrl = '${APIEndPoints.getTopic}'; // URL endpoint
          final url = Uri.parse(apiUrl);

          developer.log("Request URL: $url");

          // Perform HTTP GET request
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Add your token here
            },
          );

          developer.log("Response Data: ${response.body}");

          // Check if the response is successful (status code 200)
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);

            // Ensure 'result' key exists and is a list
            if (responseData['result'] is List) {
              List<dynamic> topics = responseData['result'];
              emit(ExistingTopicLoaded(topics)); // Emit success state with topics
            } else {
              emit(ExistingTopicError('Unexpected response format'));
              developer.log("Unexpected response format: ${responseData}");
            }
          } else {
            final errorData = jsonDecode(response.body);
            emit(ExistingTopicError(errorData['responseMessage'] ?? 'Unknown error')); // Emit error state
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString())); // Emit failure state for exceptions
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection()); // Emit state if there's no network connection
        developer.log("No internet connection.");
      }
    });


  }
}

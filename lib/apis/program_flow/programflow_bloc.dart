import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:health2mama/apis/program_flow/programflow_state.dart';
import 'package:http/http.dart' as http;
import '../../Model/quiz_question.dart';
import '../../Utils/api_constant.dart';
import '../../Utils/connectivity_service.dart';
import 'dart:developer' as developer;
import '../../Utils/pref_utils.dart';
part 'programflow_event.dart';

class ProgramflowBloc extends Bloc<ProgramflowEvent, ProgramflowState> {
  ProgramflowBloc() : super(ProgramflowInitial()) {
    // Fetch Category By User Preference GET API
    on<FetchCategoriesEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(UserCategoryLoading());

        try {
          // Construct the URL with query parameter
          final url =
              Uri.parse(APIEndPoints.getCategoryByUserPreference).replace(
            queryParameters: {},
          );

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(UserCategoryLoaded(responseData));
          } else {
            final errorData = jsonDecode(response.body);
            emit(UserCategoryError(errorData));
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

    // Fetch Program GET API
    on<FetchProgramEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ProgramflowLoading());

        try {
          final categoryId = event.categoryId;

          // Construct the URL with query parameter
          final url = Uri.parse(APIEndPoints.getProgramByCategory).replace(
            queryParameters: {
              'categoryId': categoryId,
            },
          );

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final List<dynamic> result =
                responseData['result'] ?? []; // Handle missing 'result'

            emit(ProgramflowLoaded(result));
          } else {
            final errorData = jsonDecode(response.body);
            emit(ProgramflowError(errorData));
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

    // Fetch Program Topic GET API

    on<FetchTopics>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(TopicLoading());

        try {
          final programId = event.programId;

          // Construct the URL with query parameter
          final url = Uri.parse(APIEndPoints.getTopicByProgram).replace(
            queryParameters: {
              'programId': programId,
            },
          );

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          print("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(TopicLoaded(responseData)); // Pass responseData to TopicLoaded
          } else {
            final errorData = jsonDecode(response.body);
            emit(TopicError(errorData));
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

    // View Program Topic GET API

    on<ViewTopic>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ViewTopicLoading());

        try {
          final topicId =
              event.topicId; // Assuming FetchTopics should have topicId

          // Construct the URL with query parameter
          final url = Uri.parse(APIEndPoints.viewTopic).replace(
            queryParameters: {
              'topicId': topicId,
            },
          );

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            emit(ViewTopicLoaded(
                responseData)); // Pass responseData to ViewTopicLoaded
          } else {
            final errorData = jsonDecode(response.body);
            emit(ViewTopicError(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(ViewTopicError({'message': e.toString()}));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Save Unsave Item POST API

    on<SaveUnsaveItemEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SaveUnsaveItemLoading());

        try {
          final itemName = event.itemName;
          final itemId = event.itemId;
          final categoryIdJsonString =
              event.categoryId; // JSON string as received
          final isCompleted = event.isCompleted;
          final isSaved = event.isSaved;

          // Construct the request body
          final body = jsonEncode({
            'itemName': itemName,
            'itemId': itemId,
            'categoryId': jsonDecode(
                categoryIdJsonString), // Decode the JSON string to a list
            'isCompleted': isCompleted,
            'isSaved': isSaved,
          });

          // Print the request body for debugging
          print("Request Data: $body");

          // Construct the request URL
          final requestUrl = Uri.parse(APIEndPoints.saveUnsaveItem);
          print("Request URL: $requestUrl");

          final response = await http.post(
            requestUrl,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
              'Content-Type':
                  'application/json', // Set Content-Type to application/json
            },
            body: body,
          );

          print("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final Map<String, dynamic> successResponse =
                jsonDecode(response.body);
            emit(SaveUnsaveItemSuccess(successResponse));
          } else {
            final Map<String, dynamic> failureResponse =
                jsonDecode(response.body);
            emit(SaveUnsaveItemFailure(failureResponse));
            developer.log("Error Response: $failureResponse");
          }
        } catch (e) {
          emit(SaveUnsaveItemFailure({'message': e.toString()}));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Fetch Save Unsave Status GET API

    on<FetchSaveUnsaveStatus>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SaveUnsaveStatusLoading());

        try {
          final url = Uri.parse(APIEndPoints.getSaveUnsaveStatus).replace(
            queryParameters: {
              '_id': event.itemId,
              'categoryId[0]': event.categoryId,
            },
          );

          print("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          print("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);

            final result = responseData['result'] as Map<String, dynamic>;
            final isSaved = result['isSaved'] as bool? ?? false;
            final isCompleted = result['isCompleted'] as bool? ?? false;

            emit(SaveUnsaveStatusLoaded(
                isSaved: isSaved, isCompleted: isCompleted));
          } else {
            final Map<String, dynamic> errorData = jsonDecode(response.body);
            emit(SaveUnsaveStatusError(
                {'message': errorData['responseMessage'] ?? 'Unknown error'}));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(SaveUnsaveStatusError({'message': e.toString()}));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Add Points To Wallet POST API
    on<AddPointsToWalletEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(AddPointsToWalletLoading());

        try {
          final userPoints = event.points;

          // Construct the request body
          final body = jsonEncode({
            'points': userPoints,
          });

          final response = await http.post(
            Uri.parse(APIEndPoints.addPointsToUserWallet),
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
              'Content-Type': 'application/json',
            },
            body: body,
          );
          print("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final Map<String, dynamic> successResponse =
                jsonDecode(response.body);
            emit(AddPointsToWalletSuccess(successResponse));
          } else {
            final Map<String, dynamic> failureResponse =
                jsonDecode(response.body);
            emit(AddPointsToWalletFailure(failureResponse));
            developer.log("Error Response: $failureResponse");
          }
        } catch (e) {
          emit(AddPointsToWalletFailure({'message': e.toString()}));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Get Workout Categories GET API

    on<FetchWorkoutCategories>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(WorkoutCategoryLoading());

        try {
          // Construct the URL with query parameters
          final url = Uri.parse(APIEndPoints.getAllWorkoutCategory).replace(
            queryParameters: {
              'page': event.page.toString(),
              'limit': event.limit.toString(),
            },
          );

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);

            if (responseData is Map<String, dynamic> &&
                responseData['result'] is Map<String, dynamic>) {
              final result = responseData['result'];
              final workoutCategories = result['result'] as List<dynamic>? ??
                  []; // Ensure it's a list

              emit(WorkoutCategoryLoaded(
                workoutCategories: workoutCategories,
                pagination: result['pagination'] as Map<String, dynamic>? ?? {},
              ));
            } else {
              emit(WorkoutCategoryError(
                  {'error': 'Unexpected response format'}));
            }
          } else {
            final errorData = jsonDecode(response.body);
            emit(WorkoutCategoryError(errorData));
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
    // Get WorkoutSubCategoryByID GET API

    on<FetchWorkoutSubcategoryEvent>((event, emit) async {
      // Check for internet connection
      if (await ConnectivityService.isConnected()) {
        emit(SubWorkoutLoading()); // Emit loading state

        try {
          // Construct the URL with query parameters (_id and stage)
          final url = Uri.parse(
              '${APIEndPoints.getWorkoutSubcategoryById}?_id=${event.id}&stage=${event.stage}');

          developer.log("Request URL: $url");

          // Make the GET request with headers
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Fetch user token
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            // Parse and emit successful response
            final responseData = jsonDecode(response.body);
            emit(SubWorkoutLoaded(responseData));
          } else {
            // Parse and emit error response if status code isn't 200
            final errorData = jsonDecode(response.body);
            emit(SubWorkoutError(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          // Emit failure state for any exceptions during the request
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception: $e");
        }
      } else {
        // Emit network connection failure
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Get Recipes By Type Categories GET API

    on<FetchRecipesEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(RecipeLoading()); // Emit loading state

        try {
          // Initialize query string with page and limit parameters
          final queryParams = <String>[];

          // Add page and limit to the query string
          queryParams.add('page=${event.page}');
          queryParams.add('limit=${event.limit}');

          // Conditionally add dietary parameters if not empty
          if (event.dietaryIds.isNotEmpty) {
            final dietaryParams = event.dietaryIds
                .asMap()
                .entries
                .map((entry) => 'dietaryId%5B${entry.key}%5D=${entry.value}')
                .join('&');
            queryParams.add(dietaryParams);
          }

          // Conditionally add cuisine parameters if not empty
          if (event.cuisineIds.isNotEmpty) {
            final cuisineParams = event.cuisineIds
                .asMap()
                .entries
                .map((entry) => 'cuisineId%5B${entry.key}%5D=${entry.value}')
                .join('&');
            queryParams.add(cuisineParams);
          }

          // Conditionally add diet parameters if not empty
          if (event.dietIds.isNotEmpty) {
            final dietParams = event.dietIds
                .asMap()
                .entries
                .map((entry) => 'dietId%5B${entry.key}%5D=${entry.value}')
                .join('&');
            queryParams.add(dietParams);
          }

          // Build the final query string
          final queryString = queryParams.join('&');
          final url =
              Uri.parse('${APIEndPoints.listRecipeWithType}?$queryString');

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body)['result']['result'] as List<dynamic>;
            Map<String,dynamic> paginationData =
                jsonDecode(response.body)['result']['pagination'];

            // Emit loaded state with recipe data and pagination details
            emit(RecipeLoaded(
              successResponse: responseData,
              pagination: paginationData,
            ));
          } else {
            final errorData = jsonDecode(response.body) as Map<String, dynamic>;
            emit(RecipeError(
                errorData)); // Emit error state with Map<String, dynamic>
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(RecipeError({'message': 'Exception: $e'}));
          developer.log("Exception: $e");
        }
      } else {
        emit(RecipeError({'message': 'No internet connection'}));
        developer.log("No internet connection.");
      }
    });

    // Get Filter Recipes Data GET API

    on<FilterRecipeEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(FilterRecipeLoading());

        try {
          final url = Uri.parse(
              '${APIEndPoints.getAllRecipeDetails}?stage=${event.stage}');
          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);

            final dietaryData =
                responseData['result']['allDietary'] as List<dynamic>;
            final dietData = responseData['result']['allDiet'] as List<dynamic>;
            final cuisineData =
                responseData['result']['allCuisines'] as List<dynamic>;

            final filteredDietary = dietaryData
                .where((item) =>
                    (item['stage'] as List<dynamic>).contains(event.stage))
                .map((item) => item['dietaryName'] as String)
                .toList();
            final dietaryIds = dietaryData
                .where((item) =>
                    (item['stage'] as List<dynamic>).contains(event.stage))
                .map((item) => item['_id'] as String)
                .toList();

            final filteredDiets = dietData
                .where((item) =>
                    (item['stage'] as List<dynamic>).contains(event.stage))
                .map((item) => item['dietName'] as String)
                .toList();
            final dietIds = dietData
                .where((item) =>
                    (item['stage'] as List<dynamic>).contains(event.stage))
                .map((item) => item['_id'] as String)
                .toList();

            final filteredCuisines = cuisineData
                .where((item) =>
                    (item['stage'] as List<dynamic>).contains(event.stage))
                .map((item) => item['cuisineName'] as String)
                .toList();
            final cuisineIds = cuisineData
                .where((item) =>
                    (item['stage'] as List<dynamic>).contains(event.stage))
                .map((item) => item['_id'] as String)
                .toList();

            emit(FilterRecipeLoaded(
              allDietary: filteredDietary,
              allDiets: filteredDiets,
              allCuisines: filteredCuisines,
              dietaryIds: dietaryIds,
              dietIds: dietIds,
              cuisineIds: cuisineIds,
            ));
          } else {
            final errorData = jsonDecode(response.body) as Map<String, dynamic>;
            emit(FilterRecipeError(errorData));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(FilterRecipeError({'message': 'Exception: $e'}));
          developer.log("Exception: $e");
        }
      } else {
        emit(FilterRecipeError({'message': 'No internet connection'}));
        developer.log("No internet connection.");
      }
    });

    // Fetch Saved Topics GET API
    on<FetchSavedTopicsEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(SavedTopicsLoading());

        try {
          final categoryId = event.categoryId;

          // Construct the URL with query parameter
          final url =
              Uri.parse(APIEndPoints.getSavedTopicsByCategoryId).replace(
            queryParameters: {
              'categoryId': categoryId,
            },
          );

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final List<dynamic> result = responseData['result'];
            final String responseMessage = responseData['responseMessage'];

            // Converting result to a list of maps
            final List<Map<String, dynamic>> topics =
                List<Map<String, dynamic>>.from(result);

            emit(SavedTopicsLoaded(topics, responseMessage));
          } else {
            final responseData = jsonDecode(response.body);
            final String responseMessage =
                responseData['responseMessage'] ?? 'Unknown error';
            emit(SavedTopicsError(responseMessage));
            developer.log("Error Response: $responseMessage");
          }
        } catch (e) {
          emit(SavedTopicsError('An unexpected error occurred.'));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Fetch Program Percentage GET API

    on<FetchProgramPercentageEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(ProgramPercentageLoading());

        try {
          final categoryId = event.categoryId;

          // API call for percentage data
          final url =
              Uri.parse(APIEndPoints.programPercentageCalculation).replace(
            queryParameters: {
              'categoryId': categoryId,
            },
          );
          developer.log("Request URL: $url");
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(),
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            print(responseData);
            if (responseData['responseCode'] == 200) {
              final List<dynamic> result = responseData['result'];
              emit(ProgramPercentageLoaded(
                  result.map((e) => Map<String, dynamic>.from(e)).toList()));
            } else {
              emit(ProgramPercentageError(
                  responseData['responseMessage'] ?? 'Error occurred'));
            }
          } else {
            final errorData = jsonDecode(response.body);
            emit(ProgramPercentageError(
                errorData['responseMessage'] ?? 'Error occurred'));
          }
        } catch (e) {
          emit(ProgramPercentageError('An unexpected error occurred.'));
        }
      } else {
        emit(CheckNetworkConnection());
      }
    });

    // Fetch All Notifications GET API

    on<GetAllNotifications>((event, emit) async {
      // Check if the device is connected to the internet
      if (await ConnectivityService.isConnected()) {
        // Emit loading state
        emit(NotificationLoading());

        try {
          // Construct the URL with the receiverId as a query parameter
          final url = Uri.parse(APIEndPoints.listNotifications).replace(
            queryParameters: {
              'receiverId': event.receiverId, // Use receiverId from the event
            },
          );

          developer.log("Request URL: $url");

          // Make the API request
          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
            },
          );

          developer.log("Response Data: ${response.body}");

          // Check for successful response
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);

            // Emit the loaded state with the notifications
            emit(NotificationLoaded(responseData['result']));
          } else {
            final errorData = jsonDecode(response.body);

            // Emit the error state with an error message
            emit(NotificationError(errorData['message']));
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          // Emit a failure state if an exception occurs
          emit(NotificationError(e.toString()));
          developer.log("Exception: $e");
        }
      } else {
        // Emit network connection error state
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Delete One Notification DELETE API

    on<DeleteNotificationEvent>((event, emit) async {
      // Check if the device is connected to the internet
      if (await ConnectivityService.isConnected()) {
        // Emit loading state
        emit(NotificationDeleteLoading());

        try {
          // Construct the URL with the notificationId as a query parameter
          final url = Uri.parse(APIEndPoints.deleteNotifications).replace(
            queryParameters: {
              '_id': event.notificationId,
            },
          );

          // Make the API request
          final response = await http.delete(
            url,
            headers: {
              'accept': 'application/json',
            },
          );

          final responseData =
              jsonDecode(response.body) as Map<String, dynamic>;

          if (response.statusCode == 200) {
            if (responseData['result']['acknowledged'] == true &&
                responseData['result']['deletedCount'] > 0) {
              emit(NotificationDeleteSuccess(responseData));
            } else {
              emit(NotificationDeleteFailure(
                  {'responseMessage': 'Deletion failed.'}));
            }
          } else {
            emit(NotificationDeleteFailure({
              'responseMessage':
                  responseData['responseMessage'] ?? 'Unknown error occurred.'
            }));
          }
        } catch (e) {
          emit(NotificationDeleteFailure({'responseMessage': e.toString()}));
        }
      } else {
        // Emit network connection error state
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });

    // Delete All Notification DELETE API

    on<DeleteAllNotificationsEvent>((event, emit) async {
      // Check if the device is connected to the internet
      if (await ConnectivityService.isConnected()) {
        // Emit loading state
        emit(NotificationLoadingState());

        try {
          // Construct the URL with the receiverId as a query parameter
          final url = Uri.parse(APIEndPoints.deleteAllNotifications).replace(
            queryParameters: {
              'receiverId': event.receiverId,
            },
          );

          // Make the API request
          final response = await http.delete(
            url,
            headers: {
              'accept': 'application/json',
            },
          );

          final responseData =
              jsonDecode(response.body) as Map<String, dynamic>;

          if (response.statusCode == 200) {
            // Emit success state with the response data
            emit(NotificationDeletedState(responseData));
          } else {
            // Emit error state with failure details
            emit(NotificationErrorState({
              'responseMessage':
                  responseData['responseMessage'] ?? 'Deletion failed.'
            }));
          }
        } catch (e) {
          emit(NotificationDeleteFailure({'responseMessage': e.toString()}));
        }
      } else {
        // Emit network connection error state
        emit(CheckNetworkConnection());
        developer.log("No internet connection.");
      }
    });


    // fetch Quiz questions GET
    on<FetchQuizEvent>((event, emit) async {
      if (await ConnectivityService.isConnected()) {
        emit(QuizLoading());

        try {
          // Construct the URL with query parameter (Currently empty)
          final url = Uri.parse(APIEndPoints.getQuiz);

          developer.log("Request URL: $url");

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'token': PrefUtils.getUserLoginToken(), // Make sure this is valid
            },
          );

          developer.log("Response Data: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final List<dynamic> result = responseData['result'] ?? []; // Handle missing 'result'

            // Optional: Map the result to a list of QuizQuestion model if needed
            final questions = result.map((e) => QuizQuestion.fromJson(e)).toList();

            emit(QuizLoaded(questions));  // Emit the loaded state with processed data
          } else {
            final errorData = jsonDecode(response.body);
            emit(QuizError(errorData['message'] ?? 'Unknown Error'));  // Handle the error state with message
            developer.log("Error Response: $errorData");
          }
        } catch (e) {
          emit(CommonServerFailure(e.toString()));
          developer.log("Exception: $e");
        }
      } else {
        emit(CheckNetworkConnection());  // Handle no internet connection state
        developer.log("No internet connection.");
      }
    });


  }
}

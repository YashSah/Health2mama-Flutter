import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:health2mama/Utils/api_constant.dart';
import 'package:health2mama/Utils/pref_utils.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'subscription_event.dart';
part 'subscription_state.dart';


class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<ListSubscriptionsData>(_onListSubscriptionsData);
  }

  Future<void> _onListSubscriptionsData(
      ListSubscriptionsData event,
      Emitter<SubscriptionState> emit,
      ) async {
    emit(GetSubscriptionLoading());

    final String url = APIEndPoints.listSubscriptions;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'token': PrefUtils.getUserLoginToken(),
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> listSubscriptions = data['result'];
        print(listSubscriptions);
        emit(GetSubscriptionLoaded(listSubscriptions: listSubscriptions));
      } else {
        emit(GetSubscriptionError(error: 'Failed to load Subscription data'));
      }
    } catch (error) {
      emit(GetSubscriptionError(error: error.toString()));
    }
  }

}
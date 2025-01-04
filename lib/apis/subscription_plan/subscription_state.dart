part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

final class GetSubscriptionLoading extends SubscriptionState {}

class GetSubscriptionLoaded extends SubscriptionState {
  final Map<String,dynamic> listSubscriptions;

  GetSubscriptionLoaded({
    required this.listSubscriptions
  });
}

final class GetSubscriptionError extends SubscriptionState {
  final String error;

  GetSubscriptionError({required this.error});
}
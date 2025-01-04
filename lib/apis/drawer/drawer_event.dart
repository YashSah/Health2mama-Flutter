part of 'drawer_bloc.dart';

@immutable
sealed class DrawerEvent {}

class LoadUserProfile extends DrawerEvent {}

class ChangePasswordRequested extends DrawerEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });
}

class UpdateUserProfileRequested extends DrawerEvent {
  final String? fullName;
  final String? email;
  final String? country;
  final String? countryCode;
  final String? phoneNumber;
  final String? profilePicture;
  final String? stage;
  final String? coreProgramOpted;
  final List<String>? otherWork;
  final List<String>? languages;
  final List<String>? exercise;
  final List<String>? others;
  final String? age;
  final String? kids;

  UpdateUserProfileRequested({
    this.fullName,
    this.email,
    this.country,
    this.countryCode,
    this.phoneNumber,
    this.stage,
    this.profilePicture,
    this.coreProgramOpted,
    this.otherWork,
    this.languages,
    this.exercise,
    this.others,
    this.age,
    this.kids,
  });
}

class GetOptionsEvent extends DrawerEvent {}

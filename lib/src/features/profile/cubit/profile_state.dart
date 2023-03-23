part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {}

class ProfileFailed extends ProfileState {
  final String message;

  ProfileFailed({required this.message});
}

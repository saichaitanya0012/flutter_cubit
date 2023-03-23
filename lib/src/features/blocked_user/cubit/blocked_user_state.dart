part of 'blocked_user_cubit.dart';

@immutable
abstract class BlockedUserState {}

class BlockedUserInitial extends BlockedUserState {}

class BlockedUserLoading extends BlockedUserState {}

class BlockedUserSuccess extends BlockedUserState {
  final List<Map<dynamic, dynamic>> jsonList;

  BlockedUserSuccess({required this.jsonList});
}

class BlockedUserFailed extends BlockedUserState {
  final String message;

  BlockedUserFailed({required this.message});
}

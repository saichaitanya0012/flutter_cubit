part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String message;

  SignInSuccess({this.message = 'Sign in successful'});
}

class SignInFailed extends SignInState {
  final String message;

  SignInFailed({this.message = 'Sign in failed'});
}

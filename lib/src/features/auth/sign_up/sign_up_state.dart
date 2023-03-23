part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String message;

  SignUpSuccess({this.message = 'Sign up successful'});
}

class SignUpFailed extends SignUpState {
  final String message;

  SignUpFailed({this.message = 'Sign up failed'});
}

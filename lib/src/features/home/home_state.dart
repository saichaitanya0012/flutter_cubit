part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  List<Map<dynamic, dynamic>>? jsonList = [];
  num? pendingAmount = 0;
  HomeLoaded({this.jsonList ,this.pendingAmount});
}

class HomeError extends HomeState {}

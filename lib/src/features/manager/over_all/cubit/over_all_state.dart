part of 'over_all_cubit.dart';

@immutable
abstract class OverAllState {}

class OverAllInitial extends OverAllState {}

class OverAllLoading extends OverAllState {}


class OverAllSuccess extends OverAllState {
  final List<Map<dynamic, dynamic>> jsonList;

  OverAllSuccess({required this.jsonList});
}

class OverAllFailed extends OverAllState {
  final String message;

  OverAllFailed({required this.message});
}

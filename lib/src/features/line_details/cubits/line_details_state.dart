part of 'line_details_cubit.dart';

@immutable
abstract class LineDetailsState {}

class LineDetailsInitial extends LineDetailsState {
  final bool isUpdate;
  LineDetailsInitial({this.isUpdate = true});
}

class LineDetailsLoading extends LineDetailsState {}

class LineDetailsSuccess extends LineDetailsState {
  final List<Map<dynamic, dynamic>> jsonList;

  LineDetailsSuccess({required this.jsonList});
}

class LineDetailsFailed extends LineDetailsState {
  final String message;

  LineDetailsFailed({required this.message});
}

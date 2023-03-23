part of 'get_lines_cubit.dart';

@immutable
abstract class GetLinesState {}

class GetLinesInitial extends GetLinesState {}

class GetLinesLoading extends GetLinesState {}

class GetLinesLoaded extends GetLinesState {
  final List<Map<dynamic, dynamic>> jsonList;

  GetLinesLoaded({ required this.jsonList});
}


class GetLinesError extends GetLinesState {
  final String? message;

  GetLinesError({this.message});
}



part of 'total_collection_cubit.dart';

@immutable
abstract class TotalCollectionState {}

class TotalCollectionInitial extends TotalCollectionState {}

class TotalCollectionLoading extends TotalCollectionState {}

class TotalCollectionLoaded extends TotalCollectionState {
  List<Map<dynamic, dynamic>>? jsonList = [];
  TotalCollectionLoaded({this.jsonList});
}

class TotalCollectionError extends TotalCollectionState {
  String? message;
  TotalCollectionError({this.message});
}

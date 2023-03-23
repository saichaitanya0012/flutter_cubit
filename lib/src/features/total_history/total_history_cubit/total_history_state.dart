part of 'total_history_cubit.dart';

@immutable
abstract class TotalHistoryState {}

class TotalHistoryInitial extends TotalHistoryState {}

class TotalHistoryLoading extends TotalHistoryState {}

class TotalHistoryLoaded extends TotalHistoryState {
  List<Map<dynamic, dynamic>>? jsonList = [];
  num? totalMoney = 0;
  num? totalCratesToday = 0;
  bool? showSearch;
  bool? loadMore;

  TotalHistoryLoaded(
      {this.jsonList,
      this.totalMoney,
      this.totalCratesToday,
      this.showSearch = false,
      this.loadMore = false});
}

class TotalHistoryLoadMore extends TotalHistoryState {}

class TotalHistoryError extends TotalHistoryState {
  String? message;

  TotalHistoryError({this.message});
}

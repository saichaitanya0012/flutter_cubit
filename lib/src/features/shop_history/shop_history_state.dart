part of 'shop_history_cubit.dart';

@immutable
abstract class ShopHistoryState {}

class ShopHistoryInitial extends ShopHistoryState {}

class ShopHistoryLoading extends ShopHistoryState {}

class ShopHistoryLoaded extends ShopHistoryState {
  final List<dynamic>? jsonList;

  ShopHistoryLoaded({this.jsonList});
}

class ShopHistoryError extends ShopHistoryState {
  final String? message;

  ShopHistoryError({this.message});
}

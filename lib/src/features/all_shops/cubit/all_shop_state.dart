part of 'all_shop_cubit.dart';

@immutable
abstract class AllShopState {}

class AllShopInitial extends AllShopState {}

class AllShopLoading extends AllShopState {}

class AllShopLoaded extends AllShopState {
  final List<Map<dynamic, dynamic>>? jsonList;

  AllShopLoaded({ this.jsonList});
}

class AllShopError extends AllShopState {
  final String message;

  AllShopError({required this.message});
}



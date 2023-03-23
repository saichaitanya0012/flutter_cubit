part of 'shop_detail_cubit.dart';

@immutable
abstract class ShopDetailState {}

class ShopDetailInitial extends ShopDetailState {}

class ShopDetailLoading extends ShopDetailState {}

class ShopDetailSuccess extends ShopDetailState {}

class ShopDetailFailed extends ShopDetailState {
  final String message;

  ShopDetailFailed({required this.message});
}



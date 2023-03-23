part of 'prodution_details_cubit.dart';

@immutable
abstract class ProdutionDetailsState {}

class ProdutionDetailsInitial extends ProdutionDetailsState {
  final bool isUpdate;
  ProdutionDetailsInitial({this.isUpdate = true});
}

class ProdutionDetailsLoading extends ProdutionDetailsState {}

class ProdutionDetailsSuccess extends ProdutionDetailsState {
  final List<Map<dynamic, dynamic>> jsonList;

  ProdutionDetailsSuccess({ required this.jsonList});
}


class ProdutionDetailsFailed extends ProdutionDetailsState {
  final String message;
  ProdutionDetailsFailed({required this.message});
}



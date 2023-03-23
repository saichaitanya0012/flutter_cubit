part of 'management_details_cubit.dart';

@immutable
abstract class ManagementDetailsState {}

class ManagementDetailsInitial extends ManagementDetailsState {
  final bool isUpdate;
  ManagementDetailsInitial({this.isUpdate = true});
}

class ManagementDetailsLoading extends ManagementDetailsState {}

class ManagementDetailsSuccess extends ManagementDetailsState {
  final List<Map<dynamic, dynamic>> jsonList;

  ManagementDetailsSuccess({required this.jsonList});
}

class ManagementDetailsFailed extends ManagementDetailsState {
  final String message;

  ManagementDetailsFailed({required this.message});
}

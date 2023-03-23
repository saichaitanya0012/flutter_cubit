part of 'create_vendor_cubit.dart';

@immutable
abstract class CreateVendorState {}

class CreateVendorInitial extends CreateVendorState {
  final String? id;
  final String? name;

  CreateVendorInitial({ this.id,  this.name});
}

class CreateVendorLoading extends CreateVendorState {}


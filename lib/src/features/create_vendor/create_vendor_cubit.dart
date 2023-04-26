import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goli_soda/src/features/home/home_cubit.dart';
import 'package:goli_soda/src/local_storage/hive_store.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:meta/meta.dart';

part 'create_vendor_state.dart';

class CreateVendorCubit extends Cubit<CreateVendorState> {
  CreateVendorCubit() : super(CreateVendorInitial());

  // String? id;
  // String? name;

  Future<void> putShopDetailsToFirestore(String shopName, String address, String phone,
      String email, String ownerName, String crate,num lineNumber,String lineId,String lineName, context) async {
    emit(CreateVendorLoading());
    try {

      final CollectionReference itemsRef = FirebaseFirestore.instance.collection('shops');
      final QuerySnapshot snapshot = await itemsRef
          .where('line_id', isEqualTo: lineId)
          .orderBy('line_number').get();
      // final WriteBatch batch = FirebaseFirestore.instance.batch();
      // snapshot.docs.forEach((doc) {
      //   batch.update(doc.reference, {'line_number': doc['line_number'] + 1});
      // });
      // await batch.commit();
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('shops').doc();
      docRef.set({
        "id": docRef.id,
        'shopName': shopName,
        'address': address,
        'phone': phone,
        'email': email,
        'ownerName': ownerName,
        "current_balance": "0",
        "remaining_crates": "0",
        "crate_price": crate,
        "image_url": "",
        "is_blocked": false,
        "line_number": lineNumber,
        "line_id": lineId,
        "line_name": lineName,
        "created_at": DateTime.now().toString(),
        "created_by": HiveStore().get(Keys.userName),
      }).then((value) {
        print('Shop details added to Firestore');
        emit(CreateVendorInitial());
        CustomSnackBar().snackbarSuccess(message: 'Shop added successfully');
        Navigator.pop(context, true);
      });
    } on FirebaseException catch (e) {
      emit(CreateVendorInitial());
      CustomSnackBar().errorSnackBar(message: 'Error: ${e.message}');
      print('Error adding shop details to Firestore: $e');
    } catch (e) {
      emit(CreateVendorInitial());
      CustomSnackBar().errorSnackBar(message: 'Error: ${e}');
      print('Error adding shop details to Firestore: $e');
    }
  }

  Future<void>  updateShopDetailsToFirestore(String shopName, String address, String phone,
     String ownerName, String crate, context,String shopId) async {
    emit(CreateVendorLoading());
    try {
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('shops').doc(shopId);
      docRef.update({
        "id": docRef.id,
        'shopName': shopName,
        'address': address,
        'phone': phone,
        'ownerName': ownerName,
        "crate_price": crate,
        "created_by": HiveStore().get(Keys.userName),
      }).then((value) {
        print('Shop details updated');
        emit(CreateVendorInitial());
        CustomSnackBar().snackbarSuccess(message: 'Shop added successfully');
        Navigator.pop(context, true);
      });
    } on FirebaseException catch (e) {
      emit(CreateVendorInitial());
      CustomSnackBar().errorSnackBar(message: 'Error: ${e.message}');
      print('Error adding shop details to Firestore: $e');
    } catch (e) {
      emit(CreateVendorInitial());
      CustomSnackBar().errorSnackBar(message: 'Error: ${e}');
      print('Error adding shop details to Firestore: $e');
    }
  }
}

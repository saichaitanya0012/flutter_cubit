import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:goli_soda/src/features/navigator.dart';
import 'package:goli_soda/src/features/total_history/total_collection/total_collection_cubit.dart';
import 'package:goli_soda/src/local_storage/hive_store.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'shop_detail_state.dart';

class ShopDetailCubit extends Cubit<ShopDetailState> {
  ShopDetailCubit() : super(ShopDetailInitial());

  void updateShopData(String? shopName, String? ownerName, String? currentBalance, String? totalCrates, String? crateDelivered,
      String? amountReceived, String? crateReceived, String? id, context) {
    Navigator.pop(context);
    emit(ShopDetailLoading());
    FirebaseFirestore.instance.collection('shops').doc(id).update({
      "current_balance": currentBalance,
      "remaining_crates": totalCrates,
    }).then((value) {
      final DocumentReference docRef = FirebaseFirestore.instance.collection('transactions').doc();
      docRef.set({
        "id": docRef.id,
        "shop_id": id,
        'shopName': shopName,
        'ownerName': ownerName,
        "current_balance": currentBalance,
        "remaining_crates": totalCrates,
        "crate_delivered": crateDelivered,
        "amount_received": amountReceived,
        "crate_received": crateReceived,
        "created_at": DateTime.now(),
        "created_by": HiveStore().get(Keys.userName),
      });
    }).then((value) async {
      List<Map<dynamic, dynamic>> jsonList = [];
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot;
      try {
        querySnapshot = await firestore.collection('collections').where('date', isEqualTo: DateFormat('dd-MMM-yyyy').format(DateTime.now())).get();
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          jsonList.add(data);
        }
        if (jsonList.isNotEmpty) {
          await firestore.collection('collections').doc(jsonList[0]['id']).update({
            "total_crates": jsonList[0]['total_crates'] + int.parse(crateDelivered!),
            "total_amount": jsonList[0]['total_amount'] + int.parse(amountReceived!),
          });
        } else {
          final DocumentReference docRef = firestore.collection('collections').doc();
          await docRef.set({
            "id": docRef.id,
            "total_crates": int.parse(crateDelivered!),
            "total_amount": int.parse(amountReceived!),
            "date": DateTime.now(),
          });
        }
      } catch (e) {
        print('Error getting region collection data: $e');
      }
    }).then((value) {
      print("Shop data updated");
      emit(ShopDetailSuccess());
    }).catchError((error) {
      emit(ShopDetailSuccess());
      print("Failed to update shop data: $error");
    });
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadImageToFirebaseStorage(File imageFile, id, context) async {
    try {
      emit(ShopDetailLoading());
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('shops').doc(id).update({
        "image_url": downloadUrl,
      });
      CustomSnackBar().snackbarMessage(message: 'Image uploaded successfully');
      emit(ShopDetailSuccess());
    } catch (e) {
      emit(ShopDetailFailed(message: 'Error: ${e}'));
    }
  }

  void deleteShopData(String? id, pin) {
    emit(ShopDetailLoading());
    getPin().then((value) {
      if (value == pin) {
        FirebaseFirestore.instance.collection('shops').doc(id).delete().then((value) {
          print("Shop data deleted");
          emit(ShopDetailSuccess());
        }).catchError((error) {
          emit(ShopDetailFailed(message: 'Error: ${error}'));
        });
      } else {
        emit(ShopDetailInitial());
        CustomSnackBar().snackbarMessage(message: 'Invalid Pin');
      }
    });
  }

  void blockShopData(String? id, pin,isBlocked) {
    emit(ShopDetailLoading());
    getPin().then((value) {
      if (value == pin) {
        FirebaseFirestore.instance.collection('shops').doc(id).update({
          "is_blocked": !isBlocked,
        }).then((value) {
          print("Shop data deleted");
          emit(ShopDetailSuccess());
        }).catchError((error) {
          emit(ShopDetailFailed(message: 'Error: ${error}'));
        });
      } else {
        emit(ShopDetailInitial());
        CustomSnackBar().snackbarMessage(message: 'Invalid Pin');
      }
    });
  }

  void editCrateAmount(String? id, pin,amount){
    emit(ShopDetailLoading());
    getPin().then((value) {
      if (value == pin) {
        FirebaseFirestore.instance.collection('shops').doc(id).update({
          "crate_price": amount.toString(),
        }).then((value) {
          print("Shop data deleted");
          emit(ShopDetailSuccess());
        }).catchError((error) {
          emit(ShopDetailFailed(message: 'Error: ${error}'));
        });
      } else {
        emit(ShopDetailInitial());
        CustomSnackBar().snackbarMessage(message: 'Invalid Pin');
      }
    });
  }

  Future<String?> getPin() async {
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      querySnapshot = await firestore.collection('admin_pin').get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      if (jsonList.isNotEmpty) {
        return jsonList[0]['pin'];
      } else {
        return "1234";
      }
    } catch (e) {
      print('Error getting region collection data: $e');
    }
    return null;
  }
}

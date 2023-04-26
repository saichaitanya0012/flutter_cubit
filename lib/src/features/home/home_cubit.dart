import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goli_soda/src/features/home/home_model.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  num? pendingAmount = 0;

  Future<void> getRegionCollectionData({String? keyword,String? id}) async {
    emit(HomeLoading());
    List<Map<dynamic, dynamic>> jsonList = [];
    pendingAmount = 0;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      if (keyword != null) {
        querySnapshot = await firestore
            .collection('shops')
            .where('line_id', isEqualTo: id)
            .where('shopName', isGreaterThanOrEqualTo: keyword)
            .get();
      } else {
        querySnapshot = await firestore
            .collection('shops')
            .where('line_id', isEqualTo: id)
            .orderBy("line_number")
            .get();
      }
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
        pendingAmount = pendingAmount! + num.parse(data['current_balance']);
      }
      emit(HomeLoaded(jsonList: jsonList,pendingAmount: pendingAmount));
    } catch (e) {
      emit(HomeError());
      print('Error getting region collection data: $e');
    }
  }
}

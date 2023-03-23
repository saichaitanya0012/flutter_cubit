import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'shop_history_state.dart';

class ShopHistoryCubit extends Cubit<ShopHistoryState> {
  ShopHistoryCubit() : super(ShopHistoryInitial());


  Future<void> getShopHistoryData({String? shopId}) async {
    emit(ShopHistoryLoading());
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      querySnapshot = await firestore.collection('transactions').where('shop_id', isEqualTo: shopId).get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data=documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      emit(ShopHistoryLoaded(jsonList: jsonList));
    } catch (e) {
      emit(ShopHistoryError());
      print('Error getting region collection data: $e');
    }
  }
}

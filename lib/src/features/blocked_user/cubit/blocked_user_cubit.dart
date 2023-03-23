import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'blocked_user_state.dart';

class BlockedUserCubit extends Cubit<BlockedUserState> {
  BlockedUserCubit() : super(BlockedUserInitial());

  Future<void> getBlockedUser(
      {String? keyword, String? id, bool isAllShops = true}) async {
    emit(BlockedUserLoading());
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      if (keyword != null) {
        querySnapshot = await firestore
            .collection('shops')
            .where('is_blocked', isEqualTo: true)
            .where('shopName', isGreaterThanOrEqualTo: keyword)

            .get();
      } else {
        querySnapshot = await firestore.collection('shops')
            .where('is_blocked', isEqualTo: true).get();
      }
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      emit(BlockedUserSuccess(jsonList: jsonList));
    } catch (e) {
      emit(BlockedUserFailed(message: e.toString()));
      print('Error getting region collection data: $e');
    }
  }
}

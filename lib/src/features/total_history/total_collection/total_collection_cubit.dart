import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'total_collection_state.dart';

class TotalCollectionCubit extends Cubit<TotalCollectionState> {
  TotalCollectionCubit() : super(TotalCollectionInitial());

  Future<void> getCollectedData() async {
    emit(TotalCollectionLoading());
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    DateTime now = DateTime.now();
    try {
      querySnapshot = await firestore
          .collection('collections')
          .where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime(now!.year, now!.month, now!.day)))
          .where('date',
          isLessThanOrEqualTo: Timestamp.fromDate(
              DateTime(now!.year, now!.month, now!.day + 1)))
          .get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      emit(TotalCollectionLoaded(jsonList: jsonList));
    } catch (e) {
      emit(TotalCollectionError(message: e.toString()));
      print('Error getting region collection data: $e');
    }
  }
}

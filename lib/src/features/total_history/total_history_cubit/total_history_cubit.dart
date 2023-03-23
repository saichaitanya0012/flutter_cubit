import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'total_history_state.dart';

class TotalHistoryCubit extends Cubit<TotalHistoryState> {
  TotalHistoryCubit() : super(TotalHistoryInitial());

  num? totalMoney = 0;
  num? totalCratesToday = 0;
  bool? hasMore = true;
  List<Map<dynamic, dynamic>> jsonList = [];
  DocumentSnapshot? lastDocument;

  Future<void> getHistoryData({List<DateTime?>? keyword}) async {
    totalMoney = 0;
    totalCratesToday = 0;
    jsonList = [];
    lastDocument = null;
    hasMore = true;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    emit(TotalHistoryLoading());
    try {
      if (keyword?.isNotEmpty ?? false) {
        if (keyword!.length == 1) {
          querySnapshot = await firestore
              .collection('transactions')
              .where('created_at',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(
                      DateTime(keyword[0]!.year, keyword[0]!.month, keyword[0]!.day)))
              .where('created_at',
                  isLessThanOrEqualTo: Timestamp.fromDate(
                      DateTime(keyword[0]!.year, keyword[0]!.month, keyword[0]!.day + 1)))
              .orderBy("created_at", descending: false)
              .get();
        } else {
          querySnapshot = await firestore
              .collection('transactions')
              .where('created_at',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(
                      DateTime(keyword[0]!.year, keyword[0]!.month, keyword[0]!.day)))
              .where('created_at',
                  isLessThanOrEqualTo: Timestamp.fromDate(
                      DateTime(keyword[1]!.year, keyword[1]!.month, keyword[1]!.day + 1)))
              .orderBy("created_at", descending: false)
              .get();
        }
      } else {
        if (lastDocument == null) {
          querySnapshot = await firestore
              .collection('transactions')
              .orderBy("created_at", descending: true)
              .limit(10)
              .get();
          lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
          if (querySnapshot.docs.length < 10) {
            hasMore = false;
          }
        } else {
          // emit(TotalHistoryLoadMore());
          querySnapshot = await firestore
              .collection('transactions')
              .orderBy("created_at", descending: true)
              .startAfterDocument(lastDocument!)
              .limit(10)
              .get();
          lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        }
      }
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
        if (keyword?.isNotEmpty ?? false) {
          totalMoney = totalMoney! + num.parse(data['amount_received']);
          totalCratesToday = totalCratesToday! + num.parse(data['crate_delivered']);
        }
      }
      if (keyword?.isNotEmpty ?? false) {
        emit(TotalHistoryLoaded(
            jsonList: jsonList,
            totalCratesToday: totalCratesToday,
            totalMoney: totalMoney,
            showSearch: true));
      } else {
        emit(TotalHistoryLoaded(jsonList: jsonList));
      }
    } catch (e) {
      emit(TotalHistoryError());
      print('Error getting region collection data: $e');
    }
  }

  Future<void> loadMore() async {
    if (!hasMore!) {
      return;
    } else {
      emit(TotalHistoryLoaded(jsonList: jsonList, loadMore: true));
      // emit(TotalHistoryLoadMore());
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot;
      try {
        if (lastDocument == null) {
          querySnapshot = await firestore
              .collection('transactions')
              .orderBy("created_at", descending: true)
              .limit(10)
              .get();
          lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        } else {
          querySnapshot = await firestore
              .collection('transactions')
              .orderBy("created_at", descending: true)
              .startAfterDocument(lastDocument!)
              .limit(10)
              .get();
          lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
          if (querySnapshot.docs.length < 10) {
            hasMore = false;
          }
        }
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          jsonList.add(data);
        }
        emit(TotalHistoryLoaded(jsonList: jsonList));
      } catch (e) {
        emit(TotalHistoryError());
        print('Error getting region collection data: $e');
      }
    }
  }
}

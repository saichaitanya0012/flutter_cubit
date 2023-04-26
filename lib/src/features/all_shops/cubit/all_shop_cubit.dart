import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'all_shop_state.dart';

class AllShopCubit extends Cubit<AllShopState> {
  AllShopCubit() : super(AllShopInitial());

  bool? hasMore = true;
  List<Map<dynamic, dynamic>> jsonList = [];
  DocumentSnapshot? lastDocument;

  Future<void> getAllShopsData(
      {String? keyword, String? id, bool isAllShops = true}) async {
    jsonList = [];
    lastDocument = null;
    hasMore = true;
    emit(AllShopLoading());

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      if (keyword != null) {
        if (isAllShops) {
          querySnapshot = await firestore
              .collection('shops')
              .where('shopName', isGreaterThanOrEqualTo: keyword)
              .get();
        } else {
          querySnapshot = await firestore
              .collection('shops')
              .where('line_id', isEqualTo: "")
              .where('shopName', isGreaterThanOrEqualTo: keyword)
              .get();
        }
      } else {
        if (lastDocument == null){
          if (isAllShops) {
            querySnapshot = await firestore
                .collection('shops')
                .orderBy("shopName", descending: true)
                .limit(20)
                .get();
          } else {
            querySnapshot = await firestore
                .collection('shops')
                .where('line_id', isEqualTo: "")
                .orderBy("shopName", descending: true)
                .limit(20)
                .get();
          }
          lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
          if (querySnapshot.docs.length < 10) {
            hasMore = false;
          }
        }else{
          if (isAllShops) {
            querySnapshot = await firestore
                .collection('shops')
                .orderBy("shopName", descending: true)
                .startAfterDocument(lastDocument!)
                .limit(20)
                .get();
          } else {
            querySnapshot = await firestore
                .collection('shops')
                .where('line_id', isEqualTo: "")
                .orderBy("shopName", descending: true)
                .startAfterDocument(lastDocument!)
                .limit(20)
                .get();
          }
          lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
          if (querySnapshot.docs.length < 10) {
            hasMore = false;
          }
        }
        // if (isAllShops) {
        //   querySnapshot = await firestore
        //       .collection('shops')
        //       .orderBy("shopName", descending: true)
        //       .limit(20)
        //       .get();
        // } else {
        //   querySnapshot = await firestore
        //       .collection('shops')
        //       .where('line_id', isEqualTo: "")
        //       .orderBy("shopName", descending: true)
        //       .limit(20)
        //       .get();
        // }
        // lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        // if (querySnapshot.docs.length < 10) {
        //   hasMore = false;
        // }
      }
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      emit(AllShopLoaded(jsonList: jsonList));
    } catch (e) {
      emit(AllShopError(message: e.toString()));
      print('Error getting region collection data: $e');
    }
  }

  Future<void> updateLine(
      String lineId, String lineNumber, String lineName, String shopId,
      {bool updateShopLine = false}) async {
    emit(AllShopLoading());
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final CollectionReference itemsRef = FirebaseFirestore.instance.collection('shops');
      final QuerySnapshot snapshot = await itemsRef
          .where('line_id', isEqualTo: lineId)
          .orderBy('line_number')
          .get();

      final WriteBatch batch = FirebaseFirestore.instance.batch();

      if (snapshot.docs.isEmpty) {
        final QuerySnapshot getLastElement = await itemsRef
            .where('line_id', isEqualTo: lineId)
            .where('line_number', isGreaterThanOrEqualTo: num.parse(lineNumber))
            .orderBy('line_number', descending: true)
            .limit(1)
            .get();
        if (getLastElement.docs.isEmpty) {
          itemsRef.doc(shopId).update({
            'line_number': 1,
            'line_name': lineName,
            "line_id": lineId,
          });
        } else {
          itemsRef.doc(shopId).update({
            'line_number': getLastElement.docs[0]['line_number'] + 1,
            'line_name': lineName,
            "line_id": lineId,
          });
        }
      } else {
        if(updateShopLine){
          final QuerySnapshot snapshot2 = await itemsRef
              .where('line_id', isEqualTo: shopId)
              .orderBy('line_number')
              .get();
          snapshot2.docs.forEach((doc) {
            if(doc['line_number']>num.parse(lineNumber)){
              batch.update(doc.reference, {'line_number': doc['line_number'] - 1});
            }
          });
        }
        snapshot.docs.forEach((doc) {
          if(doc['line_number']>=num.parse(lineNumber)){
            batch.update(doc.reference, {'line_number': doc['line_number'] + 1});
          }
        });

        await batch.commit();
        itemsRef.doc(shopId).update({
          'line_number': num.parse(lineNumber),
          'line_name': lineName,
          "line_id": lineId,
        });
      }
      emit(AllShopLoaded(jsonList: jsonList));

    } catch (e) {
      emit(AllShopError(message: e.toString()));
      print('Error getting region collection data: $e');
    }
  }

  Future<void> fetchMore() async {
    emit(AllShopLoading());
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      querySnapshot = await firestore.collection('shops').get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      emit(AllShopLoaded(jsonList: jsonList));
    } catch (e) {
      emit(AllShopError(message: e.toString()));
      print('Error getting region collection data: $e');
    }
  }
}

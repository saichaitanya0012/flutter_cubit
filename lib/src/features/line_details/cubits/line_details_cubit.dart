import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'line_details_state.dart';

class LineDetailsCubit extends Cubit<LineDetailsState> {
  LineDetailsCubit() : super(LineDetailsInitial());


  Future<void> createLineDetails(
      DateTime date,
      String cratesSent,
      String cratesBack,
      String cratesSold,
      String returnedCrates,
      ) async {
    try {
      emit(LineDetailsLoading());
      final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('line_details').doc();

      final query = FirebaseFirestore.instance.collection('line_details')
          .where('date',
          isEqualTo:
          Timestamp.fromDate(DateTime(date.year, date.month, date.day)))
          .limit(1);

      final snapshot = await query.get();

      final query2 = FirebaseFirestore.instance
          .collection('overall_production_details')
          .where('date',
          isEqualTo: Timestamp.fromDate(DateTime(date.year, date.month, date.day)))
          .limit(1); // limit to 1 document

      final snapshot2 = await query2.get();

      if (snapshot2.docs.isNotEmpty) {
        final docSnapshot2 = snapshot2.docs.first;
        await FirebaseFirestore.instance
            .collection('overall_production_details')
            .doc(docSnapshot2.id)
            .update({
          "crates_sold": cratesSold,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('overall_production_details')
            .doc()
            .set({
          "date": date,
          "total_crates": "0",
          "total_collection": "0",
          "expenses": "0",
          "crates_sold": cratesSold,
          "created_at": DateTime.now(),
        });
      }

      if (snapshot.docs.isNotEmpty) {
        final docSnapshot = snapshot.docs.first;
        await FirebaseFirestore.instance
            .collection('line_details')
            .doc(docSnapshot.id)
            .update({
          "crates_sent": cratesSent,
          "crates_back": cratesBack,
          "crates_sold": cratesSold,
          "returned_crates": returnedCrates,
        });
      } else {
        await documentReference.set({
          "id": documentReference.id,
          "date": date,
          "crates_sent": cratesSent,
          "crates_back": cratesBack,
          "crates_sold": cratesSold,
          "returned_crates": returnedCrates,
          "created_at": DateTime.now(),
        });
      }
      // await documentReference.set({
      //   "id": documentReference.id,
      //   "date": date,
      //   "crates_sent": cratesSent,
      //   "crates_back": cratesBack,
      //   "crates_sold": cratesSold,
      //   "returned_crates": returnedCrates,
      //   "created_at": DateTime.now(),
      // });
      emit(LineDetailsInitial());
    } catch (e) {
      emit(LineDetailsFailed(message: e.toString()));
    }
  }


  Future<void> getLineDetails()async {
    try {
      emit(LineDetailsLoading());
      FirebaseFirestore.instance.collection('line_details').get().then((value) {
        List<Map<dynamic, dynamic>> jsonList = [];
        value.docs.forEach((element) {
          jsonList.add(element.data());
        });
        emit(LineDetailsSuccess(jsonList: jsonList));
      });
    } catch (e) {
      emit(LineDetailsFailed(message: e.toString()));
    }
  }


  Future<List<Map<dynamic, dynamic>>> getLineDetailsBasedOnDate(
      DateTime date) async {
    try {
      emit(LineDetailsLoading());
      List<Map<dynamic, dynamic>> jsonList = [];
      await FirebaseFirestore.instance
          .collection('line_details')
          .where('date',
          isEqualTo:
          Timestamp.fromDate(DateTime(date.year, date.month, date.day)))
          .limit(1)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          jsonList.add(element.data());
        });
        emit(LineDetailsInitial(isUpdate: false));
      });
      print(jsonList);
      return jsonList;
    } catch (e) {
      emit(LineDetailsFailed(message: e.toString()));
      return [];
    }
  }

}

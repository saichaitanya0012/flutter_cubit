import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'management_details_state.dart';

class ManagementDetailsCubit extends Cubit<ManagementDetailsState> {
  ManagementDetailsCubit() : super(ManagementDetailsInitial());

  Future<void> createProductionDetails(
    DateTime date,
    String lineCollection,
    String otherCollection,
    String totalCollection,
      List<Map<String, dynamic>> expenses,
  ) async {
    try {
      emit(ManagementDetailsLoading());

      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('management_details').doc();

      final query = FirebaseFirestore.instance.collection('management_details')
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
          "total_collection": totalCollection,
          "expenses": expenses,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('overall_production_details')
            .doc()
            .set({
          "date": date,
          "total_crates": "0",
          "total_collection": totalCollection,
          "crates_sold": "0",
          "expenses": expenses,
          "created_at": DateTime.now(),
        });
      }
      if (snapshot.docs.isNotEmpty) {
        final docSnapshot = snapshot.docs.first;
        await FirebaseFirestore.instance
            .collection('management_details')
            .doc(docSnapshot.id)
            .update({
          "id": documentReference.id,
          "date": date,
          "line_collection": lineCollection,
          "other_collection": otherCollection,
          "total_collection": totalCollection,
          "expenses": expenses,
          "created_at": DateTime.now(),
        });
      } else {
        await documentReference.set({
          "id": documentReference.id,
          "date": date,
          "line_collection": lineCollection,
          "other_collection": otherCollection,
          "total_collection": totalCollection,
          "expenses": expenses,
          "created_at": DateTime.now(),
        });
      }
      emit(ManagementDetailsInitial(
        isUpdate: true,
      ));

    } catch (e) {
      emit(ManagementDetailsFailed(message: e.toString()));
    }
  }


  Future<void> getManagementDetails()async {
    try {
      emit(ManagementDetailsLoading());
      FirebaseFirestore.instance.collection('management_details').get().then((value) {
        List<Map<dynamic, dynamic>> jsonList = [];
        value.docs.forEach((element) {
          jsonList.add(element.data());
        });
        emit(ManagementDetailsSuccess(jsonList: jsonList));
      });
    } catch (e) {
      emit(ManagementDetailsFailed(message: e.toString()));
    }
  }

  Future<List<Map<dynamic, dynamic>>> getManagementDetailsBasedOnDate(
      DateTime date) async {
    try {
      emit(ManagementDetailsLoading());
      List<Map<dynamic, dynamic>> jsonList = [];
      await FirebaseFirestore.instance
          .collection('management_details')
          .where('date',
          isEqualTo:
          Timestamp.fromDate(DateTime(date.year, date.month, date.day)))
          .limit(1)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          jsonList.add(element.data());
        });
        emit(ManagementDetailsInitial(isUpdate: false));
      });
      print(jsonList);
      return jsonList;
    } catch (e) {
      emit(ManagementDetailsFailed(message: e.toString()));
      return [];
    }
  }
}

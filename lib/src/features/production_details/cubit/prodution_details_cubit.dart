import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'prodution_details_state.dart';

class ProdutionDetailsCubit extends Cubit<ProdutionDetailsState> {
  ProdutionDetailsCubit() : super(ProdutionDetailsInitial());

  Future<void> createProductionDetails(DateTime date, String cratesManufacture,
      String crateLeakage, String crate, String totalCrates, String remarks) async {
    try {
      emit(ProdutionDetailsLoading());
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('production_details').doc();

      final query = FirebaseFirestore.instance
          .collection('production_details')
          .where('date',
              isEqualTo: Timestamp.fromDate(DateTime(date.year, date.month, date.day)))
          .limit(1); // limit to 1 document

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
          "total_crates": totalCrates,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('overall_production_details')
            .doc()
            .set({
          "date": date,
          "total_crates": totalCrates,
          "total_collection": "0",
          "crates_sold": "0",
          "expenses": "0",
          "created_at": DateTime.now(),
        });
      }

      if (snapshot.docs.isNotEmpty) {
        final docSnapshot = snapshot.docs.first;
        await FirebaseFirestore.instance
            .collection('production_details')
            .doc(docSnapshot.id)
            .update({
          "id": documentReference.id,
          "date": date,
          "crates_manufacture": cratesManufacture,
          "crate_leakage": crateLeakage,
          "quality_inspection": crate,
          "total_crates": totalCrates,
          "remarks": remarks,
          "created_at": DateTime.now(),
        });
      } else {
        await documentReference.set({
          "id": documentReference.id,
          "date": date,
          "crates_manufacture": cratesManufacture,
          "crate_leakage": crateLeakage,
          "quality_inspection": crate,
          "total_crates": totalCrates,
          "remarks": remarks,
          "created_at": DateTime.now(),
        });
      }

      emit(ProdutionDetailsInitial());
    } catch (e) {
      emit(ProdutionDetailsFailed(message: e.toString()));
    }
  }

  Future<void> getProductionDetails() async {
    try {
      emit(ProdutionDetailsLoading());
      FirebaseFirestore.instance.collection('production_details').get().then((value) {
        List<Map<dynamic, dynamic>> jsonList = [];
        value.docs.forEach((element) {
          jsonList.add(element.data());
        });
        emit(ProdutionDetailsSuccess(jsonList: jsonList));
      });
    } catch (e) {
      emit(ProdutionDetailsFailed(message: e.toString()));
    }
  }

  Future<List<Map<dynamic, dynamic>>> getProductionDetailsBasedOnDate(
      DateTime date) async {
    try {
      emit(ProdutionDetailsLoading());
      List<Map<dynamic, dynamic>> jsonList = [];
      await FirebaseFirestore.instance
          .collection('production_details')
          .where('date',
              isEqualTo: Timestamp.fromDate(DateTime(date.year, date.month, date.day)))
          .limit(1)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          jsonList.add(element.data());
        });
        emit(ProdutionDetailsInitial(isUpdate: false));
      });
      print(jsonList);
      return jsonList;
    } catch (e) {
      emit(ProdutionDetailsFailed(message: e.toString()));
      return [];
    }
  }
}

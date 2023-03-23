import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'day_report_state.dart';

class DayReportCubit extends Cubit<DayReportState> {
  DayReportCubit() : super(DayReportInitial());


  Future<void> getDayReportData() async {
    emit(DayReportLoading());
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      querySnapshot = await firestore.collection('collections')
          .orderBy("date",descending: true).get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data=documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      emit(DayReportSuccess(jsonList: jsonList));
    } catch (e) {
      emit(DayReportFailed(message: e.toString()));
      print('Error getting region collection data: $e');
    }
  }
}

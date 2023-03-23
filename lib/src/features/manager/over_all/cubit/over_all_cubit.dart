import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'over_all_state.dart';

class OverAllCubit extends Cubit<OverAllState> {
  OverAllCubit() : super(OverAllInitial());


  Future<void> getOverAllDetails() async {
    try {
      emit(OverAllLoading());
      FirebaseFirestore.instance.collection('overall_production_details').get().then((value) {
        List<Map<dynamic, dynamic>> jsonList = [];
        value.docs.forEach((element) {
          jsonList.add(element.data());
        });
        emit(OverAllSuccess(jsonList: jsonList));
      });
    } catch (e) {
      emit(OverAllFailed(message: e.toString()));
    }
  }
}

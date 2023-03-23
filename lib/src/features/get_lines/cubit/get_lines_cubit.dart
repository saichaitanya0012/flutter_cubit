import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:meta/meta.dart';

part 'get_lines_state.dart';

class GetLinesCubit extends Cubit<GetLinesState> {
  GetLinesCubit() : super(GetLinesInitial());

  List<Map<dynamic, dynamic>> jsonList = [];
  Future<void> getRegionCollectionData({String? keyword}) async {
    emit(GetLinesLoading());

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      if(keyword!=null) {
        querySnapshot = await firestore.collection('lines').where('name', isGreaterThanOrEqualTo: keyword).get();
      }else {
        querySnapshot = await firestore.collection('lines').get();
      }
      jsonList.clear();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data=documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      emit(GetLinesLoaded(jsonList: jsonList));
    } catch (e) {
      emit(GetLinesError());
      print('Error getting region collection data: $e');
    }
  }


  void addLine( pin,lineName){
    emit(GetLinesLoading());
    getPin().then((value) {
      if (value == pin) {
        final value=FirebaseFirestore.instance.collection('lines').doc();
        value.set({
          "id": value.id,
          "name": lineName,
        }).then((value) {
          getRegionCollectionData();
        }).catchError((error) {
          emit(GetLinesError(message: 'Error: ${error}'));
        });
      } else {
        emit(GetLinesLoaded(jsonList: jsonList));
        CustomSnackBar().snackbarMessage(message: 'Invalid Pin');
      }
    });
  }

  Future<String?> getPin() async {
    List<Map<dynamic, dynamic>> jsonList = [];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot;
    try {
      querySnapshot = await firestore.collection('admin_pin').get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        jsonList.add(data);
      }
      if (jsonList.isNotEmpty) {
        return jsonList[0]['pin'];
      } else {
        return "1234";
      }
    } catch (e) {
      print('Error getting region collection data: $e');
    }
    return null;
  }
}

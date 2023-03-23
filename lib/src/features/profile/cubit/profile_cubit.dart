import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:goli_soda/src/local_storage/hive_store.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());


  FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadImageToFirebaseStorage(File imageFile) async {
    try {
      emit(ProfileLoading());
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(
        HiveStore().get(Keys.userId),
      ).update({
        "image_url": downloadUrl,
      });
      CustomSnackBar().snackbarMessage(message: 'Image uploaded successfully');
      HiveStore().put(Keys.imageUrl, downloadUrl);
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileFailed(message: 'Error: ${e}'));
      print(e);
    }
  }
}

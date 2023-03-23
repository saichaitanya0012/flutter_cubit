import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goli_soda/src/local_storage/hive_store.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  void signUpWithEmailPassword(String email, String password) async {
    try {
      emit(SignUpLoading());
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
        'image_url': "",
        "is_manager": false,
      });
      HiveStore().put(Keys.userId, userCredential.user!.uid);
      HiveStore().put(Keys.userName, userCredential.user!.email.toString());
      HiveStore().put(Keys.isManager, false);
      HiveStore().put(Keys.imageUrl, "");
      // HiveStore().put(Keys.imageUrl, "");
      emit(SignUpSuccess());
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpFailed(message: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpFailed(message: 'The account already exists for that email.'));
      } else {
        emit(SignUpFailed(message: 'Error: ${e.message}'));
      }
    } catch (e) {
      emit(SignUpFailed());
    }
  }
}

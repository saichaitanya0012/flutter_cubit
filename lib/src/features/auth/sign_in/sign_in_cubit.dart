import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goli_soda/src/local_storage/hive_store.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginWithEmail(String email, String password) async {
    try {
      emit(SignInLoading());
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      HiveStore().put(Keys.userId, userCredential.user!.uid);
      HiveStore().put(Keys.userName, userCredential.user!.email.toString());
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).get().then((value) {
        if (value.exists) {
          HiveStore().put(Keys.imageUrl, value.data()!['image_url']);
          HiveStore().put(Keys.isManager, value.data()!['is_manager']);
        }
      });
      emit(SignInSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SignInFailed(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(SignInFailed(message: 'Wrong password provided for that user.'));
      } else {
        emit(SignInFailed(message: 'Error: ${e.message}'));
      }
    }catch (e) {
      emit(SignInFailed());
    }
  }

}

import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zezo/classes/validation/class.dart';
import '../navigatorbar/view.dart';
import 'states.dart';

class SignInController extends Cubit<SignInStates> {
  SignInController() : super(InitialState());
  static SignInController get(context) => BlocProvider.of(context);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSwitch = true;
  SharedPreferences? preferences;
  final validation = Validation();
  visable() {
    isSwitch = !isSwitch;
    emit(ChangeState());
  }

  onChangeEmail() {
    validation.formKey.currentState!.validate();
    emit(ValidEmailState());
  }

  onChangePassword() {
    validation.formKey.currentState!.validate();
    emit(ValidPasswordState());
  }

  bool isLoading = false;
  signIn(context) {
    isLoading = true;
    emit(CheckSignIn());
    log("0");
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) async {
        try {
          await SharedPreferences.getInstance().then((val) {
            val.setString("user_id", value.user!.uid);
            val.setString("frist_time", "no");
            val.setString("auth", "yes");
            isLoading = false;
            emit(DoneSignIn());
            Fluttertoast.showToast(
              msg: "SUCCESS",
            );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavigatorBarScreen()),
                (route) => false);
          });
        } on FirebaseAuthException catch (e) {
          isLoading = false;
          emit(DoneSignIn());
          Fluttertoast.showToast(
            msg: "$e",
          );
        }
      }).onError<FirebaseAuthException>((error, stackTrace) {
        isLoading = false;
        emit(DoneSignIn());
        Fluttertoast.showToast(
          msg: error.message!,
        );
      });
    } catch (e) {
      isLoading = false;
      emit(DoneSignIn());
      Fluttertoast.showToast(
        msg: "$e",
      );
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

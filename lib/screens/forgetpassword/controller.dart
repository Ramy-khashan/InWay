import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../classes/validation/class.dart';
import 'states.dart';

class ForgetPasswordController extends Cubit<ForgetPasswordStates> {
  final emailController = TextEditingController();

  final validation = Validation();

  ForgetPasswordController() : super(InitialState());
  static ForgetPasswordController get(context) => BlocProvider.of(context);
  onChangeEmail() {
    validation.formKey.currentState!.validate();
    emit(ValidEmailState());
  }

  getPassword(context,Size size) async {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim())
        .whenComplete(() {
      emailController.clear();
      AwesomeDialog(
          context: context,
          body: Text(
            "Check your mail to rest your password",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size.shortestSide*.045),
          )).show();
    });
  }
}

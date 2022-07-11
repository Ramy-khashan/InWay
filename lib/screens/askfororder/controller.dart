import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:zezo/classes/validation/class.dart';

import 'state.dart';

class AskForOrderController extends Cubit<AskForOrderState> {
  AskForOrderController() : super(InitialState());
  static AskForOrderController get(context) => BlocProvider.of(context);
  final orderController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  Validation validation = Validation();
  bool isClick = false;
  initialData() {
    FirebaseFirestore.instance
        .collection("users")
        .where(
          "user_id",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get()
        .then((value) {
      phoneController.text = value.docs[0].get("phone");
      emailController.text =
          FirebaseAuth.instance.currentUser!.email.toString();

      emit(GetInfoState());
    });
  }

  addSpecialOrder() {
    isClick = true;
    emit(IsLoadingState());
    FirebaseFirestore.instance.collection("specialOrder").add({
      "special_order": orderController.text,
      "full_name": fullNameController.text,
      "description": descriptionController.text,
      "email": emailController.text,
      "specialorderid_num": Random().nextInt(10000000),
      "phone": phoneController.text,
      "address": addressController.text,
      "user_id": FirebaseAuth.instance.currentUser!.uid,
      "date": DateFormat.yMEd().format(DateTime.now()),
      "time": DateFormat.jm().format(DateTime.now()),
    }).then((value) {
      FirebaseFirestore.instance
          .collection("specialOrder")
          .doc(value.id)
          .update({"specialorder_id": value.id}).whenComplete(() {
        descriptionController.clear();
        emailController.clear();
        phoneController.clear();
        fullNameController.clear();
        orderController.clear();
        Fluttertoast.showToast(msg: "Special Order Added.");

        isClick = false;

        emit(IsLoadingState());
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(msg: "Something went wrong, try again!");
        isClick = false;

        emit(IsLoadingState());
      });
    });
  }
}

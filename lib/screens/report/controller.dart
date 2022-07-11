import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:zezo/classes/validation/class.dart';
import 'package:zezo/components/button.dart';

import '../../components/textfield.dart';
import 'state.dart';

class ReportsController extends Cubit<ReportState> {
  ReportsController() : super(InitialState());
  static ReportsController get(cnt) => BlocProvider.of(cnt);
  TextEditingController reportTitleController = TextEditingController();
  TextEditingController reportDescriptionController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String? name;
  String? phone;
  getPersonalInformation() {
    log("LOLLLLL");
    log(user!.uid + " ============= ");
    FirebaseFirestore.instance
        .collection("users")
        .where(
          "user_id",
          isEqualTo: user!.uid,
        )
        .get()
        .then((value) {
      log(value.docs[0].get("username"));
      name = value.docs[0].get("username");
      phone = value.docs[0].get("phone");
      emit(AddingPersonalInfoState());
    });
  }

  Validation validation = Validation();
  addReport(context, Size size) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              content: Form(
                key: validation.formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: size.longestSide * .02,
                      horizontal: size.shortestSide * .05),
                  height: size.longestSide * .5,
                  width: size.shortestSide,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldItem(
                        controller: reportTitleController,
                        size: size,
                        icon: Icons.note_alt_rounded,
                        onValid: (val) => validation.repportTitle(val),
                        lable: "Report Title",
                      ),
                      TextFieldItem(
                        controller: reportDescriptionController,
                        size: size,
                        onValid: (val) => validation.descrtiption(val),
                        lines: 3,
                        icon: Icons.description,
                        lable: "Report Description",
                      ),
                      const Spacer(),
                      ButtonItem(
                        name: "Add Report",
                        onPressed: () {
                          if (validation.formKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection("reports")
                                .add({
                              "name": name,
                              "phone": phone,
                              "email": user!.email,
                              "user_id": user!.uid,
                              "report_title": reportTitleController.text.trim(),
                              "report_desc":
                                  reportDescriptionController.text.trim(),
                              "report_num": math.Random().nextInt(1000000000),
                              "date": DateFormat.yMEd().format(DateTime.now()),
                              "time": DateFormat.jm().format(DateTime.now()),
                            }).then((value) {
                              FirebaseFirestore.instance
                                  .collection("reports")
                                  .doc(value.id)
                                  .update({"report_id": value.id});
                              Fluttertoast.showToast(msg: "Success");
                              reportTitleController.clear();
                              reportDescriptionController.clear();

                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Fluttertoast.showToast(
                                  msg: "Something went wrong!");
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}

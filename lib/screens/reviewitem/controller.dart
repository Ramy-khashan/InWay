import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'state.dart';

class ReviewItemController extends Cubit<ReviewItemStates> {
  ReviewItemController() : super(InitialState());
  static ReviewItemController get(context) => BlocProvider.of(context);

  User? user = FirebaseAuth.instance.currentUser;
  toFavorite(id) {
    bool isExsist = false;
    FirebaseFirestore.instance
        .collection("favorite")
        .where(
          "user_id",
          isEqualTo: user!.uid,
        )
        .get()
        .then((value) {
      log(value.docs.length.toString());
      for (var element in value.docs) {
        if (element.get("product_id") == id) {
          isExsist = true;
          log(isExsist.toString());
          emit(IsExsistState());
        }
      }
    }).whenComplete(() {
      if (!isExsist) {
        FirebaseFirestore.instance
            .collection("favorite")
            .add({"product_id": id, "user_id": user!.uid}).then((val) {
          FirebaseFirestore.instance.collection("favorite").doc(val.id).update({
            "fav_item": val.id,
          });
          Fluttertoast.showToast(msg: "Added to favorite");
        });
      } else {
        Fluttertoast.showToast(msg: "Already Exsist");
        isExsist = true;
        emit(IsExsistState());
      }
    });
  }

  bool isLoading = false;

  addItemToCart(id) {
    isLoading = true;
    emit(IsLoadingState());

    bool isExsist = false;
    FirebaseFirestore.instance
        .collection("cart")
        .where(
          "user_id",
          isEqualTo: user!.uid,
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element.get("product_id") == id) {
          log(element.get("product_id") + "===========" + id);
          isExsist = true;
          emit(IsExsistState());
        }
      }
    }).whenComplete(() {
      if (!isExsist) {
        FirebaseFirestore.instance.collection("cart").add({
          "product_id": id,
          "quantity": 1,
          "user_id": FirebaseAuth.instance.currentUser!.uid,
          "state": "Waiting"
        }).then((value) {
          FirebaseFirestore.instance.collection("cart").doc(value.id).update({
            "cartItem_id": value.id,
          }).whenComplete(() {
            Fluttertoast.showToast(msg: "Added to Cart.");
          });
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: "Faild to Adding Product.");
        });
      } else {
        Fluttertoast.showToast(msg: "Already Exsist");
      }

      isLoading = false;
      emit(IsLoadingState());
    });
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class CartController extends Cubit<CartStates> {
  CartController() : super(InitialState());
  static CartController get(context) => BlocProvider.of(context);
  deleteCartItem(id) {
    FirebaseFirestore.instance.collection("cart").doc(id).delete();
  }

  double totalPrice = 0;
  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;

  changeQuantity(id, q, type) {
    if (type == "+") {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(id)
          .update({"quantity": q + 1});
    } else {
      if (q > 1) {
        FirebaseFirestore.instance
            .collection("cart")
            .doc(id)
            .update({"quantity": q - 1});
      }
    }
  }

  double sum = 0;
  getTotal(productsId, quantitys) async {
    isLoading = true;
    emit(IsLoadingState());

    List<List<String>> price = [];
    for (int i = 0; i < productsId.length; i++) {
      await FirebaseFirestore.instance
          .collection("product")
          .doc(productsId[i])
          .get()
          .then((value) {
        price.add([value.get("price").toString(), quantitys[i].toString()]);
        double x = double.parse(price[i][0]) * double.parse(price[i][1]);
        log(x.toString() + " value");
        sum += x;
        emit(AddingToListState());

        /*  double.parse(quantitys[i].toString()) *
            double.parse(value.get("price")); */
      }).onError((error, stackTrace) {
        log("Error");
      });
    }
    log(sum.toString());

    isLoading = false;
    emit(IsLoadingState());
  }
}

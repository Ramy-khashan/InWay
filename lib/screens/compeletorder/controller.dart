import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:zezo/screens/navigatorbar/view.dart';

import '../../classes/validation/class.dart';
import 'state.dart';

class CompeletOrderController extends Cubit<CompeletOrderState> {
  CompeletOrderController() : super(InitialState());
  static CompeletOrderController get(context) => BlocProvider.of(context);
  double delivery = 20.0;
  final addressController = TextEditingController();
  bool isDone = false;
  int radioValue = 0;
  changeValue(value) {
    if (value == 0) {
      radioValue = 0;
    } else {
      radioValue = 1;
    }
    emit(ChangValueState());
  }

  static const platform =
      MethodChannel("com.flutter.paymobPayment/nativePayment");
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  String? name;
  String? phone;

  String? paymentToken;
  String apiKey =
      "ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6VXhNaUo5LmV5SnVZVzFsSWpvaWFXNXBkR2xoYkNJc0ltTnNZWE56SWpvaVRXVnlZMmhoYm5RaUxDSndjbTltYVd4bFgzQnJJam94TnpRek16TjkudTljTzdaMFBQRUZXdHUyVXVyb3B3TV9XUWZoNUl0Q1lWNGpHMWZGMTNCSzBaTzd0V3Z5bVNueXdvTnpDU3VWa3Rib2NTOWtwRlZPWkNmLTIzbGo3b2c=";
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

  onOrder(List productsId, List quantitys, cartId, totalPrice, context,
      String type) async {
    log(user!.email!);
    log(name!);
    log(phone!);
    log(totalPrice.toString());
    isLoading = true;
    emit(IsLoadingState());
    FirebaseFirestore.instance.collection("order").add({
      "user_id": user!.uid,
      "products_id": productsId,
      "quantitys": quantitys,
      "totalPrice": totalPrice.toString(),
      "state": "waiting",
      "phone": phone,
      "name": name,
      "orderType": type,
      "address": addressController.text,
      "email": user!.email,
      "orderid_num": math.Random().nextInt(10000000),
      "date": DateFormat.yMEd().format(DateTime.now()),
      "time": DateFormat.jm().format(DateTime.now()),
    }).then((value) {
      FirebaseFirestore.instance
          .collection("order")
          .doc(value.id)
          .update({"order_id": value.id}).whenComplete(() {
        isLoading = false;
        emit(IsLoadingState());
        Fluttertoast.showToast(
          msg: "Adding Order",
        );
        FirebaseFirestore.instance.collection("cart").get().then((value) {
          for (var element in value.docs) {
            if (element.get("user_id") == user!.uid) {
              FirebaseFirestore.instance
                  .collection("cart")
                  .doc(element.get("cartItem_id"))
                  .delete();
            }
          }
        }).whenComplete(() {
          isLoading = false;
          isDone = true;
          emit(IsLoadingState());

          Timer(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavigatorBarScreen()),
                (route) => false);
          });
        });
      });
    }).onError((error, stackTrace) {
      isLoading = false;
      emit(IsLoadingState());
      Fluttertoast.showToast(msg: "Something went wrong, Try again!");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavigatorBarScreen()),
          (route) => false);
    });
  }

  Future<void> getPaymentToken() async {
    paymentToken = await createPaymentToken(apiKey);
    log("Token  : " + paymentToken!);
  }

  Future<String> createPaymentToken(var apiKey) async {
    log("https://accept.paymob.com/api/auth/tokens");
    var response = await Dio().post(
      "https://accept.paymob.com/api/auth/tokens",
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: {"api_key": apiKey},
    );
    if (response.statusCode == 201) {
      log("---------------------------------------------------------------");
      log(response.data["token"].toString());
      log("---------------------------------------------------------------");
      return response.data["token"];
    } else {
      log("error for get Token");
      return "error";
    }
  }

  Future startPaymentActivity(String token) async {
    try {
      return await platform
          .invokeMethod('startPaymentActivity', {"token": token});
    } on PlatformException catch (e) {
      log("Error" + e.toString());
    }
  }

  Future<void> pickPayment(double totalPrice, List productsId, List quantitys,
      cartId, context) async {
    var token = await createPaymentKey(paymentToken, totalPrice);

    log(token.toString());
    var result = await startPaymentActivity(token);
    log("Result:      " + result.toString());
    if (result == "SUCCESS") {
      onOrder(
          productsId, quantitys, cartId, totalPrice, context, "Pay By Visa");
    } else {
      Fluttertoast.showToast(msg: "Faild to add order try again");
      isLoading = false;
      emit(IsLoadingState());
    }
  }

  Future<String> createPaymentKey(var paymentToken, double price) async {
    log("https://accept.paymob.com/api/acceptance/payment_keys");

    log(paymentToken.toString());
    var response = await Dio()
        .post("https://accept.paymob.com/api/acceptance/payment_keys",
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: {
          "auth_token": paymentToken,
          "amount_cents": (price * 100).toString(),
          "expiration": 122254513513,
          "billing_data": {
            "apartment": "803",
            "floor": "42",
            "building": "8028",
            "email": user!.email.toString(),
            "first_name": name,
            "street": "Egypt",
            "phone_number": phone,
            "shipping_method": "PKG",
            "postal_code": "12345",
            "city": "cairo",
            "country": "EG",
            "last_name": " _",
            "state": "Cairo"
          },
          "currency": "EGP",
          "integration_id": 2065427,
          "lock_order_when_paid": "false"
          // "integration_id": 37045
        });

    if (response.statusCode == 201) {
      return response.data["token"];
    } else {
      log(response.toString());
      log("error for get Token");
      return "error";
    }
  }
}

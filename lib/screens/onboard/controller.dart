import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'states.dart';

class OnBoardController extends Cubit<OnBoardStates> {
  OnBoardController() : super(InitialState());
  static OnBoardController get(context) => BlocProvider.of(context);
  List<String> data = [
    "Have best shopping and see amazing product to buy",
    "Online payment to make your shopping easy and have good experience",
    "Shopping and will it deliver to your place with minimum benfit"
  ];
  SharedPreferences? preferences;
  getPref() async {
    preferences = await SharedPreferences.getInstance();

    preferences!.setString("frist_time", "no");
  }

  List<String> img = [
    "assets/images/onlineShopping.png",
    "assets/images/payment.png",
    "assets/images/deliveryOrder.png"
  ];
  int index = 0;
  final pageViewController = PageController();

  onChangePage(val) {
    index = val;
    pageViewController.animateToPage(val,
        duration: const Duration(milliseconds: 1500), curve: Curves.bounceOut);
    emit(ChangeState());
  }
}

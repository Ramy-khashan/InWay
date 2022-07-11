import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zezo/screens/askfororder/view.dart';
import 'package:zezo/screens/categories/view.dart';
import 'package:zezo/screens/favorite/view.dart';
import 'package:zezo/screens/homepage/view.dart';

import '../setting/view.dart';
import 'states.dart';

class NavigatorBarController extends Cubit<NavigatorBarStates> {
  NavigatorBarController() : super(InitialNavigatorState());
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  bool? connected;
  var widgetOptions = [
    const HomePageScreen(),
    const CategoriesScreen(),
    const AskForOrderScreen(),
    const FavoriteScreen(),
    const SettingScreen(),
  ];
  static NavigatorBarController get(context) => BlocProvider.of(context);
  void onTap(int index) {
    emit(SwitchNavigatorState());
    selectedIndex = index;
  }
}

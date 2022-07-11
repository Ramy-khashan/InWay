import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zezo/components/settingite.dart';
import 'package:zezo/screens/flashpage/view.dart';

import '../../components/appbar.dart';
import '../order/view.dart';
import '../report/view.dart';
import '../specialorder/view.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, size, "Setting",true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: size.longestSide * .01,
            horizontal: size.shortestSide * .015),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SettingItem(
              icon: Icons.folder,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserOrderScreen()));
              },
              size: size,
              title: "Orders",
            ),
            SettingItem(
              icon: Icons.folder_special,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserSpecialOrderScreen()));
              },
              size: size,
              title: "Special Order",
            ),
            SettingItem(
              icon: Icons.report,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserReportsScreen()));
              },
              size: size,
              title: "Reports",
            ),
            SettingItem(
              icon: Icons.logout_outlined,
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) async {
                  await SharedPreferences.getInstance().then((value) {
                    value.setString("auth", "");
                  });

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FlashScreen()),
                      (route) => false);
                });
              },
              size: size,
              title: "Sign Out",
            ),
          ],
        ),
      ),
    );
  }
}

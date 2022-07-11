import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/cart/view.dart';

PreferredSizeWidget mainAppBar(context, size, head, bool isCartNedded) {
  return AppBar(
    centerTitle: true,
    title: Text(
      head,
      style: TextStyle(fontFamily: "One", fontSize: size.shortestSide * .08),
    ),
    toolbarHeight: size.longestSide * .07,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Theme.of(context).primaryColor],
        ),
      ),
    ),
    actions: isCartNedded
        ? [
            Stack(
              children: [
                IconButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.shortestSide * .05),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()));
                    },
                    icon: Icon(Icons.shopping_cart_outlined,
                        size: size.shortestSide * .08)),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: size.shortestSide * .03,
                    backgroundColor: Colors.red.shade600.withOpacity(.7),
                    child: Center(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("cart")
                                .where("user_id",
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                return const Text(
                                  "0",
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            })),
                  ),
                ),
              ],
            ),
          ]
        : [],
  );
}

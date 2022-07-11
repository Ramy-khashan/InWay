import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zezo/components/viewitem.dart';
import 'package:zezo/screens/reviewitem/view.dart';

import '../../components/appbar.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, size, "Home",true),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("product").get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data!.docs.length.toString());
            return GridView.count(
              childAspectRatio: 2 / 2.7,
              crossAxisCount: 2,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: size.shortestSide * .02,
                  vertical: size.longestSide * .02),
              crossAxisSpacing: size.shortestSide * .03,
              mainAxisSpacing: size.longestSide * .015,
              children: List.generate(
                  snapshot.data!.docs.length,
                  (index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewItemScreen(
                                        id: snapshot.data!.docs[index].id,
                                      )));
                        },
                        child: ViewItem(
                          img: snapshot.data!.docs[index].get('image'),
                          name: snapshot.data!.docs[index].get("name"),
                          price: snapshot.data!.docs[index].get("price"),
                          size: size,
                          onTap: () {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            log(auth.currentUser!.email.toString());
                          },
                        ),
                      )),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

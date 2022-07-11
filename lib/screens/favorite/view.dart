import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/appbar.dart';
import '../../components/emptyshape.dart';
import '../../components/viewitem.dart';
import '../reviewitem/view.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, size, "Favorite",true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("favorite")
            .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasData) {
            if (snapShot.data!.docs.isEmpty) {
              return EmptyShapeItem(
                size: size,
              );
            } else {
              return GridView.count(
                childAspectRatio: 2 / 2.7,
                crossAxisCount: 2,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: size.shortestSide * .02,
                    vertical: size.longestSide * .02),
                crossAxisSpacing: size.shortestSide * .03,
                mainAxisSpacing: size.longestSide * .015,
                children: List.generate(snapShot.data!.docs.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewItemScreen(
                                    id: snapShot.data!.docs[index]
                                        .get('product_id'),
                                    isFav: true,
                                  )));
                    },
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("product")
                          .doc(snapShot.data!.docs[index].get('product_id'))
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              ViewItem(
                                img: snapshot.data!.get('image'),
                                name: snapshot.data!.get("name"),
                                price: snapshot.data!.get("price"),
                                size: size,
                                onTap: () {},
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("favorite")
                                        .doc(snapShot.data!.docs[index]
                                            .get("fav_item"))
                                        .delete()
                                        .then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Deleting Success!");
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.orange.shade800,
                                    size: size.shortestSide * .1,
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  );
                }),
              );
            }
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

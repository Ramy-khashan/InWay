import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import '../../components/emptyshape.dart';
import '../../components/viewitem.dart';
import '../reviewitem/view.dart';

class ViewCategoryScreen extends StatelessWidget {
  const ViewCategoryScreen({this.catList, this.catName, Key? key})
      : super(key: key);
  final String? catName;
  final List? catList;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(
        context,
        size,
        catName!,
        true
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("product")
              .where("category", isEqualTo: catName)
              .get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
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
                  children: List.generate(snapshot.data!.docs.length, (index) {
                    return InkWell(
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
                          FirebaseFirestore.instance
                              .collection("product")
                              .doc(snapshot.data!.docs[index].id)
                              .update({
                            "isfav": !snapshot.data!.docs[index].get("isfav")
                          });
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
          }),
    );
  }
}

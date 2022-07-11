import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zezo/screens/viewcategory/view.dart';

import '../../components/appbar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, size, "Category",true),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("categories").get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              childAspectRatio: 2 / 2.5,
              crossAxisCount: 2,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: size.shortestSide * .02,
                  vertical: size.longestSide * .02),
              crossAxisSpacing: size.shortestSide * .05,
              mainAxisSpacing: size.longestSide * .025,
              children: List.generate(
                  snapshot.data!.docs.length,
                  (i) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ViewCategoryScreen(
                                        catName: snapshot.data!.docs[i]
                                            .get('category_name'),
                                      ))));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 6,
                                    color: Colors.grey,
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color:Theme.of(context).cardColor,
                              image: DecorationImage(
                                  image: NetworkImage(snapshot.data!.docs[i]
                                      .get('category_img')),
                                  fit: BoxFit.fill)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: size.longestSide * .06),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(.7)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Text(
                              snapshot.data!.docs[i].get('category_name'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size.shortestSide * .05,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
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

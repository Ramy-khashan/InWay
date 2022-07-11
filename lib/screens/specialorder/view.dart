import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/appbar.dart';
import '../../components/emptyshape.dart';
import '../../components/feedback.dart';

class UserSpecialOrderScreen extends StatelessWidget {
  const UserSpecialOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, size, "Special Order", false),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("specialOrder")
            .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? EmptyShapeItem(
                    size: size,
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      vertical: size.longestSide * .014,
                    ),
                    itemBuilder: (context, index) {
                      return FeedBackItem(
                        desc: snapshot.data!.docs[index].get("description"),
                        id: snapshot.data!.docs[index]
                            .get("specialorderid_num")
                            .toString(),
                        date: snapshot.data!.docs[index].get("date"),
                        name: snapshot.data!.docs[index].get("full_name"),
                        phone: snapshot.data!.docs[index].get("phone"),
                        title: snapshot.data!.docs[index].get("special_order"),
                        time: snapshot.data!.docs[index].get("time"),
                        feedbackType: "Order",
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
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

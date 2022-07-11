import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/appbar.dart';
import '../../components/emptyshape.dart';
import '../../components/feedback.dart';
import 'controller.dart';
import 'state.dart';

class UserReportsScreen extends StatelessWidget {
  const UserReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ReportsController()..getPersonalInformation(),
      child: BlocBuilder<ReportsController, ReportState>(
        builder: (context, state) {
          final controller = ReportsController.get(context);
          return Scaffold(
            appBar: mainAppBar(context, size, "Reports", false),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue.shade900,
              onPressed: () {
                controller.addReport(context, size);
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("reports")
                  .where("user_id",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
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
                              desc:
                                  snapshot.data!.docs[index].get("report_desc"),
                              id: snapshot.data!.docs[index]
                                  .get("report_num")
                                  .toString(),
                              date: snapshot.data!.docs[index].get("date"),
                              name: snapshot.data!.docs[index].get("name"),
                              phone: snapshot.data!.docs[index].get("phone"),
                              title: snapshot.data!.docs[index]
                                  .get("report_title"),
                              time: snapshot.data!.docs[index].get("time"),
                              feedbackType: "Report",
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
        },
      ),
    );
  }
}

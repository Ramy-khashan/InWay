import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zezo/components/emptyshape.dart';

import '../../components/appbar.dart';
import '../../components/orderinfo.dart';

class UserOrderScreen extends StatelessWidget {
  const UserOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, size, "Order", false),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("order")
              .where("user_id",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                    color: Colors.grey)
                              ]),
                          margin: EdgeInsets.symmetric(
                              vertical: size.longestSide * .01,
                              horizontal: size.shortestSide * .03),
                          padding: EdgeInsets.symmetric(
                              vertical: size.longestSide * .02,
                              horizontal: size.shortestSide * .03),
                          child: Column(children: [
                            SizedBox(
                              height: size.longestSide * .01,
                            ),
                            Center(
                              child: OrderInfoItem(
                                  item: snapshot.data!.docs[index]
                                      .get("orderid_num")
                                      .toString(),
                                  size: size,
                                  head: "Order id",
                                  fontSize: .05),
                            ),
                            OrderInfoItem(
                                item: snapshot.data!.docs[index].get("name"),
                                size: size,
                                head: "Name",
                                fontSize: .043),
                            OrderInfoItem(
                                item: snapshot.data!.docs[index].get("phone"),
                                size: size,
                                head: "Phone",
                                fontSize: .043),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OrderInfoItem(
                                    item:
                                        snapshot.data!.docs[index].get("date"),
                                    size: size,
                                    head: "Date",
                                    fontSize: .04),
                                OrderInfoItem(
                                    item:
                                        snapshot.data!.docs[index].get("time"),
                                    size: size,
                                    head: "Time",
                                    fontSize: .04),
                              ],
                            ),
                            SizedBox(
                              height: size.longestSide * .01,
                            ),
                            const Divider(
                              thickness: .8,
                              color: Colors.black,
                            ),
                            Text(
                              "Products in order",
                              style: TextStyle(
                                  fontSize: size.shortestSide * .05,
                                  fontWeight: FontWeight.w500),
                            ),
                            Column(
                              children: List.generate(
                                snapshot.data!.docs[index]
                                    .get("products_id")
                                    .length,
                                (i) => FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection("product")
                                      .doc(snapshot.data!.docs[index]
                                          .get("products_id")[i])
                                      .get(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapShot) {
                                    if (snapShot.hasData) {
                                      return ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            snapShot.data!.get("image"),
                                            fit: BoxFit.fill,
                                            width: size.shortestSide * .2,
                                            height: size.longestSide * .1,
                                          ),
                                        ),
                                        title: Text(snapShot.data!.get("name")),
                                        subtitle: Text("Price" +
                                            snapShot.data!.get("price") +
                                            " LE."),
                                        trailing: Text(
                                            "Quantity : ${snapshot.data!.docs[index].get("quantitys")[i]}"),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: size.longestSide * .01,
                            ),
                            Center(
                              child: OrderInfoItem(
                                  item: snapshot.data!.docs[index]
                                      .get("orderType"),
                                  size: size,
                                  head: "Payment Type",
                                  fontSize: .04),
                            ),
                            Center(
                              child: OrderInfoItem(
                                  item: snapshot.data!.docs[index]
                                      .get("totalPrice")
                                      .toString(),
                                  size: size,
                                  head: "Total Price",
                                  fontSize: .043),
                            ),
                            Center(
                              child: OrderInfoItem(
                                  item:
                                      snapshot.data!.docs[index].get("state") ==
                                              "accepted"
                                          ? "Accepted"
                                          : snapshot.data!.docs[index]
                                                      .get("state") ==
                                                  "compelet"
                                              ? "Order Recived"
                                              : snapshot.data!.docs[index]
                                                          .get("state") ==
                                                      "review"
                                                  ? "In Review"
                                                  : "Waiting",
                                  size: size,
                                  head: "State",
                                  fontSize: .043),
                            ),
                          ]),
                        );
                      },
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zezo/components/button.dart';
import 'package:zezo/screens/cart/controller.dart';
import 'package:zezo/screens/cart/state.dart';
import '../../components/appbar.dart';
import '../../components/emptyshape.dart';
import '../compeletorder/view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => CartController(),
      child: Scaffold(
        appBar: mainAppBar(context, size, "Cart", false),
        body: BlocBuilder<CartController, CartStates>(
          builder: (context, state) {
            final controller = CartController.get(context);
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("cart")
                  .where("user_id",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      snapshot.data!.docs.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/emptyCard.png",
                                    width: size.shortestSide * .7),
                                EmptyShapeItem(
                                  size: size,
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  vertical: size.longestSide * .02,
                                  horizontal: size.shortestSide * .04),
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("product")
                                      .doc(snapshot.data!.docs[index]
                                          .get("product_id"))
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapShot) {
                                    if (snapShot.hasData) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            bottom: size.longestSide * .02),
                                        height: size.longestSide * .16,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                  color: Colors.black26,
                                                  offset: Offset(-2, 4))
                                            ]),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: size.longestSide * .16,
                                              width: size.shortestSide * .37,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(
                                                                10)),
                                                child: Image.network(
                                                  snapShot.data!.get("image"),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.shortestSide * .02,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  size.shortestSide * .02),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapShot.data!.get("name"),
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.shortestSide *
                                                                .05,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "${snapShot.data!.get("price")} LE.",
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.shortestSide *
                                                                .043,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Container(
                                                    height:
                                                        size.longestSide * .05,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .amber.shade500,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            splashColor: Colors
                                                                .transparent,
                                                            onPressed: () {
                                                              controller.changeQuantity(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          "cartItem_id"),
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          "quantity"),
                                                                  "-");
                                                            },
                                                            icon: const Icon(
                                                                Icons.remove)),
                                                        Text(
                                                          snapshot
                                                              .data!.docs[index]
                                                              .get("quantity")
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.shortestSide *
                                                                      .045),
                                                        ),
                                                        IconButton(
                                                            splashColor: Colors
                                                                .transparent,
                                                            onPressed: () {
                                                              controller.changeQuantity(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          "cartItem_id"),
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          "quantity"),
                                                                  "+");
                                                            },
                                                            icon: const Icon(
                                                                Icons.add)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  controller.deleteCartItem(
                                                      snapshot.data!.docs[index]
                                                          .get("cartItem_id"));
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.orange.shade800,
                                                  size: size.shortestSide * .1,
                                                )),
                                            SizedBox(
                                                width: size.shortestSide * .02)
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(
                            flex: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.shortestSide * .04),
                            child: controller.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ButtonItem(
                                    name: "Order Now!",
                                    onPressed: () async {
                                      if (snapshot.data!.docs.isNotEmpty) {
                                        controller.sum = 0;
                                        await controller.getTotal(
                                          snapshot.data!.docs
                                              .map((e) => e.get("product_id"))
                                              .toList(),
                                          snapshot.data!.docs
                                              .map((e) => e.get("quantity"))
                                              .toList(),
                                        );

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CompeletOrder(
                                                totalPrice: controller.sum,
                                                productItem: snapshot.data!.docs
                                                    .map((e) =>
                                                        e.get("product_id"))
                                                    .toList(),
                                                productQuantity: snapshot
                                                    .data!.docs
                                                    .map((e) =>
                                                        e.get("quantity"))
                                                    .toList(),
                                                cartId: snapshot.data!.docs
                                                    .map((e) =>
                                                        e.get("cartItem_id"))
                                                    .toList(),
                                              ),
                                            ));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "The cart is empty!");
                                      }
                                    },
                                  ),
                          ),
                          const Spacer(
                            flex: 1,
                          )
                        ],
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

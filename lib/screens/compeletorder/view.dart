import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zezo/components/button.dart';
import 'package:zezo/components/textfield.dart';

import '../../components/appbar.dart';
import '../../components/emptyshape.dart';
import 'controller.dart';
import 'state.dart';

class CompeletOrder extends StatelessWidget {
  final double? totalPrice;
  final List? productItem;
  final List? cartId;
  final List? productQuantity;
  const CompeletOrder(
      {Key? key,
      this.totalPrice,
      this.productItem,
      this.productQuantity,
      this.cartId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => CompeletOrderController()
        ..getPersonalInformation()
        ..getPaymentToken(),
      child: Scaffold(
        appBar: mainAppBar(context, size, "Compelet Order", false),
        body: BlocBuilder<CompeletOrderController, CompeletOrderState>(
          builder: (context, state) {
            final controller = CompeletOrderController.get(context);
            return controller.isDone
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/emptyCard.png",
                          width: size.shortestSide * .7),
                      EmptyShapeItem(
                        head: "Confirm Order Done",
                        textSize: .07,
                        size: size,
                      ),
                    ],
                  )
                : Form(
                    key: controller.validation.formKey,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: size.longestSide * .02),
                                width: size.shortestSide - 50,
                                child: Column(
                                  children: List.generate(productItem!.length,
                                      (index) {
                                    return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("product")
                                          .doc(productItem![index])
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return ListTile(
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                snapshot.data!.get("image"),
                                                height: size.longestSide * .1,
                                                width: size.shortestSide * .2,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            title: Text(
                                              snapshot.data!.get("name"),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      size.shortestSide * .05,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            subtitle: Text(
                                              "Quantity : ${productQuantity![index]}",
                                              style: TextStyle(
                                                  fontSize:
                                                      size.shortestSide * .043,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            trailing: Text(
                                              "${snapshot.data!.get("price")} LE.",
                                              style: TextStyle(
                                                  fontSize:
                                                      size.shortestSide * .045,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    );
                                  }),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.shortestSide * .03,
                                    vertical: size.longestSide * .013),
                                child: TextFieldItem(
                                  lines: 3,
                                  onValid: (val) =>
                                      controller.validation.address(val),
                                  controller: controller.addressController,
                                  icon: Icons.home,
                                  lable: "Address",
                                  size: size,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: size.longestSide * .03,
                                    horizontal: size.shortestSide * .03),
                                decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 9,
                                        spreadRadius: 5,
                                        color: Colors.grey,
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: 0,
                                          groupValue: controller.radioValue,
                                          onChanged: (value) {
                                            controller.changeValue(value);
                                          },
                                          activeColor: Colors.blue.shade900,
                                        ),
                                        Text(
                                          "Cash",
                                          style: TextStyle(
                                              fontSize: size.shortestSide * .05,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      indent: size.shortestSide * .1,
                                      endIndent: size.shortestSide * .1,
                                      color: Colors.black,
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                            activeColor: Colors.blue.shade900,
                                            value: 1,
                                            groupValue: controller.radioValue,
                                            onChanged: (value) {
                                              controller.changeValue(value);
                                            }),
                                        Text(
                                          "Credit Card",
                                          style: TextStyle(
                                              fontSize: size.shortestSide * .05,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.shortestSide * .04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Price : $totalPrice LE",
                                      style: TextStyle(
                                          fontSize: size.shortestSide * .05,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: size.longestSide * .01,
                                    ),
                                    Text(
                                      "Delivery Price : ${controller.delivery} LE",
                                      style: TextStyle(
                                          fontSize: size.shortestSide * .05,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Divider(
                                      height: size.longestSide * .03,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Total order price : ${totalPrice! + controller.delivery} LE",
                                      style: TextStyle(
                                          fontSize: size.shortestSide * .05,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.longestSide * .1,
                              ),
                            ],
                          ),
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
                                      onPressed: () {
                                        if (controller
                                            .validation.formKey.currentState!
                                            .validate()) {
                                          controller.isLoading = true;
                                          controller.emit(IsLoadingState());
                                          if (controller.radioValue == 0) {
                                            log("cash");
                                            controller.onOrder(
                                                productItem!,
                                                productQuantity!,
                                                cartId!,
                                                totalPrice! +
                                                    controller.delivery,
                                                context,
                                                "Cash");
                                          } else {
                                            controller.pickPayment(
                                                totalPrice! +
                                                    controller.delivery,
                                                productItem!,
                                                productQuantity!,
                                                cartId!,
                                                context);
                                          }
                                        }
                                      }),
                            ),
                            const Spacer(
                              flex: 1,
                            )
                          ],
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

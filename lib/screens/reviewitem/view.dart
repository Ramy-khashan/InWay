import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zezo/components/button.dart';
import 'package:zezo/screens/reviewitem/controller.dart';
import 'package:zezo/screens/reviewitem/state.dart';

class ReviewItemScreen extends StatelessWidget {
  final String? id;
  final bool? isFav;
  const ReviewItemScreen({
    Key? key,
    this.isFav = false,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: size.shortestSide * .07,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => ReviewItemController(),
        child: BlocBuilder<ReviewItemController, ReviewItemStates>(
          builder: (context, state) {
            final controller = ReviewItemController.get(context);
            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("product")
                  .doc(id)
                  .get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: size.longestSide * .04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: size.longestSide * .5,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 500),
                                autoPlay: true,
                              ),
                              items: List.generate(
                                  snapshot.data!.get("images").length,
                                  (index) => Image.network(
                                        snapshot.data!.get("images")[index],
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      )),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.shortestSide * .02,
                                  vertical: size.longestSide * .024),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.shortestSide * .01),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  "${snapshot.data!.get("name")}\n\n",
                                              style: TextStyle(
                                                  fontSize:
                                                      size.shortestSide * .06,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                              text:
                                                  "Price : ${snapshot.data!.get('price')} LE.",
                                              style: TextStyle(
                                                  fontSize:
                                                      size.shortestSide * .05,
                                                  fontWeight: FontWeight.w400)),
                                        ])),
                                        isFav!
                                            ? const SizedBox.shrink()
                                            : IconButton(
                                                onPressed: () {
                                                  log(controller.user!.uid);
                                                  controller.toFavorite(id);
                                                },
                                                icon: Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.orange.shade800,
                                                  size: size.shortestSide * .1,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: .5,
                                    height: size.longestSide * .04,
                                    color: Colors.black,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Description : ${snapshot.data!.get("description")}",
                                        style: TextStyle(
                                            fontSize:
                                                size.shortestSide * .044)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.longestSide * .03,
                                horizontal: size.shortestSide * .03),
                            child: controller.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ButtonItem(
                                    name: "Add To Cart",
                                    onPressed: () {
                                      controller.addItemToCart(id);
                                    },
                                  ),
                          ),
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

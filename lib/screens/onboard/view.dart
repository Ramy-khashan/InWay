import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zezo/screens/onboard/controller.dart';
import 'package:zezo/screens/onboard/states.dart';
import 'package:zezo/screens/register/view.dart';

import '../../components/button.dart';
import '../../components/dotitem.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: BlocProvider(
        create: (context) => OnBoardController()..getPref(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: BlocBuilder<OnBoardController, OnBoardStates>(
            builder: (context, state) {
              final controller = OnBoardController.get(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 9,
                    child: PageView.builder(
                      controller: controller.pageViewController,
                      onPageChanged: (val) => controller.onChangePage(val),
                      itemCount: 3,
                      physics: const BouncingScrollPhysics(),
                      pageSnapping: true,
                      itemBuilder: (context, i) {
                        return Image.asset(
                          controller.img[i],
                          width: size.shortestSide * .6,
                          height: size.longestSide * .6,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                  Dotitem(
                      length: controller.img.length,
                      indexChange: controller.index),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.longestSide * .03,
                          horizontal: size.shortestSide * .05),
                      child: Text(
                        controller.data[controller.index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: size.shortestSide * .06),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: size.longestSide * .02,
                      right: size.shortestSide * .05,
                      left: size.shortestSide * .05,
                    ),
                    child: ButtonItem(
                      name: "Start",
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                            (route) => false);
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

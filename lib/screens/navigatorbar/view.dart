import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:zezo/screens/navigatorbar/controller.dart';

import '../../components/message.dart';
import 'states.dart';

class NavigatorBarScreen extends StatelessWidget {
  const NavigatorBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => NavigatorBarController(),
      child: BlocBuilder<NavigatorBarController, NavigatorBarStates>(
          builder: (context, state) {
        final controller = NavigatorBarController.get(context);
        return OfflineBuilder(
          connectivityBuilder: (context, value, child) {
            controller.connected = value != ConnectivityResult.none;
            if (controller.connected == true) {
              return Scaffold(
                body: BlocProvider.value(
                    value: BlocProvider.of<NavigatorBarController>(context),
                    child: controller.widgetOptions
                        .elementAt(controller.selectedIndex)),
                bottomNavigationBar: CurvedNavigationBar(
                  backgroundColor: Colors.transparent,
                  height: size.longestSide * .09,
                  color: const Color.fromARGB(255, 43, 63, 73),
                  items: [
                    Icon(
                      Icons.home_outlined,
                      size: size.shortestSide * .08,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.category_outlined,
                      size: size.shortestSide * .08,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.add_comment_outlined,
                      size: size.shortestSide * .08,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.favorite,
                      size: size.shortestSide * .08,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.settings_outlined,
                      size: size.shortestSide * .08,
                      color: Colors.white,
                    )
                  ],
                  onTap: controller.onTap,
                ),
              );
            } else {
              return Scaffold(
                body: MessageItem(
                  img: "images/disconnected.png",
                  msg: "Check your network..",
                  size: size,
                ),
              );
            }
          },
          child: const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}

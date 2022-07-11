import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({this.img, this.msg, this.size, Key? key})
      : super(key: key);
  final Size? size;
  final String? img;
  final String? msg;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(children: [
          Image.asset(img!),
          Text(
            msg!,
            style: TextStyle(
                fontSize: size!.shortestSide * .05,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EmptyShapeItem extends StatelessWidget {
  final Size? size;
  final String head;
  final double textSize;
  const EmptyShapeItem({Key? key, this.size, this.head = "Empty",this.textSize=.11})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        head,
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: size!.shortestSide * textSize,
            fontFamily: "One",
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

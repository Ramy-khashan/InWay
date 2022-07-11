import 'package:flutter/material.dart';

import '../constant.dart';

// ignore: must_be_immutable
class ViewItem extends StatelessWidget {
  const ViewItem(
      {this.img, this.price, this.name, this.onTap, Key? key, this.size})
      : super(key: key);
  final Size? size;

  final Function()? onTap;
  final String? name;
  final String? price;
  final String? img;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: GridTile(
        child: Image(
          fit: BoxFit.fill,
          image: NetworkImage(
            img!,
          ),
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: color1,
          title: Text(
            name!,
            style: TextStyle(fontSize: size!.shortestSide * .05),
          ),
          subtitle: Text(
            "$price LE",
            style: TextStyle(
              fontSize: size!.shortestSide * .04,
            ),
          ),
          // trailing: IconButton(
          //   onPressed: onTap,
          //   icon: Icon(
          //     Icons.favorite_rounded,
          //     color: Colors.orange.shade800,
          //     size: size!.shortestSide * .08,
          //   ),
          // ),
        ),
      ),
    );
  }
}

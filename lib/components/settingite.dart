import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({this.size, this.icon, this.onTap, this.title, Key? key})
      : super(key: key);
  final String? title;
  final IconData? icon;
  final Function()? onTap;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size!.longestSide * .01),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(blurRadius: 3, spreadRadius: 1, color: Colors.grey)
          ]),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon!),
        title: Text(
          title!,
          style: TextStyle(
              fontSize: size!.shortestSide * .048, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

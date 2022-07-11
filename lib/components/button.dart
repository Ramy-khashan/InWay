import 'package:flutter/material.dart';

class ButtonItem extends StatelessWidget {
  final String? name;
  final Function()? onPressed;
  final Color color = const Color.fromARGB(255, 48, 41, 141);
  const ButtonItem({
    Key? key,
    this.name,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.shortestSide * .3,
        height: size.longestSide * .07,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Theme.of(context).cardColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.topLeft)),
        child: Center(
          child: Text(
            "$name",
            style: TextStyle(
              color: Colors.black,
              fontSize: size.shortestSide * 0.045,
            ),
          ),
        ),
      ),
    );
  }
}
        
        /**ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: ElevatedButton(
        child: 
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: size.longestSide * .03)),
        ),
      ),
    ) */
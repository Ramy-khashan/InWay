import 'package:flutter/material.dart';

class FeedBackItem extends StatelessWidget {
  final String? id;
  final String? name;
  final String? phone;
  final String? title;
  final String? desc;
  final String? time;
  final String? date;

  final String? feedbackType;
  const FeedBackItem(
      {Key? key,
      this.date,
      this.desc,
      this.feedbackType,
      this.id,
      this.name,
      this.phone,
      this.time,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(blurRadius: 6, spreadRadius: 2, color: Colors.grey)
          ]),
      margin: EdgeInsets.symmetric(
          vertical: size.longestSide * .012,
          horizontal: size.shortestSide * .03),
      padding: EdgeInsets.symmetric(
          vertical: size.longestSide * .02,
          horizontal: size.shortestSide * .03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.longestSide * .01,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "$feedbackType Number : $id",
              style: TextStyle(
                  fontSize: size.shortestSide * .05,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: size.longestSide * .013,
          ),
          Text(
            "Name : $name",
            style: TextStyle(
                fontSize: size.shortestSide * .042,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "Phone : $phone",
            style: TextStyle(
                fontSize: size.shortestSide * .042,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "Title : $title",
            style: TextStyle(
                fontSize: size.shortestSide * .042,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "Description : $desc",
            style: TextStyle(
                fontSize: size.shortestSide * .042,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.longestSide * .01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Time : $time",
                style: TextStyle(
                    fontSize: size.shortestSide * .042,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Date : $date",
                style: TextStyle(
                    fontSize: size.shortestSide * .042,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StatisticWidget extends StatelessWidget {
  String label;
  String statistic;
  String percent;
  Color color;
  double screenWidth;
  double screenHeight;

  StatisticWidget(
      {required this.label,
      required this.statistic,
      required this.percent,
      required this.color,
      required this.screenWidth,
      required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: color,
      ),
      width: screenWidth * 0.3,
      height: screenHeight * 0.14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: screenWidth * 0.048,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          Text(
            statistic,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          Text(
            percent,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }
}

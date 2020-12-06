import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BadgeView extends GetView {
  BadgeView({this.isCorrect = true});

  final isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        isCorrect ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.timesCircle,
        color: isCorrect ? Colors.green : Colors.red,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VideoContainerView extends GetView {
  final child;

  VideoContainerView({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: child != null
          ? child
          : Icon(
              FontAwesomeIcons.youtube,
              size: 64,
              color: Colors.red[200],
            ),
      height: 300,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 24,
          spreadRadius: 0,
          color: Colors.black12,
        ),
      ], borderRadius: BorderRadius.circular(16), color: Colors.white),
    );
  }
}

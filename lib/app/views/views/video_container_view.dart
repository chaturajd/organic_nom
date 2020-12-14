import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VideoContainerView extends GetView {
  final child;

  VideoContainerView({this.child});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        width: double.infinity,
        // height: child ==null ? 300 : ,
        child: child != null
            ? child
            : Icon(
                FontAwesomeIcons.youtube,
                size: 64,
                color: Colors.red[200],
              ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 24,
              spreadRadius: 0,
              color: Colors.black12,
            ),
          ],
          color: Get.theme.primaryColorDark,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
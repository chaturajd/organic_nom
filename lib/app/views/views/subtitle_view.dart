import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SubtitleView extends GetView {
  SubtitleView(this.title);
  final title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20,bottom: 16),
      child: Container(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.overpass(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}

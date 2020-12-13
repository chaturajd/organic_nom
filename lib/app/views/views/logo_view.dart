import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "by AmilaGuru(pvt) Ltd.)",
            style: GoogleFonts.overpass(fontSize: 16),
          ),
        ),
        alignment: Alignment.bottomCenter,
      ),
      // color: Colors.red,
    );
  }
}

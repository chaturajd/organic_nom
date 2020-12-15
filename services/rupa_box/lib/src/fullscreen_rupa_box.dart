import 'package:flutter/material.dart';
import 'package:rupa_box/rupa_box.dart';

class FullScreenRupaBox extends StatefulWidget {
  FullScreenRupaBox(this.url, {Key key, this.playPosition = 0})
      : super(key: key);
  final String url;
  final double playPosition;

  @override
  _FullScreenRupaBoxState createState() => _FullScreenRupaBoxState();
}

class _FullScreenRupaBoxState extends State<FullScreenRupaBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          // color: Colors.orange,
          child: RupaBox(
            widget.url,
            playPosition: widget.playPosition,
            showFullscreenSwitch: false,
          ),
        ),
      ),
    );
  }
}

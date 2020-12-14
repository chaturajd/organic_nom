import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:rupa_box/rupa_box.dart';

// Widget _buildFullScreenVideo(
//   BuildContext context,
//   Animation<double> animation,
//   _ChewieControllerProvider controllerProvider,
// ) {
//   return Scaffold(
//     resizeToAvoidBottomPadding: false,
//     body: Container(
//       alignment: Alignment.center,
//       color: Colors.black,
//       child: controllerProvider,
//     ),
//   );
// }

class FullScreenRupaBox extends StatefulWidget {
  FullScreenRupaBox(this.url, {Key key, this.playPosition = 0})
      : super(key: key);
  final String url;
  final int playPosition;

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
          child: RupaBox(widget.url),
        ),
      ),
    );
  }
}

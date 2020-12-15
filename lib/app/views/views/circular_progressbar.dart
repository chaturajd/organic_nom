import 'package:flutter/material.dart';
import 'dart:math';

class CricularProgressBar extends StatefulWidget {
  CricularProgressBar({Key key,this.progress = 60,this.child =const Text("asd",style: TextStyle(color:Colors.red),) }) : super(key: key);
  final double progress;
  final Widget child;
  @override
  _CricularProgressBarState createState() => _CricularProgressBarState();
}

class _CricularProgressBarState extends State<CricularProgressBar> {
  @override
  Widget build(BuildContext context) {
    print(widget.progress);
    return CustomPaint(
      foregroundPainter: ProgressPainter(progress: widget.progress),
      child: Container(
          child: Center(child:widget.child),
          ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  ProgressPainter({this.progress = 50, this.thickness = 10});

  final double progress;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = thickness
      ..color = Colors.black12
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..color = Colors.orangeAccent
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 +thickness;

    double angle = 2 * pi * (progress/100);

    canvas.drawCircle(center, radius, outerCircle);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi/2, angle,
        false, completeArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

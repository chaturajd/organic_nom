import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key key, this.color, this.onClick, this.text, this.icon}) : super(key: key);

  final Color color;
  final Function onClick;
  final String text;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 7,
        constraints: BoxConstraints(
          maxWidth: 120,
        ),
        fillColor:color == null ? Colors.teal : color,
        onPressed: onClick(),
        shape: StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              icon==null ? Icon(Icons.check_circle) : icon,
              SizedBox(
                width: 20,
              ),
              Text(text == null ? "" :text),
            ],
          ),
        ),
      );
  }
}
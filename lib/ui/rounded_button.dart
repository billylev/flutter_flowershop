
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({ this.icon, this.onPressed, this.color, this.size, Key key }) : super(key: key);

  final Icon icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color,
        type: MaterialType.circle,
        elevation: 0.0,
        child: Container(
          width: size,
          height: size,
          child: new InkWell(
            customBorder: CircleBorder(),
            onTap: onPressed,
            child: new Center(
              child: icon,
            ),
          ),
        ),
    );
  }
}
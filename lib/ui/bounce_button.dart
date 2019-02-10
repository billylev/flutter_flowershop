import 'package:flutter/material.dart';

class BounceButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  BounceButton(this.text, this.color, {this.onPressed, Key key})
      : super(key: key);

  @override
  BounceButtonState createState() {
    return new BounceButtonState();
  }
}

class BounceButtonState extends State<BounceButton> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.bounceOut,
        )))
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _controller.forward().orCancel;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 300),
        child: Transform.scale(scale: _animation.value,
            child: RaisedButton(
                child: Text(widget.text),
                onPressed: () => widget.onPressed(),
                color: widget.color,
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)))));
  }
}
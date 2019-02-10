import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_flowershop/ui/colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FlareActor('assets/logo.flr',
          animation: 'show',
          fit: BoxFit.fitWidth,
          color: app_yellow,)
        )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_flowershop/localizations.dart';
import 'package:flutter_flowershop/ui/bounce_button.dart';
import 'package:flutter_flowershop/ui/colors.dart';
import 'package:flutter_flowershop/ui/pick_flower_screen.dart';

class MakeOrBuyScreen extends StatelessWidget {
  static const String route = '/makeorbuy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.instance.text('title')),
        ),
        body: SafeArea(
            child: Container(
          margin: EdgeInsets.only(top: 34, bottom: 8),
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(AppLocalizations.instance.text('what_like'),
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.center),
              const SizedBox(height: 30),
              BounceButton(
                  AppLocalizations.instance.text('make_bouquet'), app_yellow,
                  onPressed: () =>
                      Navigator.pushNamed(context, PickFlowerScreen.route)),
              BounceButton(
                  AppLocalizations.instance.text('buy_bouquet'), app_green),
              Spacer(),
              SizedBox(
                  height: 200,
                  child: Image.asset("assets/flowers.png", fit: BoxFit.cover))
            ],
          ),
        )));
  }
}

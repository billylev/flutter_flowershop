import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flowershop/bloc_helpers/bloc_provider.dart';
import 'package:flutter_flowershop/blocs/cart/cart_bloc.dart';
import 'package:flutter_flowershop/localizations.dart';
import 'package:flutter_flowershop/ui/make_buy_screen.dart';
import 'package:flutter_flowershop/ui/pick_flower_screen.dart';
import 'package:flutter_flowershop/ui/refine_order_screen.dart';
import 'package:flutter_flowershop/ui/shopping_cart_screen.dart';
import 'package:flutter_flowershop/ui/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    // show the splash for 3 sec
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _showSplash =false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
        bloc: CartBloc(),
    child: MaterialApp(
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.lightGreen,
            ),
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('es', ''),
            ],
            localeResolutionCallback:
                (Locale locale, Iterable<Locale> supportedLocales) {
              for (Locale supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode ||
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
        routes: {
          PickFlowerScreen.route: (context) => PickFlowerScreen(),
          MakeOrBuyScreen.route: (context) => MakeOrBuyScreen(),
          RefineOrderScreen.route: (context) => RefineOrderScreen(),
          ShoppingCartScreen.route: (context) => ShoppingCartScreen(),
        },
        home: _showSplash? SplashScreen() : MakeOrBuyScreen()
    ));
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_flowershop/bloc_helpers/bloc_provider.dart';
import 'package:flutter_flowershop/models/item.dart';
import 'package:rxdart/rxdart.dart';

class ShopBloc extends BlocBase {

  // Stream to list of all possible items
  BehaviorSubject<List<ShopItem>> _itemsController = BehaviorSubject<List<ShopItem>>();
  Stream<List<ShopItem>> get items => _itemsController;

  ShopBloc() {
    _loadShoppingItems();
  }

  @override
  void dispose() {
    _itemsController?.close();
  }

  void _loadShoppingItems() {

    var sizes = [eSize.Small, eSize.Small, eSize.Small];
    var colors = [FlowerColor("White", "assets/gerbera_white.png"),
      FlowerColor("Red", "assets/gerbera_red.png"),
      FlowerColor("Yellow", "assets/gerbera_yellow.png"),
      FlowerColor("Pink", "assets/gerbera_pink.png")];

    List<FlowerItem> items = List<FlowerItem>();

    items.add(FlowerItem("assets/bell.png",
        "Bell",
        "Bellflowers have characteristically bell-shaped, many are cultivated as garden ornamentals.",
        0.50,
        Color(0xFFeed7f4),
        sizes,
        colors));

    items.add(FlowerItem("assets/gerbera.png",
        "Gerbera",
        "Gerberas are perennial flowering plants featuring a large capitulum.",
        0.56,
        Color(0xFFffeeaa),
        sizes,
        colors));

    items.add(FlowerItem("assets/lily.png",
        "Lily",
        "Lilies have six plain or strikingly marked tepals and are often trumpet-shaped.",
        0.80,
        Color(0xFFdde9af),
        sizes,
        colors));

    items.add(FlowerItem("assets/tulip.png",
        "Tulip",
        "Within the tulip genus there is an enormous range of choice.",
        1,
        Color(0xFFFFAACC),
        sizes,
        colors));

    items.add(FlowerItem("assets/rose.png",
        "Rose",
        "Rose plants range in size from compact, miniature roses, to climbers.",
        0.65,
        Color(0xFFfff6d5),
        sizes,
        colors));

    _itemsController.add(items);
  }
}
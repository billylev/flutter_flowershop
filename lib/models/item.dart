
import 'package:flutter/material.dart';

enum eSize {Small, Medium, Large}

String sizeAsString(eSize size) {
  switch (size) {
    case eSize.Small:
      return "Small";
    case eSize.Medium:
      return "Medium";
    case eSize.Large:
      return "Large";
  }
}

class ShopItem {

  final String image;
  final String name;
  final String description;
  final double price;
  final Color backgroundColor;

  ShopItem(this.image, this.name, this.description, this.price, this.backgroundColor);
}

class FlowerItem extends ShopItem {

  final List<FlowerColor> colors;
  final List<eSize> sizes;

  FlowerItem(String image, String name, String description, double price, Color backgroundColor, this.sizes, this.colors) :
        super(image, name, description, price, backgroundColor);

}

class WrappingItem extends ShopItem {

  WrappingItem(String image, String name, String description, double price, Color backgroundColor) :
        super(image, name, description, price, backgroundColor);

}

class CartItem
{
  final ShopItem item;
  final int quantity;
  final String size;
  final String color;

  CartItem(this.item, this.quantity, this.size, this.color);
}

class FlowerColor {
  final String name;
  final String image;

  FlowerColor(this.name, this.image);
}




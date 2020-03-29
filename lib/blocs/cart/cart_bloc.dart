import 'package:flutter_flowershop/bloc_helpers/bloc_provider.dart';
import 'package:flutter_flowershop/models/item.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends BlocBase {
  Set<CartItem> _itemsInCart = Set<CartItem>();

  // the order
  BehaviorSubject<List<CartItem>> _orderController =
      BehaviorSubject<List<CartItem>>();
  Stream<List<CartItem>> get items => _orderController;

  BehaviorSubject<int> _shoppingCartSizeController =
      BehaviorSubject<int>.seeded(0);
  Stream<int> get shoppingCartSize => _shoppingCartSizeController;

  BehaviorSubject<double> _shoppingCartPriceController =
      BehaviorSubject<double>.seeded(0);
  Stream<double> get shoppingCartTotalPrice => _shoppingCartPriceController;

  BehaviorSubject<List<CartItem>> _shoppingCartController =
      BehaviorSubject<List<CartItem>>.seeded(<CartItem>[]);
  Stream<List<CartItem>> get shoppingCart => _shoppingCartController;

  void addToShoppingBasket(CartItem item) {
    _itemsInCart.add(item);
    _postActionOnBasket();
  }

  void removeFromShoppingBasket(CartItem item) {
    _itemsInCart.remove(item);
    _postActionOnBasket();
  }

  void _postActionOnBasket() {
    _orderController.sink.add(_itemsInCart.toList());
    _shoppingCartSizeController.sink.add(_itemsInCart.length);
    _computeShoppingBasketTotalPrice();
  }

  void _computeShoppingBasketTotalPrice() {
    double total = 0.0;

    _itemsInCart.forEach((CartItem cartItem) {
      total += cartItem.item.price * cartItem.quantity;
    });

    _shoppingCartPriceController.sink.add(total);
  }

  // this is not in a stream, because its used for the hero animation between screens
  // If its put in a stream isnt ready the first frame on the page change, so the hero animation doesnt work.
  // how to solve that is a todo
  ShopItem itemToRefine;

  @override
  void dispose() {
    _orderController?.close();
    _shoppingCartSizeController?.close();
    _shoppingCartPriceController.close();
    _shoppingCartController.close();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_flowershop/bloc_helpers/bloc_provider.dart';
import 'package:flutter_flowershop/blocs/cart/cart_bloc.dart';
import 'package:flutter_flowershop/localizations.dart';
import 'package:flutter_flowershop/models/item.dart';
import 'package:flutter_flowershop/ui/colors.dart';
import 'package:flutter_flowershop/ui/rounded_button.dart';
import 'package:intl/intl.dart';

final formatCurrency = new NumberFormat.simpleCurrency();

class FlowerRow extends StatefulWidget {
  final CartItem _item;

  FlowerRow(this._item);

  @override
  FlowerRowState createState() {
    return new FlowerRowState();
  }
}

class FlowerRowState extends State<FlowerRow> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.fastOutSlowIn,
        )))
    ..addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        CartBloc bloc = BlocProvider.of<CartBloc>(context);
        bloc.removeFromShoppingBasket(widget._item);
        _controller.reset();
      }
    })
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
  }

  //@override


  Widget _flowerProfile(ShopItem item, double size) {
    return Container(
        alignment: FractionalOffset.center,
        height: size,
        child: Material(
            color: widget._item.item.backgroundColor,
            type: MaterialType.circle,
            elevation: 1.0,
            child: Image.asset(widget._item.item.image)));
  }

  Widget _itemRow(String left, String right) {
    return Row(
      children: <Widget>[
        new Expanded(
          child: new Container(
            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(
              left,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: new Text(
            right,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
      ],
    );
  }

  Widget _totalRow(String right) {
    return Row(
      children: <Widget>[
        new Expanded(
          child: Container(),
        ),
        new Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: new Text(
            right,
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Transform.scale(scale: _animation.value,
      alignment: Alignment.centerRight,

      child : Stack(children: <Widget>[
      Container(
        height: 140.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(10.0),
                    child: _flowerProfile(null, 80)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(widget._item.item.name,
                            style: Theme.of(context).textTheme.title),
                      ),
                      _itemRow(AppLocalizations.instance.text('pieces'),
                          widget._item.quantity.toString()),
                      _itemRow(AppLocalizations.instance.text('size'),
                          widget._item.size),
                      _itemRow(AppLocalizations.instance.text('color'),
                          widget._item.color),
                      Container(
                        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        height: 0.5,
                        color: Colors.black12,
                      ),
                      _totalRow(
                          '${formatCurrency.format(widget._item.quantity * widget._item.item.price)}')
                    ],
                  ),
                ),
              ],
            )),
      ),
      Positioned(
          left: 12.0,
          top: 4.0,
          child: RoundedButton(
              color: Colors.black12,
              onPressed: () => _controller.forward().orCancel,
              size: 20,
              icon: const Icon(Icons.close, color: Colors.white, size: 16))),
    ]));
  }

}

class ShoppingCartScreen extends StatelessWidget {
  static const String route = '/shoppingcart';

  @override
  Widget build(BuildContext context) {
    CartBloc bloc = BlocProvider.of<CartBloc>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.instance.text('shopping_cart'))),
        body: StreamBuilder<List<CartItem>>(
            stream: bloc.items,
            builder:
                (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return ListView.builder(
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < snapshot.data.length) {
                      return FlowerRow(snapshot.data[index]);
                    } else {
                      return StreamBuilder<double>(
                          stream: bloc.shoppingCartTotalPrice,
                          initialData: 0,
                          builder: (BuildContext context,
                              AsyncSnapshot<double> snapshot) {
                            return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Total Price",
                                        style:
                                            Theme.of(context).textTheme.title),
                                    Text(
                                        '${formatCurrency.format(snapshot.data)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(color: app_yellow))
                                  ],
                                ));
                          });
                    }
                  });
            }));
  }
}
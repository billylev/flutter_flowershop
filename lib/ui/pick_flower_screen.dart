import 'package:flutter/material.dart';
import 'package:flutter_flowershop/bloc_helpers/bloc_provider.dart';
import 'package:flutter_flowershop/blocs/cart/cart_bloc.dart';
import 'package:flutter_flowershop/blocs/shop/shop_bloc.dart';
import 'package:flutter_flowershop/models/item.dart';
import 'package:flutter_flowershop/ui/refine_order_screen.dart';
import 'package:flutter_flowershop/localizations.dart';
import 'package:flutter_flowershop/ui/shopping_cart_action.dart';

class ListRow extends StatefulWidget {
  final int _delay;
  final FlowerItem _item;

  ListRow(this._delay, this._item);

  @override
  ListRowState createState() {
    return new ListRowState(_delay);
  }
}

class ListRowState extends State<ListRow> with SingleTickerProviderStateMixin {
  Animation<double> _thumbnailAnimation;
  Animation<double> _cardAnimation;
  Animation<double> _opacityAnimation;
  AnimationController _controller;

  int _delay;

  ListRowState(this._delay);

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _thumbnailAnimation = Tween(begin: 0.0, end: 120.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.fastOutSlowIn,
        )))
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _cardAnimation = Tween(begin: 0.0, end: 120.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.4,
          0.8,
          curve: Curves.easeOut,
        )))
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _opacityAnimation = Tween(begin: 0.4, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.8,
          1.0,
          curve: Curves.linear,
        )))
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(Duration(milliseconds: _delay), () {
      _delay = 0;
      _controller.forward().orCancel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = BlocProvider.of<CartBloc>(context);

    return InkWell(
        onTap: () {
          cartBloc.itemToRefine = widget._item;
          Navigator.pushNamed(context, RefineOrderScreen.route);
        },
        //onLongPress: enabled ? onLongPress : null,
        child: Container(
            height: 120.0,
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: new Stack(
              children: <Widget>[
                Container(
                    alignment: FractionalOffset.centerLeft,
                    child: Container(
                        height: _cardAnimation.value,
                        margin: EdgeInsets.only(left: 46.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: _cardAnimation.value == 120
                                ? Container(
                                    margin: EdgeInsets.only(
                                        left: 80, right: 8, top: 8),
                                    child: Opacity(
                                        opacity: _opacityAnimation.value,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(widget._item.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title),
                                            Text(widget._item.description,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body1)
                                          ],
                                        )))
                                : Container()))),
                Container(
                    height: _thumbnailAnimation.value,
                    width: _thumbnailAnimation.value,
                    child: Hero(
                        tag: widget._item,
                        child: Material(
                            color: widget._item.backgroundColor,
                            type: MaterialType.circle,
                            elevation: 1.0,
                            child: Image.asset(widget._item.image))))
              ],
            )));
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PickFlowerScreen extends StatelessWidget {
  static const String route = '/pickflower';

  @override
  Widget build(BuildContext context) {
    final ShopBloc shopBloc = ShopBloc();

    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.instance.text('pick_flower')),
            actions: <Widget>[
              ShoppingCartAction(),
            ]),
        body: StreamBuilder<List<ShopItem>>(
            stream: shopBloc.items,
            builder:
                (BuildContext context, AsyncSnapshot<List<ShopItem>> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListRow(index * 100, snapshot.data[index]);
                  });
            }));
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_flowershop/bloc_helpers/bloc_provider.dart';
import 'package:flutter_flowershop/blocs/cart/cart_bloc.dart';
import 'package:flutter_flowershop/models/item.dart';
import 'package:flutter_flowershop/localizations.dart';
import 'package:flutter_flowershop/ui/colors.dart';
import 'package:flutter_flowershop/ui/shopping_cart_action.dart';
import 'package:flutter_flowershop/ui/shopping_cart_screen.dart';
import 'package:intl/intl.dart';

class FlowerSizePicker extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  FlowerSizePicker({@required this.value, @required this.onChanged, Key key})
      : super(key: key);

  @override
  FlowerSizePickerState createState() {
    return new FlowerSizePickerState();
  }
}

class FlowerSizePickerState extends State<FlowerSizePicker> {
  Widget _getImage(int index, double size, Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(index);
      },
      child: Image.asset("assets/size_unselected.png",
          height: size,
          width: size,
          color: widget.value == index ? backgroundColor : null,
          colorBlendMode: BlendMode.modulate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    final FlowerItem item = cartBloc.itemToRefine as FlowerItem;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      Column(children: <Widget>[
        _getImage(0, 50, item.backgroundColor),
        const SizedBox(height: 10),
        Center(child: Text("Small", style: Theme.of(context).textTheme.caption))
      ]),
      Column(children: <Widget>[
        _getImage(1, 60, item.backgroundColor),
        const SizedBox(height: 10),
        Center(
            child: Text("Medium", style: Theme.of(context).textTheme.caption))
      ]),
      Column(children: <Widget>[
        _getImage(2, 70, item.backgroundColor),
        const SizedBox(height: 10),
        Center(child: Text("Large", style: Theme.of(context).textTheme.caption))
      ])
    ]);
  }
}

class FlowerColorPicker extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  FlowerColorPicker({@required this.value, @required this.onChanged, Key key})
      : super(key: key);

  @override
  FlowerColorPickerState createState() {
    return new FlowerColorPickerState();
  }
}

class FlowerColorPickerState extends State<FlowerColorPicker> {
  Widget _getColorPicker(
      int index, double size, String image, Color backgroundColor) {
    return Container(
        height: size,
        width: size,
        child: Material(
            color: backgroundColor,
            type: MaterialType.circle,
            elevation: 1.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(image,
                    color: (widget.value != index) ? Color(0xFFE7E7E7) : null,
                    colorBlendMode: BlendMode.color))));
  }

  Widget _getImage(int index, double size, String image, String name,
      Color backgroundColor) {
    return GestureDetector(
        onTap: () {
          widget.onChanged(index);
        },
        child: Column(
          children: <Widget>[
            _getColorPicker(index, size, image, backgroundColor),
            const SizedBox(height: 10),
            Center(
                child: Text(name, style: Theme.of(context).textTheme.caption))
          ],
        ));
  }

  List<Widget> _getWidgets(List<FlowerColor> colors, Color backgroundColor) {
    return colors
        .map((color) => _getImage(colors.indexOf(color), 60, color.image,
            color.name, backgroundColor))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    final FlowerItem item = cartBloc.itemToRefine as FlowerItem;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _getWidgets(item.colors, item.backgroundColor));
  }
}

class RefineOrderScreen extends StatefulWidget {
  static const String route = '/refineorder';

  RefineOrderScreen();

  @override
  RefineOrderScreenState createState() {
    return new RefineOrderScreenState();
  }
}

class RefineOrderScreenState extends State<RefineOrderScreen>
    with SingleTickerProviderStateMixin {

  final _formatCurrency = new NumberFormat.simpleCurrency();

  double _quantity = 0.0;
  int _flowerSize = 0;
  int _flowerColor = 0;

  Animation<double> _containerAnimation;
  Animation<double> _opacityAnimation;
  AnimationController _controller;

  final double _pageSize = 600;

  void _onChangedFlowerSize(int value) => setState(() => _flowerSize = value);
  void _onChangedFlowerColor(int value) => setState(() => _flowerColor = value);

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _containerAnimation = Tween(begin: 120.0, end: _pageSize).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.7, curve: Curves.fastOutSlowIn)))
      ..addListener(() {
        setState(() {});
      });

    _opacityAnimation = Tween(begin: 0.4, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.7,
          1.0,
          curve: Curves.linear,
        )))
      ..addListener(() {
        setState(() {});
      });

    _controller.forward().orCancel;

    super.initState();
  }

  Widget _quantityDisplay() {
    return Container(
        decoration: new BoxDecoration(
            color: Color.fromARGB(255, 220, 220, 220),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(20.0)),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              _quantity.round().toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            )));
  }

  Widget _textTitle(String title) {
    return Center(
        child: Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title));
  }

  Widget _textBody(String resId) {
    return Text(AppLocalizations.instance.text(resId),
        style: Theme.of(context).textTheme.body1);
  }

  Widget _quantitySlider(ThemeData theme, Color backgroundColor) {
    return SliderTheme(
        data: theme.sliderTheme.copyWith(
            activeTrackColor: backgroundColor,
            inactiveTrackColor: Colors.black26,
            thumbColor: backgroundColor),
        child: Slider(
          value: _quantity,
          min: 0.0,
          max: 20.0,
          onChanged: (double value) {
            setState(() {
              _quantity = value;
            });
          },
        ));
  }

  Widget _quantityRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _textBody('quantity'),
          _quantityDisplay(),
        ]);
  }

  Widget _flowerProfile(ShopItem item, double size) {
    return Container(
        alignment: FractionalOffset.center,
        height: size,
        child: Hero(
            tag: item,
            child: Material(
                color: item.backgroundColor,
                type: MaterialType.circle,
                elevation: 1.0,
                child: Image.asset(item.image))));
  }

  Widget _addToCartButton() {
    CartBloc bloc = BlocProvider.of<CartBloc>(context);

    double getCost() {
      return bloc.itemToRefine.price * _quantity;
    }

    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
                child: new Text(AppLocalizations.instance.text('add_to_cart') +
                    ' ${_formatCurrency.format(getCost())}'),
                onPressed: () {

                  if (_quantity > 0.0) {
                    FlowerItem flowerItem = bloc.itemToRefine;

                    bloc.addToShoppingBasket(CartItem(
                        bloc.itemToRefine,
                        _quantity.round(),
                        sizeAsString(eSize.values[_flowerSize]),
                        flowerItem.colors[_flowerColor].name));
                    setState(() {
                      _quantity = 0;
                    });
                  }
                },
                color: app_green,
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)))));
  }

  Widget _checkOutButton() {
    CartBloc bloc = BlocProvider.of<CartBloc>(context);

    return StreamBuilder<double>(
        stream: bloc.shoppingCartTotalPrice,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      child: new Text(
                          AppLocalizations.instance.text('check_out') +
                              ' ${_formatCurrency.format(snapshot.data)}'),
                      onPressed: () {
                        Navigator.pushNamed(context, ShoppingCartScreen.route);
                      },
                      color: app_yellow,
                      textColor: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)))));
        });
  }

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    final ThemeData theme = Theme.of(context);
    final ShopItem item = cartBloc.itemToRefine;

    List<Widget> _getStackChildren() {
      List<Widget> list = new List<Widget>();

      list.add(Container(
          margin: EdgeInsets.only(top: 46.0),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 80),
                  child: (_containerAnimation.value >= _pageSize)
                      ? Opacity(
                          opacity: _opacityAnimation.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _textTitle(item.name),
                              const SizedBox(height: 10),
                              _quantityRow(),
                              _quantitySlider(theme, item.backgroundColor),
                              const SizedBox(height: 10),
                              _textBody('size'),
                              const SizedBox(height: 10),
                              FlowerSizePicker(
                                  value: _flowerSize,
                                  onChanged: _onChangedFlowerSize),
                              const SizedBox(height: 10),
                              _textBody('color'),
                              const SizedBox(height: 10),
                              FlowerColorPicker(
                                  value: _flowerColor,
                                  onChanged: _onChangedFlowerColor),
                              Expanded(child: Container()),
                              _addToCartButton(),
                              _checkOutButton()
                            ],
                          ))
                      : Container()))));

      list.add(_flowerProfile(item, 120));

      return list;
    }

    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.instance.text('config_flower')),
            actions: <Widget>[
              ShoppingCartAction(),
            ]),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    height: _containerAnimation.value,
                    child: Stack(
                      children: _getStackChildren(),
                    )))));
  }
}

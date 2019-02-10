
import 'package:flutter/material.dart';
import 'package:flutter_flowershop/bloc_helpers/bloc_provider.dart';
import 'package:flutter_flowershop/blocs/cart/cart_bloc.dart';
import 'package:flutter_flowershop/ui/shopping_cart_screen.dart';

class ShoppingCartAction extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CartBloc bloc = BlocProvider.of<CartBloc>(context);

    return Container(
      width: 48.0,
      height: 48.0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ShoppingCartScreen.route);
        },
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Center(
              child: const Icon(Icons.shopping_cart),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: Offset(0.0, -5.0),
                  child: StreamBuilder<int>(
                    stream: bloc.shoppingCartSize,
                    initialData: 0,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

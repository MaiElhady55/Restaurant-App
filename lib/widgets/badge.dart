import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/cart.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final Color? color;
  const Badge({super.key, required this.child, this.color});

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context, listen: false);
    return cart.items.isEmpty
        ? child
        : Stack(alignment: Alignment.center, children: [
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: color !=null?color: Theme.of(context).primaryColor,
                ),
                constraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Consumer<Carts>(
                  builder: (_, cart, __) => Text(
                    cart.itemCount.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ]);
  }
}

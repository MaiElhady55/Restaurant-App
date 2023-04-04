import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String mealId;
  final int quantity;
  final String title;
  final String imageUrl;

  const CartItem(
      {super.key,
      required this.id,
      required this.price,
      required this.mealId,
      required this.quantity,
      required this.title,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want remove item from the cart'),
            actions: <Widget>[
              TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  }),
              TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  }),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cart.removeItem(mealId: mealId);
        /*if (direction == DismissDirection.endToStart) {
          cart.removeItem(mealId: mealId);
        } else {
          cart.removeSingleItem(mealId: mealId);
        }*/
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            subtitle:
                Text('Total : \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text(
              '$quantity x',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

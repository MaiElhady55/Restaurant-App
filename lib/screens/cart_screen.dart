import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/cart.dart';
import 'package:resturant_app/providers/cart.dart';
import 'package:resturant_app/providers/orders.dart';
import 'package:resturant_app/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = 'cart screen';
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context);
    return Scaffold(
      body: Column(
        children: [
          Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total : ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                        onPressed: () async {
                          if (cart.items.isEmpty) {
                            return;
                          }
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await Provider.of<Orders>(context).addOrder(
                                cart.items.values.toList(), cart.totalAmount);
                            setState(() {
                              isLoading = false;
                            });
                            cart.clearCart();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.black54,
                              content: Text('You order is Done!'),
                              duration: Duration(seconds: 1),
                            ));
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.black54,
                              content: Text('Somthing went wrong try later!'),
                              duration: Duration(seconds: 1),
                            ));
                          }
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text('ORDER NOW', style: TextStyle(fontSize: 16)))
                  ],
                ),
              )),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: ((context, index) {
                    return CartItem(
                      mealId: cart.items.keys.toList()[index],
                      id: cart.items.values.toList()[index].id,
                      title: cart.items.values.toList()[index].title,
                      quantity: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price,
                      imageUrl: cart.items.values.toList()[index].imageUrl,
                    );
                  }))),
        ],
      ),
    );
  }
}

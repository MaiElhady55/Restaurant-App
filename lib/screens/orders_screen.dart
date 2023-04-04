import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/orders.dart';
import 'package:resturant_app/shared_widgets.dart/drawer.dart';
import 'package:resturant_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'Order-Screen';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color.fromARGB(0, 0, 0, 1),
        elevation: 0.0,
        title: Text('Orders',style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
      ),
      drawer: SharedDrawer(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context).fetchOrders(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return AlertDialog(
                title: Text('An error occurred'),
                content: Text('No Data found!'),
              );
            } else {
              if (snapshot.error != null) {
                return AlertDialog(
                  title: Text('An error occurred'),
                  content: Text(snapshot.error.toString()),
                );
              } else {
                return Consumer<Orders>(
                  builder: ((context, orderData, _) {
                    if (orderData.orders.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            'You Don\'t have Orders .',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: ((context, index) {
                          return OrderItem(
                            order: orderData.orders[index],
                          );
                        }));
                  }),
                );
              }
            }
          })),
    );
  }
}

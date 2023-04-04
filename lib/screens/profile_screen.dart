import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/auth.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/providers/orders.dart';
import 'package:resturant_app/widgets/profile_order_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = 'profile screen';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 200,
          padding: EdgeInsets.only(top: 15),
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).accentColor,
          child: Column(
            children: <Widget>[
              CircleAvatar(
                // radius: 70,
                maxRadius: 70,
                minRadius: 30,
                backgroundColor: Colors.grey,
              ),
              SizedBox(height: 10),
              Expanded(
                child: Text(
                  authData == null ? 'user Name' : authData.email!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'My Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: Provider.of<Orders>(context, listen: false).fetchOrders(),
              builder: (ctx,AsyncSnapshot snapShot) {
                switch (snapShot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.none:
                    return AlertDialog(
                      title: Text('An error occurred'),
                      content: Text('No Data found!'),
                    );
                    break;
                  case ConnectionState.done:
                    if (snapShot.error != null) {
                      return AlertDialog(
                        title: Text('An error occurred'),
                        content: Text(snapShot.error.toString()),
                      );
                    } else {
                      return Consumer<Orders>(builder: (ctx, orderData, _) {
                        if (orderData.orders.isEmpty) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
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
                          itemBuilder: (ctx, i) => ProfileOrderItem(
                            order: orderData.orders[i],
                          ),
                        );
                      });
                    }
                    break;
                  default:
                }
              return Container();
              }),
        ),
      ],
    );
  }
}

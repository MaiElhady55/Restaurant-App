import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/auth.dart';
import 'package:resturant_app/screens/auth_screen.dart';
import 'package:resturant_app/screens/manage_screen.dart';
import 'package:resturant_app/screens/orders_screen.dart';
import 'package:resturant_app/screens/tab_screen.dart';

class SharedDrawer extends StatelessWidget {
  const SharedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15),
            height: 200,
            color: Theme.of(context).accentColor,
            child: Column(
              children: <Widget>[
                CircleAvatar(
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
          BuildListTile(
            leadinIcon: Icon(Icons.home),
            text: 'Home',
            trailingIcon: Icon(Icons.navigate_next),
            function: () =>
                Navigator.of(context).pushReplacementNamed(TabScreen.routeName),
          ),
          Divider(),
          BuildListTile(
            leadinIcon: Icon(Icons.payment),
            text: 'Orders ',
            trailingIcon: Icon(Icons.navigate_next),
            function: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
          Divider(),
          BuildListTile(
            leadinIcon: Icon(Icons.edit),
            text: 'Manage Meals',
            trailingIcon: Icon(Icons.navigate_next),
            function: () =>
                Navigator.of(context).pushNamed(ManageScreen.routeName),
          ),
          Divider(),
          BuildListTile(
              leadinIcon: Icon(Icons.contacts),
              text: 'Contact Us',
              trailingIcon: Icon(Icons.navigate_next),
              function: () {}),
          Divider(),
          BuildListTile(
              leadinIcon: Icon(Icons.help),
              text: 'Help',
              trailingIcon: Icon(Icons.navigate_next),
              function: () {}),
          Divider(),
          BuildListTile(
              leadinIcon: Icon(Icons.settings),
              text: 'Setting',
              trailingIcon: Icon(Icons.navigate_next),
              function: () {}),
          Divider(),
          BuildListTile(
            leadinIcon: Icon(Icons.exit_to_app),
            text: 'Log Out ',
            trailingIcon: Icon(Icons.navigate_next),
            function: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              //////////////////////////////////////////////////
              authData.logout();
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  ListTile BuildListTile(
      {required Widget leadinIcon,
      required String text,
      required Widget trailingIcon,
      required VoidCallback function}) {
    return ListTile(
        leading: leadinIcon,
        title: Text(
          text,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        trailing: trailingIcon,
        onTap: function);
  }
}

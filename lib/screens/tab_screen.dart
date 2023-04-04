import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:resturant_app/screens/cart_screen.dart';
import 'package:resturant_app/screens/favorites_screen.dart';
import 'package:resturant_app/screens/home_screen.dart';
import 'package:resturant_app/screens/manage_screen.dart';
import 'package:resturant_app/screens/profile_screen.dart';
import 'package:resturant_app/shared_widgets.dart/drawer.dart';
import 'package:resturant_app/widgets/badge.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});
  static const routeName = 'tab-Screen';

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Home',
      'page': HomeScreen(),
    },
    {
      'title': 'Favorite',
      'page': FavoriteScreen(),
    },
    {
      'title': 'Cart',
      'page': CartScreen(),
    },
    {
      'title': 'Profile',
      'page': ProfileScreen(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color.fromARGB(0, 0, 0, 1),
        title: Text(_pages[selectedIndex]['title'],
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: SharedDrawer(),
      body: _pages[selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 4,
          iconSize: 28,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: ((index) {
            setState(() {
              selectedIndex = index;
            });
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Badge(child: Icon(Icons.shopping_cart)),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ]),
    );
  }
}

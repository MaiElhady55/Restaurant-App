import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/auth.dart';
import 'package:resturant_app/providers/cart.dart';
import 'package:resturant_app/providers/categories_list.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/providers/orders.dart';
import 'package:resturant_app/screens/auth_screen.dart';
import 'package:resturant_app/screens/edit_cat_screen.dart';
import 'package:resturant_app/screens/edit_meal_screen.dart';
import 'package:resturant_app/screens/manage_screen.dart';
import 'package:resturant_app/screens/meal_detail_screen.dart';
import 'package:resturant_app/screens/meals_screen.dart';
import 'package:resturant_app/screens/orders_screen.dart';
import 'package:resturant_app/screens/splash_screen.dart';
import 'package:resturant_app/screens/tab_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: CategoriesList()),
        ChangeNotifierProxyProvider<Auth, Meals>(
            create: (context) => Meals(),
            update: ((context, authValue, previousMeal) => previousMeal!..getData(
                authValue.token!, authValue.userId!, previousMeal.meals))),
        ChangeNotifierProvider.value(value: Carts()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousOrders) => previousOrders!
            ..getData(
              authValue.token!,
              authValue.userId!,
              previousOrders.orders,
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Resturant App',
              theme: ThemeData(
                  primarySwatch: Colors.red,
                  accentColor: Colors.orange,
                  fontFamily: 'Lato'),
              home: auth.isAuth?TabScreen(): FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: ((context,AsyncSnapshot snapshot)=>
                  snapshot.connectionState == ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen()
                ),
              ),
              routes: {
                TabScreen.routeName:(context) => TabScreen(),
                MealDetailScreen.routeName: (context) => MealDetailScreen(),
                MealsScreen.routeName: (context) => MealsScreen(),
                ManageScreen.routeName:(context) => ManageScreen(),
                EditMealScreen.routeName: (context) => EditMealScreen(),
                EditCatScreen.routeName: (context) => EditCatScreen(),
                OrdersScreen.routeName:(context)=> OrdersScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
              },
            )),
      ),
    );
  }
}

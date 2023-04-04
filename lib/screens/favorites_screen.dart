import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/widgets/favorites_item.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  static const routeName = 'favorite screen';
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Meal> favMeals = Provider.of<Meals>(context).favMeals;
    return Scaffold(
      body: favMeals.isEmpty
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Text(
                    'You Don\'t Have Favorites Meals Yet Start Add Some.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'assets/images/brokenHeart.png',
                    color: Colors.grey,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: favMeals.length,
              itemBuilder: ((context, index) {
                return FavoritesMealItem(
                  favId: favMeals[index].id,
                );
              })),
    );
  }
}

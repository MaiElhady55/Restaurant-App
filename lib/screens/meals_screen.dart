import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/widgets/meal_item.dart';

import '../providers/meals.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});
  static const routeName = 'Meals-screen';

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final categoryTitle = routeArg['title'];
    final categoryId = routeArg['id'];
    final categorySymbol = routeArg['symbol'];

    final loadedMeal = Provider.of<Meals>(context)
        .meals
        .where((meal) => meal.categories.contains(categorySymbol))
        .toList();

    return Scaffold(
      appBar: AppBar(
          title: Text(categoryTitle,style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
          textTheme: Theme.of(context).textTheme,
          actionsIconTheme: Theme.of(context).accentIconTheme,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Color.fromARGB(0, 0, 0, 1),
          elevation: 0.0,),
      body: Center(
        child: ListView.builder(
            itemCount: loadedMeal.length,
            itemBuilder: ((context, index) {
              return ChangeNotifierProvider.value(
                value: loadedMeal[index],
                child: MealItem(categoryId: categoryId),
              );
            })),
      ),
    );
  }
}

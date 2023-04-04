import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/screens/meal_detail_screen.dart';

class PopulerItem extends StatefulWidget {
  final Meal meal;
  PopulerItem({required this.meal});

  @override
  State<PopulerItem> createState() => _PopulerItemState();
}

class _PopulerItemState extends State<PopulerItem> {
  @override
  Widget build(BuildContext context) {
    Meal meal = Provider.of<Meals>(context).findlById(id: widget.meal.id);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: {
          'mealId': meal.id,
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          leading: Container(
            width: 150,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(meal.imageUrl,fit: BoxFit.cover,),
            ),
          ),
          title: Text(
            meal.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('price : \$${meal.price}'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

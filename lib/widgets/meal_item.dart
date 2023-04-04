import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/screens/meal_detail_screen.dart';
import 'package:resturant_app/shared_widgets.dart/buildgesturedetector.dart';

class MealItem extends StatelessWidget {
  final categoryId;
  MealItem({required this.categoryId});
  @override
  Widget build(BuildContext context) {
    final loadedMeal = Provider.of<Meal>(context);

    void _selectMeal(BuildContext context) {
      Navigator.of(context).pushNamed(MealDetailScreen.routeName,
          arguments: { 'mealId': loadedMeal.id, 'categoryId': categoryId});
    }

    return BuildGestureDetector(
      loadedMeal: loadedMeal,
      function: _selectMeal,
    );
  }
}

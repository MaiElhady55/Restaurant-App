import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/screens/meal_detail_screen.dart';
import 'package:resturant_app/shared_widgets.dart/buildgesturedetector.dart';

class FavoritesMealItem extends StatelessWidget {
  final String favId;

  const FavoritesMealItem({super.key, required this.favId});

  @override
  Widget build(BuildContext context) {
    final Meal loadedFavMeal = Provider.of<Meals>(context).findlById(id: favId);

    void selectMeal(BuildContext context) {
      Navigator.of(context).pushNamed(MealDetailScreen.routeName,arguments: {
        'mealId':favId
      });
    }

    return BuildGestureDetector(loadedMeal: loadedFavMeal, function: selectMeal);
  }
}

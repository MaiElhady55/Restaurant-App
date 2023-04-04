import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/category.dart';
import 'package:resturant_app/screens/meals_screen.dart';

class CategoriesItem extends StatefulWidget {
  const CategoriesItem({super.key});

  @override
  State<CategoriesItem> createState() => _CategoriesItemState();
}

class _CategoriesItemState extends State<CategoriesItem> {
  @override
  Widget build(BuildContext context) {
    final currentCat = Provider.of<Category>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MealsScreen.routeName, arguments: {
          'id': currentCat.id,
          'title': currentCat.title,
          'symbol': currentCat.symbol
        });
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Material(
              borderRadius: BorderRadius.circular(40),
              elevation: 5,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    currentCat.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              currentCat.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

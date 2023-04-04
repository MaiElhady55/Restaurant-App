import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/widgets/populer_item.dart';

class Populer extends StatefulWidget {
  final bool isSeeAll;
  Populer({required this.isSeeAll});

  @override
  State<Populer> createState() => _PopulerState();
}

class _PopulerState extends State<Populer> {
  var isInit = true;
  var _meals;
  List<Meal> _populer = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      _meals = Provider.of<Meals>(context).meals;
      if (_meals != null) {
        Random random = Random();
        for (var i = 0; i <= 3; i++) {
          var myRandom = random.nextInt(_meals.length);
          _populer.add(_meals[myRandom]);
        }
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: _meals == null
          ? Container(
              width: 100,
              height: 100,
              color: Colors.red,
              child: Center(
                  child: Text(
                'there is no Meals',
                style: TextStyle(color: Colors.white),
              )),
            )
          : widget.isSeeAll
              ? Card(
                  child: Column(
                    children: _populer
                        .map((popMeal) => PopulerItem(meal: popMeal))
                        .toList(),
                  ),
                )
              : Card(
                  child: PopulerItem(
                    meal: _populer[0],
                  ),
                ),
    );
  }
}

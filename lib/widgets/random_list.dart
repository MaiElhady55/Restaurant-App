import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:resturant_app/providers/meals.dart';
import 'package:resturant_app/widgets/random_list_item.dart';

class RandomList extends StatefulWidget {
  const RandomList({super.key});

  @override
  State<RandomList> createState() => _RandomListState();
}

class _RandomListState extends State<RandomList> {
  bool isInit = true;
  var _meals;
  List<Meal> _randomMeals = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      _meals = Provider.of<Meals>(context, listen: false).meals;
      if (_meals != null) {
        Random random = Random();
        for (var i = 0; i <= 4; i++) {
          var myRandom = random.nextInt(_meals.length);
          _randomMeals.add(_meals[myRandom]);
        }
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: _randomMeals.length,
        itemBuilder: ((context, index, realIndex) {
          return _meals==null?Container(
            width: 100,
            height: 100,
            color:Colors.red,
            child: Center(child: Text('there is no Meals',style: TextStyle(color: Colors.white),)),
          ): RandomListItem(meal:_randomMeals[index]);
        }),
        options: CarouselOptions(
          height: 250,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ));
  }
}

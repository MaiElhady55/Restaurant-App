import 'package:flutter/cupertino.dart';
import 'package:resturant_app/providers/meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Meals with ChangeNotifier {
  List<Meal> _meals = [/*
    Meal(
      id: 'b1',
      categories: [
        'burger',
      ],
      title: 'British Burger',
      description:
          """In a large bowl, sift together the flour, baking powder, salt and sugar
Make a well in the center and pour in the milk, egg and melted butter; mix until smooth
Heat a lightly oiled griddle or frying pan over medium high heat.
Pour or scoop the batter onto the griddle, using approximately 1/4 cup for each pancake. Brown on both sides and """,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246__480.jpg',
      price: 23.99,
    ),
    Meal(
      id: 'b2',
      categories: [
        'burger',
      ],
      title: 'Burger King',
      description:
          """In a large bowl, sift together the flour, baking powder, salt and sugar
Make a well in the center and pour in the milk, egg and melted butter; mix until smooth
Heat a lightly oiled griddle or frying pan over medium high heat.""",
      imageUrl:
          'https://media-cldnry.s-nbcnews.com/image/upload/newscms/2019_21/2870431/190524-classic-american-cheeseburger-ew-207p.jpg',
      price: 30.99,
    ),
  */
  ];
  String authToken = '';
  String userId = '';

  getData(String authTok, String uId, List<Meal> items) {
    authToken = authTok;
    userId = uId;
    _meals = items;
    notifyListeners();
  }

  List<Meal> get meals {
    return [..._meals];
  }

  List<Meal> get favMeals {
    return _meals.where((element) => element.isFavorite).toList();
  }

  Meal findlById({required String id}) {
    return _meals.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetMeals() async {
    var url =
        'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/meals.json?auth=$authToken';
    try {
      final res = await http.get(Uri.parse(url));
      print('rees ${res.body}');
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favRes = await http.get(Uri.parse(url));
      final favdData = json.decode(favRes.body);

      List<Meal> loadedMeals = [];
      extractedData.forEach((mealId, mealData) {
        loadedMeals.add(Meal(
            id: mealId,
            title: mealData['title'],
            price: mealData['price'],
            imageUrl: mealData['imageUrl'],
            description: mealData['description'],
            isFavorite: favdData == null ? false : favdData[mealId] ?? false,
            categories: mealData['categories']));
        _meals = loadedMeals;
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }
//add meal to firebase & application(list)

  Future<void> addNewMeal(Meal meal) async {
    final String url =
        'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/meals.json?auth=$authToken';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'title': meal.title,
            'price': meal.price,
            'imageUrl': meal.imageUrl,
            'categories': meal.categories,
            'description': meal.description
          }));
      final newMeal = Meal(
          id: json.decode(res.body)['name'],
          title: meal.title,
          price: meal.price,
          description: meal.description,
          imageUrl: meal.imageUrl,
          categories: meal.categories);
      _meals.insert(0, newMeal);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

//update meal in firebase & application(list)
  Future<void> updateMeal(String id, Meal newMeal) async {
    final index = _meals.indexWhere((mealId) => mealId.id == id);

    if (index >= 0) {
      final url =
          'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/meals/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newMeal.title,
            'price': newMeal.price,
            'imageUrl': newMeal.imageUrl,
            'categories': newMeal.categories,
            'description': newMeal.description
          }));
      _meals[index] = newMeal;
      notifyListeners();
    } else {
      print('********');
    }
  }

  //delete meal from firebase & application(list)

  Future<void> deleteMeal(String id) async {
    final exestingMealIndex = _meals.indexWhere((mealId) => mealId.id == id);
    Meal? exestingMeal = _meals[exestingMealIndex];
    _meals.removeAt(exestingMealIndex);
    notifyListeners();

    final url =
        'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/meals/$id.json?auth=$authToken';
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode <= 400) {
      _meals.insert(exestingMealIndex, exestingMeal);
      notifyListeners();
    } else {
      exestingMeal = null;
      notifyListeners();
    }
  }
}

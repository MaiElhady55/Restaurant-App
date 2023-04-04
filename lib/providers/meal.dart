import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Meal with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
 late final List<dynamic> categories;
  bool isFavorite;

  Meal(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.imageUrl,
      required this.categories,
      this.isFavorite = false,});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toogleFavoriteStatus(
      {required String token, required String userId}) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final String url =
        'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final res = await http.put(Uri.parse(url), body: json.encode(isFavorite));
      if (res.statusCode < 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }
}

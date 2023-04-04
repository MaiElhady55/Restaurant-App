import 'package:flutter/cupertino.dart';

class Category with ChangeNotifier {
  final String id;
  final dynamic symbol;
  final String title;
  final String imageUrl;

  Category({
    required this.id,
    required this.symbol,
    required this.title,
    required this.imageUrl,
  });
}

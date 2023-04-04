import 'package:flutter/cupertino.dart';
import 'package:resturant_app/models/category.dart';

class CategoriesList with ChangeNotifier {
  List<dynamic> _mySelectedCat = [];

  final List<Category> _catogeriesList = [
    Category(
      id: 'c1',
      title: 'BreakFast',
      symbol: 'break',
      imageUrl: 'assets/images/lunch.png',
    ),
    Category(
      id: 'c2',
      title: 'Lunch',
      symbol: 'lunch',
      imageUrl: 'assets/images/preak.png',
    ),
    Category(
      id: 'c3',
      title: 'Burger',
      symbol: 'burger',
      imageUrl: 'assets/images/burger.png',
    ),
    Category(
      id: 'c4',
      title: 'Chips',
      symbol: 'chips',
      imageUrl: 'assets/images/chips.png',
    ),
    Category(
      id: 'c5',
      title: 'Pizza',
      symbol: 'pizza',
      imageUrl: 'assets/images/pizza.png',
    ),
    Category(
      id: 'c6',
      title: 'Drink',
      symbol: 'drink',
      imageUrl: 'assets/images/drink.png',
    ),
  ];
  List<Category> get catogeriesList {
    return List.from(_catogeriesList);
  }

  void addNewCategory(Category category) {
    final newCategory = Category(
        id: DateTime.now().toString(),
        symbol: category.symbol,
        title: category.title,
        imageUrl: category.imageUrl);
    _catogeriesList.insert(0, newCategory);
    notifyListeners();
  }

  void updateCategory({required Category editingCategory, required String id}) {
    final excistingIndex =
        _catogeriesList.indexWhere((catId) => catId.id == id);
    if (excistingIndex >= 0) {
      _catogeriesList[excistingIndex] = editingCategory;
      notifyListeners();
    } else {
      print('****');
    }
  }

  void removeCategory({required String id}) {
    _catogeriesList.removeWhere((catId) => catId.id == id);
    notifyListeners();
  }

////////////////////////////////////////////////////

  List<Category> get mySelectedCat {
    return List.from(_mySelectedCat);
  }

  void addSymobl(dynamic symbol) {
    _mySelectedCat.add(symbol);
    notifyListeners();
  }

  void addSymoblList(List<dynamic> symbolList) {
    _mySelectedCat=symbolList;
    notifyListeners();
  }

   void removeSymobl(dynamic symbol) {
    _mySelectedCat.remove(symbol);
    notifyListeners();
  }

   void emptyMySelectedCat() {
    _mySelectedCat.clear();
    notifyListeners();
  }
}

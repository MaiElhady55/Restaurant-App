import 'package:flutter/cupertino.dart';
import 'package:resturant_app/models/cart.dart';

class Carts with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return Map.from(_items);
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
      {required String mealId,
      required String title,
      required double price,
      required String imageUrl}) {
    if (_items.containsKey(mealId)) {
      _items.update(
          mealId,
          (existingCartItem) => Cart(
              id: mealId,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price,
              imageUrl: existingCartItem.imageUrl));
    } else {
      _items.putIfAbsent(
          mealId,
          () => Cart(
              id: mealId,
              title: title,
              quantity: 1,
              price: price,
              imageUrl: imageUrl));
    }
    notifyListeners();
  }

//Remove item from cartItems
  void removeItem({required String mealId}) {
    _items.remove(mealId);
    notifyListeners();
  }

//Reset _items after Order Done !
  void clearCart() {
    _items.clear();
  }

  //UNDO add item to the cart
  void removeSingleItem({required String mealId}) {
    if (!_items.containsKey(mealId)) {
      return;
    }
    if (_items[mealId]!.quantity > 1) {
      _items.update(
        mealId,
        (existingCartItem) => Cart(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.remove(mealId);
    }
    notifyListeners();
  }
}

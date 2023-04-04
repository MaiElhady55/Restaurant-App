import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:resturant_app/models/cart.dart';
import 'package:resturant_app/models/order.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  String authToken = '';
  String userId = '';
  List<Order> _orders = [];

  void getData(String authTok, String uID, List<Order> items) {
    authToken = authTok;
    userId = uID;
    _orders = items;
    notifyListeners();
  }

  List<Order> get orders {
    return List.from(_orders);
  }

  Future<void> fetchOrders() async {
    final String url =
        'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/orderss/$userId.json?auth=$authToken';
    try {
      http.Response res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<Order> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(Order(
            id: orderId,
            amount: orderData['amount'],
            meals: (orderData['meals'] as List<dynamic>)
                .map((myCart) => Cart(
                    id: myCart['id'],
                    title: myCart['title'],
                    quantity: myCart['quantity'],
                    price: myCart['price'],
                    imageUrl: myCart['imageUrl']))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));

        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<Cart> cartMeals, double total) async {
    final String url =
        'https://resturant-app-b5f2a-default-rtdb.firebaseio.com/orderss/$userId.json?auth=$authToken';
    var timeStamp = DateTime.now();
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp,
            'meals': cartMeals
                .map((cm) => Cart(
                    id: cm.id,
                    title: cm.title,
                    quantity: cm.quantity,
                    price: cm.price,
                    imageUrl: cm.imageUrl))
                .toList(),
          }));
      _orders.insert(
          0,
          Order(
              id: json.decode(res.body)['name'],
              amount: total,
              meals: cartMeals,
              dateTime: timeStamp));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}

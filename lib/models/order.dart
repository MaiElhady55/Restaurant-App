import 'cart.dart';

class Order {
  final String id;
  final double amount;
  final List<Cart> meals;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.meals,
    required this.dateTime,
  });

}
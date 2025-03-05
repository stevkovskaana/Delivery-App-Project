import 'dish.dart';

class CartItem {
  String dishId;
  String dishName;
  int quantity;
  String specialRequest;
  Dish? dish;

  CartItem({
    required this.dishId,
    required this.dishName,
    required this.quantity,
    required this.specialRequest,
    this.dish,
  });

  Map<String, dynamic> toMap() {
    return {
      'dishId': dishId,
      'dishName': dishName,
      'quantity': quantity,
      'specialRequest': specialRequest,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      dishId: map['dishId'],
      dishName: map['dishName'] ?? '',
      quantity: map['quantity'],
      specialRequest: map['specialRequest'] ?? '',
    );
  }
}

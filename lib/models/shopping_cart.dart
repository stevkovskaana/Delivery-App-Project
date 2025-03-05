import 'cart_item.dart';

class ShoppingCart {
  String userId;
  List<CartItem> cartItems;
  double totalPrice;
  String status;

  ShoppingCart({
    required this.userId,
    required this.cartItems,
    required this.totalPrice,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  factory ShoppingCart.fromMap(Map<String, dynamic> map) {
    return ShoppingCart(
      userId: map['userId'],
      cartItems: List<CartItem>.from(
        map['cartItems'].map((item) => CartItem.fromMap(item)),
      ),
      totalPrice: map['totalPrice'],
      status: map['status'],
    );
  }
}

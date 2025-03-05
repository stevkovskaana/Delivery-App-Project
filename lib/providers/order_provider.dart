import 'package:flutter/cupertino.dart';
import '../models/dish.dart';
import '../models/order.dart';
import '../models/shopping_cart.dart';
import '../services/firestore_service.dart';

class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserOrder> _orders = [];

  List<UserOrder> get orders => _orders;

  Future<void> fetchOrdersByUserId(String userId) async {
    _orders = await _firestoreService.getOrdersByUserId(userId);
    notifyListeners();
  }

  Future<void> confirmOrder(String userId, ShoppingCart shoppingCart,
      String address, String name, String contact) async {
    try {
      await _firestoreService.confirmOrder(
          userId, shoppingCart, address, name, contact);

      await fetchOrdersByUserId(userId);
    } catch (e) {
      print("Error confirming order: $e");
    }
  }

  Future<Dish?> getDishById(String dishId) async {
    try {
      return await _firestoreService.getDishById(dishId);
    } catch (e) {
      print("Error fetching dish: $e");
      return null;
    }
  }

  void clearOrders() {
    _orders = [];
    notifyListeners();
  }
}

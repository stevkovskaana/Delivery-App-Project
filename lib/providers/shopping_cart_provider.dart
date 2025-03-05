import 'package:flutter/material.dart';
import '../models/shopping_cart.dart';
import '../models/cart_item.dart';
import '../services/firestore_service.dart';

class ShoppingCartProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  ShoppingCart? _shoppingCart;

  ShoppingCart? get shoppingCart => _shoppingCart;

  Future<void> fetchShoppingCart(String userId) async {
    _shoppingCart = await _firestoreService.getShoppingCart(userId);
    notifyListeners();
  }

  Future<void> addToCart(String userId, CartItem cartItem) async {
    await _firestoreService.addOrUpdateCartItem(userId, cartItem);
    await fetchShoppingCart(userId);
  }

  Future<void> removeFromCart(String userId, String dishId) async {
    await _firestoreService.removeCartItem(userId, dishId);
    await fetchShoppingCart(userId);
  }

  Future<void> clearCart(String userId) async {
    await _firestoreService.clearCart(userId);
    _shoppingCart = null;
    notifyListeners();
  }
}

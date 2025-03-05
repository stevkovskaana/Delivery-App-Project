import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_item.dart';
import '../models/restaurant.dart';
import '../models/dish.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/review.dart';
import '../models/shopping_cart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      await _db
          .collection('restaurants')
          .doc(restaurant.id)
          .set(restaurant.toMap());
    } catch (e) {
      print('Error adding restaurant: $e');
      rethrow;
    }
  }

  Future<Restaurant?> getRestaurant() async {
    try {
      var querySnapshot = await _db.collection('restaurants').limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        return Restaurant.fromMap(doc.data(), doc.id);
      }
    } catch (e) {
      print('Error fetching restaurant: $e');
    }
    return null;
  }

  Future<void> addDishes(List<Dish> dishes, String restaurantId) async {
    try {
      final batch = _db.batch();
      for (var dish in dishes) {
        var dishRef = _db.collection('dishes').doc(dish.id);
        batch.set(dishRef, dish.toMap()..['restaurantId'] = restaurantId);
      }
      await batch.commit();
    } catch (e) {
      print('Error adding dishes: $e');
      rethrow;
    }
  }

  Future<List<Dish>> getAllDishes(String restaurantId) async {
    try {
      var snapshot = await _db
          .collection('dishes')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      return snapshot.docs.map((doc) => Dish.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching dishes: $e');
      return [];
    }
  }

  Future<Dish?> getDishById(String id) async {
    try {
      var doc = await _db.collection('dishes').doc(id).get();
      if (doc.exists) {
        return Dish.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Error fetching dish: $e');
    }
    return null;
  }

  Future<ShoppingCart?> getShoppingCart(String userId) async {
    try {
      var doc = await _db.collection('shopping_carts').doc(userId).get();
      if (!doc.exists || doc.data() == null) return null;

      ShoppingCart shoppingCart = ShoppingCart.fromMap(doc.data()!);

      for (var cartItem in shoppingCart.cartItems) {
        var dishDoc = await _db.collection('dishes').doc(cartItem.dishId).get();
        if (dishDoc.exists) {
          cartItem.dish = Dish.fromMap(dishDoc.data()!);
        }
      }

      double newTotalPrice = _calculateTotalPrice(shoppingCart);
      shoppingCart.totalPrice = newTotalPrice;

      await _db.collection('shopping_carts').doc(userId).update({
        'totalPrice': newTotalPrice,
      });

      return shoppingCart;
    } catch (e) {
      print('Error fetching/updating shopping cart: $e');
      return null;
    }
  }

  Future<void> addOrUpdateCartItem(String userId, CartItem cartItem) async {
    try {
      var cartDoc = _db.collection('shopping_carts').doc(userId);
      var cartSnapshot = await cartDoc.get();

      ShoppingCart shoppingCart;

      if (cartSnapshot.exists && cartSnapshot.data() != null) {
        shoppingCart = ShoppingCart.fromMap(cartSnapshot.data()!);

        if (shoppingCart.status == 'closed') {
          shoppingCart.status = 'active';
        }

        var existingIndex = shoppingCart.cartItems
            .indexWhere((item) => item.dishId == cartItem.dishId);

        if (existingIndex != -1) {
          shoppingCart.cartItems[existingIndex].quantity += cartItem.quantity;
        } else {
          shoppingCart.cartItems.add(cartItem);
        }

        shoppingCart.totalPrice = _calculateTotalPrice(shoppingCart);

        await cartDoc.set(shoppingCart.toMap());
      } else {
        shoppingCart = ShoppingCart(
          userId: userId,
          cartItems: [cartItem],
          totalPrice: cartItem.dish?.price ?? 0.0,
          status: "active",
        );
        await cartDoc.set(shoppingCart.toMap());
      }
    } catch (e) {
      print('Error updating cart item: $e');
      rethrow;
    }
  }

  Future<void> removeCartItem(String userId, String dishId) async {
    try {
      var cartDoc = _db.collection('shopping_carts').doc(userId);
      var cartSnapshot = await cartDoc.get();

      if (!cartSnapshot.exists || cartSnapshot.data() == null) return;

      ShoppingCart shoppingCart = ShoppingCart.fromMap(cartSnapshot.data()!);
      shoppingCart.cartItems.removeWhere((item) => item.dishId == dishId);
      shoppingCart.totalPrice = _calculateTotalPrice(shoppingCart);

      if (shoppingCart.cartItems.isEmpty) {
        await cartDoc.update({
          'status': 'closed',
          'cartItems': [],
          'totalPrice': 0.0,
        });
      } else {
        await cartDoc.update(shoppingCart.toMap());
      }
    } catch (e) {
      print('Error removing cart item: $e');
      rethrow;
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      await _db.collection('shopping_carts').doc(userId).delete();
    } catch (e) {
      print('Error clearing shopping cart: $e');
      rethrow;
    }
  }

  double _calculateTotalPrice(ShoppingCart cart) {
    return cart.cartItems.fold(0.0, (sum, item) {
      double itemPrice = item.dish?.price ?? 0.0;
      return sum + (item.quantity * itemPrice);
    });
  }

  Future<void> confirmOrder(String userId, ShoppingCart shoppingCart,
      String address, String name, String contact) async {
    try {
      String orderId = _db.collection('orders').doc().id;
      List<OrderItem> orderItems = shoppingCart.cartItems.map((cartItem) {
        return OrderItem(
          dishId: cartItem.dishId,
          dishName: cartItem.dishName,
          quantity: cartItem.quantity,
          specialRequest: cartItem.specialRequest,
        );
      }).toList();

      UserOrder newOrder = UserOrder(
        orderId: orderId,
        userId: userId,
        recipientName: name,
        orderDate: Timestamp.now(),
        totalPrice: shoppingCart.totalPrice,
        status: "placed",
        deliveryAddress: address,
        contactNumber: contact,
        orderItems: orderItems,
      );

      await _db.collection('orders').doc(orderId).set(newOrder.toMap());

      await _db.collection('shopping_carts').doc(userId).update({
        'status': 'closed',
        'cartItems': [],
        'totalPrice': 0.0,
      });
    } catch (e) {
      print('Error confirming order: $e');
      rethrow;
    }
  }

  Future<List<UserOrder>> getOrdersByUserId(String userId) async {
    try {
      var snapshot = await _db
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) => UserOrder.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _db.collection('reviews').doc(review.orderId).set(review.toMap());
    } catch (e) {
      print('Error adding review: $e');
      rethrow;
    }
  }

  Future<void> markOrderAsDelivered(String orderId) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': 'delivered',
      });
    } catch (e) {
      print('Error marking order as delivered: $e');
      rethrow;
    }
  }
}

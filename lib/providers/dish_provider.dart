import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/dish.dart';

class DishProvider with ChangeNotifier {
  List<Dish> _dishes = [];
  bool _isLoading = true;

  List<Dish> get dishes => _dishes;

  bool get isLoading => _isLoading;

  Future<void> fetchDishes() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('dishes').get();
      _dishes =
          querySnapshot.docs.map((doc) => Dish.fromMap(doc.data())).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching dishes: $e');
      rethrow;
    }
  }
}

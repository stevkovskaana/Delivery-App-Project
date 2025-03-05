import 'package:flutter/cupertino.dart';
import '../models/restaurant.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class RestaurantProvider with ChangeNotifier {
  Restaurant? _restaurant;
  double? _averageRating;
  final FirestoreService _firestoreService = FirestoreService();

  Restaurant? get restaurant => _restaurant;

  double? get averageRating => _averageRating;

  Future<void> fetchRestaurant() async {
    try {
      _restaurant = await _firestoreService.getRestaurant();

      await _fetchAverageRating();

      notifyListeners();
    } catch (e) {
      print('Error fetching restaurant data: $e');
      rethrow;
    }
  }

  Future<void> _fetchAverageRating() async {
    try {
      final reviewSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('orderId', isNotEqualTo: '')
          .get();

      if (reviewSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        int count = 0;

        for (var doc in reviewSnapshot.docs) {
          final review = Review.fromMap(doc.data(), doc.id);
          totalRating += review.rating;
          count++;
        }

        _averageRating = totalRating / count;
      } else {
        _averageRating = 0;
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }
}

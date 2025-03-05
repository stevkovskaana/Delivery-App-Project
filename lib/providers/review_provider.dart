import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';
import '../services/firestore_service.dart';
import '../providers/order_provider.dart';

class ReviewProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  Future<void> submitFeedback({
    required String orderId,
    required double rating,
    required String comment,
    String? imagePath,
    required String userId,
    required BuildContext context,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    String? base64Image;
    if (imagePath != null) {
      base64Image = imagePath;
    }

    final review = Review(
      id: orderId,
      userId: userId,
      orderId: orderId,
      rating: rating.toInt(),
      comment: comment,
      photoUrl: base64Image ?? "",
      createdAt: Timestamp.now(),
    );

    try {
      await _firestoreService.addReview(review);

      await _firestoreService.markOrderAsDelivered(orderId);

      Provider.of<OrderProvider>(context, listen: false).clearOrders();
    } catch (e) {
      print('Error submitting review: $e');
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}

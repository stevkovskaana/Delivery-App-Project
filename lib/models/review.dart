import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String orderId;
  final String userId;
  final int rating;
  final String comment;
  final String? photoUrl;
  final Timestamp createdAt;

  Review({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.rating,
    required this.comment,
    this.photoUrl,
    required this.createdAt,
  });

  DateTime get createdAtDateTime => createdAt.toDate();

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      orderId: map['orderId'],
      userId: map['userId'],
      rating: map['rating'],
      comment: map['comment'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'],
    );
  }
}

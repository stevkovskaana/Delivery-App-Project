import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_item.dart';

class UserOrder {
  String orderId;
  String userId;
  String recipientName;
  Timestamp orderDate;
  double totalPrice;
  String status;
  String deliveryAddress;
  String contactNumber;
  List<OrderItem> orderItems;

  UserOrder({
    required this.orderId,
    required this.userId,
    required this.recipientName,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.deliveryAddress,
    required this.contactNumber,
    required this.orderItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'recipientName': recipientName,
      'orderDate': orderDate,
      'totalPrice': totalPrice,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'contactNumber': contactNumber,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
    };
  }

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    return UserOrder(
      orderId: map['orderId'],
      userId: map['userId'],
      recipientName: map['recipientName'] ?? "",
      orderDate: map['orderDate'],
      totalPrice: map['totalPrice'],
      status: map['status'],
      deliveryAddress: map['deliveryAddress'],
      contactNumber: map['contactNumber'],
      orderItems: List<OrderItem>.from(
        map['orderItems'].map((item) => OrderItem.fromMap(item)),
      ),
    );
  }
}

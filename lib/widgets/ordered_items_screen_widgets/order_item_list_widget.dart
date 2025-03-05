import 'package:flutter/material.dart';
import 'package:delivery_app/models/order_item.dart';
import 'order_item_widget.dart';

class OrderItemListWidget extends StatelessWidget {
  final List<OrderItem> orderItems;
  final String userId;

  const OrderItemListWidget({
    super.key,
    required this.orderItems,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: orderItems
          .map((orderItem) => OrderItemWidget(
                orderItem: orderItem,
                index: orderItems.indexOf(orderItem),
                userId: userId,
              ))
          .toList(),
    );
  }
}

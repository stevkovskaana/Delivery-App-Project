import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/models/order_item.dart';
import 'package:delivery_app/providers/order_provider.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem orderItem;
  final int index;
  final String userId;

  const OrderItemWidget({
    super.key,
    required this.orderItem,
    required this.index,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<OrderProvider>(context, listen: false)
          .getDishById(orderItem.dishId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox(
            height: 80,
            child: Center(child: Icon(Icons.error, color: Colors.red)),
          );
        }

        final dish = snapshot.data;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Image.network(
              dish!.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
            title: Text(
              dish.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderItem.specialRequest.isNotEmpty
                    ? 'Special Request: ${orderItem.specialRequest}\nQuantity: ${orderItem.quantity}'
                    : 'Quantity: ${orderItem.quantity}'),
                Text(
                    '\$${(dish.price * orderItem.quantity).toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

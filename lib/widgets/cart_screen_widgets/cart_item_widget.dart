import 'package:flutter/material.dart';
import 'package:delivery_app/models/cart_item.dart';
import '../../screens/cart_item_details_screen.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final int index;
  final String userId;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.index,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CartItemDetailsScreen(
              cartItem: cartItem,
              index: index,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Image.network(
                  cartItem.dish?.imageUrl ?? '',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.dish?.name ?? 'Dish Name',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text('Quantity: ${cartItem.quantity}'),
                    Text(
                        'Total: \$${(cartItem.quantity * (cartItem.dish?.price ?? 0)).toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

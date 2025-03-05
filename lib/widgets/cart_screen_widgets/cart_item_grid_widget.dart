import 'package:delivery_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'cart_item_widget.dart';

class CartItemGridWidget extends StatelessWidget {
  final List<CartItem> cartItems;
  final String userId;

  const CartItemGridWidget(
      {super.key, required this.cartItems, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      scrollDirection: Axis.vertical,
      itemCount: cartItems.length,
      itemBuilder: (ctx, i) => CartItemWidget(
        cartItem: cartItems[i],
        index: i,
        userId: userId,
      ),
    );
  }
}

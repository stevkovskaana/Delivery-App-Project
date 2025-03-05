import 'package:delivery_app/widgets/add_to_cart_screen_widget/dish_details_widget.dart';
import 'package:delivery_app/widgets/add_to_cart_screen_widget/dish_image.dart';
import 'package:delivery_app/models/cart_item.dart';
import 'package:delivery_app/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/add_to_cart_screen_widget/button_widget.dart';
import '../widgets/app_bar_widget.dart';

class CartItemDetailsScreen extends StatelessWidget {
  final CartItem cartItem;
  final int index;

  const CartItemDetailsScreen({
    super.key,
    required this.cartItem,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const CustomAppBar(
        titleText: 'Olive Grove',
        actions: [],
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DishImage(imageUrl: cartItem.dish!.imageUrl),
            const SizedBox(height: 10),
            DishDetailsWidget(dish: cartItem.dish!),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Special Request:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cartItem.specialRequest.isEmpty
                    ? 'None'
                    : cartItem.specialRequest,
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quantity: ${cartItem.quantity}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total: \$${(cartItem.quantity * cartItem.dish!.price).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
              child: ButtonWidget(
                text: 'Remove from Cart',
                onPressed: () {
                  if (userId != null) {
                    Provider.of<ShoppingCartProvider>(context, listen: false)
                        .removeFromCart(userId, cartItem.dishId);
                    Navigator.of(context).pop();
                  } else {
                    print('User is not logged in');
                  }
                },
                isDisabled: false,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

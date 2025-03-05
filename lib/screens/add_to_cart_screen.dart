import 'package:delivery_app/widgets/add_to_cart_screen_widget/dish_details_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../models/dish.dart';
import '../providers/shopping_cart_provider.dart';
import '../widgets/add_to_cart_screen_widget/button_widget.dart';
import '../widgets/add_to_cart_screen_widget/dish_image.dart';
import '../widgets/add_to_cart_screen_widget/input_fields_widgets.dart';
import '../widgets/app_bar_widget.dart';

class AddToCartScreen extends StatefulWidget {
  final Dish dish;

  const AddToCartScreen({super.key, required this.dish});

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  int _quantity = 1;
  String _specialRequest = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        titleText: 'Olive Grove',
        actions: [],
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DishImage(imageUrl: widget.dish.imageUrl),
            const SizedBox(height: 10),
            DishDetailsWidget(dish: widget.dish),
            const SizedBox(height: 10),
            AddToCartInputFieldsWidget(
              quantity: _quantity,
              onQuantityChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
              specialRequest: _specialRequest,
              onSpecialRequestChanged: (value) {
                setState(() {
                  _specialRequest = value;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
        child: ButtonWidget(
          text: 'Add to Cart',
          onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Please log in to add items to the cart.")),
              );
              Navigator.of(context).pushReplacementNamed('/menu');
              return;
            }

            final cartItem = CartItem(
              dishId: widget.dish.id,
              dishName: widget.dish.name,
              quantity: _quantity,
              specialRequest: _specialRequest,
            );

            Provider.of<ShoppingCartProvider>(context, listen: false)
                .addToCart(user.uid, cartItem);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.dish.name} added to cart!')),
            );
            Navigator.of(context).pop();
          },
          isDisabled: false,
          color: const Color(0xFF8B6F4E),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_cart_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/add_to_cart_screen_widget/button_widget.dart';
import '../widgets/cart_screen_widgets/cart_item_grid_widget.dart';
import '../widgets/cart_screen_widgets/total_price_widget.dart';
import 'delivery_details_screen.dart';
import 'authentication_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        Provider.of<ShoppingCartProvider>(context, listen: false)
            .fetchShoppingCart(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE6D4AA),
      appBar: const CustomAppBar(
        titleText: 'Shopping Cart',
        actions: [],
        showBackButton: true,
      ),
      body: Consumer<ShoppingCartProvider>(
        builder: (context, shoppingCartProvider, child) {
          final cartItems = shoppingCartProvider.shoppingCart?.cartItems ?? [];

          double totalPrice = 0.0;
          for (var item in cartItems) {
            final dish = item.dish;
            if (dish != null) {
              totalPrice += dish.price * item.quantity;
            }
          }

          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty!',
                style: TextStyle(fontSize: 15),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CartItemGridWidget(
                    cartItems: cartItems,
                    userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ButtonWidget(
                  text: 'Place Order',
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          if (user == null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AuthenticationScreen(),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DeliveryDetailsScreen(
                                  totalPrice: totalPrice,
                                  shoppingCart:
                                      shoppingCartProvider.shoppingCart!,
                                ),
                              ),
                            );
                          }
                        },
                  isDisabled: cartItems.isEmpty,
                  color: const Color(0xFF8B6F4E),
                ),
              ),
              TotalPriceWidget(totalPrice: totalPrice),
            ],
          );
        },
      ),
    );
  }
}

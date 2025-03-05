import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../widgets/add_to_cart_screen_widget/button_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/ordered_items_screen_widgets/order_item_widget.dart';
import 'feedback_screen.dart';

class OrderedItemsScreen extends StatefulWidget {
  const OrderedItemsScreen({super.key});

  @override
  _OrderedItemsScreenState createState() => _OrderedItemsScreenState();
}

class _OrderedItemsScreenState extends State<OrderedItemsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await Provider.of<OrderProvider>(context, listen: false)
            .fetchOrdersByUserId(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE6D4AA),
      appBar: const CustomAppBar(
        titleText: 'Ordered Items',
        showBackButton: true,
        actions: [],
      ),
      body: user == null
          ? const Center(
              child: Text(
                'Please log in to view orders!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                final orderedItems = orderProvider.orders
                    .where((order) => order.status != 'delivered')
                    .expand((order) => order.orderItems)
                    .toList();

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: orderedItems.isEmpty
                          ? const Center(
                              child: Text(
                                'No orders yet!',
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 10),
                              itemCount: orderedItems.length,
                              itemBuilder: (context, index) {
                                final item = orderedItems[index];
                                return OrderItemWidget(
                                  orderItem: item,
                                  index: index,
                                  userId: user.uid,
                                );
                              },
                            ),
                    ),
                    if (orderedItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ButtonWidget(
                          text: 'Confirm Delivered Order',
                          onPressed: () {
                            String orderId = orderProvider.orders.first.orderId;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    FeedbackScreen(orderId: orderId),
                              ),
                            );
                          },
                          isDisabled: false,
                          color: const Color(0xFF8B6F4E),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }
}

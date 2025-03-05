import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../providers/order_provider.dart';
import '../widgets/delivery_details_screen_widgets/input_fields_widget.dart';
import '../widgets/add_to_cart_screen_widget/button_widget.dart';
import '../widgets/cart_screen_widgets/total_price_widget.dart';
import 'pick_location_screen.dart';
import '../models/shopping_cart.dart';
import '../widgets/app_bar_widget.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final double totalPrice;
  final ShoppingCart shoppingCart;

  const DeliveryDetailsScreen(
      {super.key, required this.totalPrice, required this.shoppingCart});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _confirmOrder(BuildContext context) async {
    final address = _addressController.text.trim();
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();

    if (name.isEmpty || contact.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to place an order.')),
      );
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    try {
      await orderProvider.confirmOrder(
        userId,
        widget.shoppingCart,
        address,
        name,
        contact,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order confirmed!')),
      );

      Navigator.pushReplacementNamed(context, '/menu');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming order: $e')),
      );
    }
  }

  Future<void> _pickLocation() async {
    LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PickLocationScreen()),
    );

    if (selectedLocation != null) {
      setState(() {
        _addressController.text =
            "Lat: ${selectedLocation.latitude.toStringAsFixed(4)}, Lng: ${selectedLocation.longitude.toStringAsFixed(4)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6D4AA),
      appBar: const CustomAppBar(
        titleText: 'Delivery Details',
        actions: [],
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  InputFieldsWidget(
                    controller: _nameController,
                    label: 'Recipient Name',
                  ),
                  const SizedBox(height: 20),
                  InputFieldsWidget(
                    controller: _contactController,
                    label: 'Contact Number',
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  InputFieldsWidget(
                    controller: _addressController,
                    label: 'Delivery Address',
                    readOnly: true,
                    iconButton: IconButton(
                      icon:
                          const Icon(Icons.map, color: Colors.black, size: 30),
                      onPressed: _pickLocation,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ButtonWidget(
              text: 'Confirm Order',
              onPressed: () {
                _confirmOrder(context);
              },
              isDisabled: false,
              color: const Color(0xFF8B6F4E),
            ),
          ),
          const SizedBox(height: 0),
          TotalPriceWidget(totalPrice: widget.totalPrice),
        ],
      ),
    );
  }
}

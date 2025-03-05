import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dish_provider.dart';
import '../services/authentication_service.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/menu_screen_widgets/dishes_grid.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<DishProvider>(context, listen: false).fetchDishes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dishProvider = Provider.of<DishProvider>(context);
    final authService =
        Provider.of<AuthenticationService>(context, listen: false);
    final currentUser = authService.getCurrentUser();

    final appBarIcons = [
      IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
      ),
      IconButton(
        icon: const Icon(Icons.receipt_long, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed('/ordered_items');
        },
      ),
      IconButton(
        icon: const Icon(Icons.business, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed('/about_us');
        },
      ),
      currentUser != null
          ? IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await authService.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
                setState(() {});
              },
            )
          : IconButton(
              icon: const Icon(Icons.login, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamed('/authentication');
              },
            ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE6D4AA),
      appBar: CustomAppBar(
        titleText: 'Olive Grove',
        actions: appBarIcons,
      ),
      body: dishProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : const DishGrid(),
    );
  }
}

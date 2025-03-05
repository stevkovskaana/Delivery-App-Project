import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../services/authentication_service.dart';
import '../widgets/about_us_screen_widgets/restaurant_details_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_image.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    restaurantProvider.fetchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthenticationService>(context, listen: false);
    final currentUser = authService.getCurrentUser();
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final restaurant = restaurantProvider.restaurant;
    final averageRating = restaurantProvider.averageRating;

    if (restaurant == null) {
      return const Scaffold(
        appBar: CustomAppBar(
          titleText: 'Olive Grove',
          actions: [],
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final appBarIcons = [
      IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/cart');
        },
      ),
      IconButton(
        icon: const Icon(Icons.receipt_long, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed('/ordered_items');
        },
      ),
      IconButton(
        icon: const Icon(Icons.menu_book, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed('/menu');
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (restaurant.imageUrl.isNotEmpty)
            BackgroundImage(imageUrl: restaurant.imageUrl),
          RestaurantDetailsWidget(
            restaurant: restaurant,
            averageRating: averageRating,
          ),
        ],
      ),
    );
  }
}

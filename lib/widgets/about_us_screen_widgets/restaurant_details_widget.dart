import 'package:flutter/material.dart';
import '../../models/restaurant.dart';
import 'star_rating_widget.dart';

class RestaurantDetailsWidget extends StatelessWidget {
  final Restaurant restaurant;
  final double? averageRating;

  const RestaurantDetailsWidget({
    super.key,
    required this.restaurant,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Welcome to ${restaurant.name}!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Olive Grove offers high-quality dishes, delivered straight to your door. Enjoy our flavorful meals crafted from fresh ingredients, perfect for any craving.',
            style: TextStyle(fontSize: 18, color: Colors.white, height: 1.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Address: ${restaurant.address}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contact: ${restaurant.contact}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Working Hours: ${restaurant.workingHours}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'We are excited to serve you the best food in town!',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 16),
          if (averageRating != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Average Delivery Rating: ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                StarRating(rating: averageRating ?? 0.0),
              ],
            ),
        ],
      ),
    );
  }
}

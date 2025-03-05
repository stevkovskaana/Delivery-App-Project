import 'package:flutter/material.dart';

class DishImage extends StatelessWidget {
  final String imageUrl;

  const DishImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(10),
      ),
      child: Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

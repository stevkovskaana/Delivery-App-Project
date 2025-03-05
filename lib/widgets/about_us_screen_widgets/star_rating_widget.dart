import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$rating ',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20,
        ),
      ],
    );
  }
}

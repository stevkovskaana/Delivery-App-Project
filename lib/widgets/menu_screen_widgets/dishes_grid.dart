import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dish.dart';
import '../../providers/dish_provider.dart';
import '../menu_screen_widgets/dish_widget.dart';

class DishGrid extends StatelessWidget {
  const DishGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final dishProvider = Provider.of<DishProvider>(context);
    final List<Dish> dishes = dishProvider.dishes;
    if (dishProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (dishes.isEmpty) {
      return const Center(child: Text("No dishes available"));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: dishes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return DishWidget(dish: dishes[index]);
      },
    );
  }
}

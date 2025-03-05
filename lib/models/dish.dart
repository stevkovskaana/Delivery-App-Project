class Dish {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String ingredients;

  Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.ingredients,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
    };
  }

  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      ingredients: map['ingredients'] as String,
    );
  }
}

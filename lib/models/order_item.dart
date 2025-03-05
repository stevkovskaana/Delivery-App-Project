class OrderItem {
  String dishId;
  String dishName;
  int quantity;
  String specialRequest;

  OrderItem({
    required this.dishId,
    required this.dishName,
    required this.quantity,
    required this.specialRequest,
  });

  Map<String, dynamic> toMap() {
    return {
      'dishId': dishId,
      'dishName': dishName,
      'quantity': quantity,
      'specialRequest': specialRequest,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      dishId: map['dishId'],
      dishName: map['dishName'] ?? "",
      quantity: map['quantity'],
      specialRequest: map['specialRequest'],
    );
  }
}

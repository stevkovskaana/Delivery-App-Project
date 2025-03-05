class Restaurant {
  final String id;
  final String name;
  final String address;
  final String contact;
  final String workingHours;
  final String imageUrl;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    required this.workingHours,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'contact': contact,
      'workingHours': workingHours,
      'imageUrl': imageUrl,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> data, String id) {
    return Restaurant(
      id: id,
      name: data['name'],
      address: data['address'],
      contact: data['contact'],
      workingHours: data['workingHours'],
      imageUrl: data['imageUrl'],
    );
  }
}

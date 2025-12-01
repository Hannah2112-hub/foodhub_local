class Restaurant {
  final String id;
  final String name;
  final String address;
  final String zone;
  final String imageUrl;
  final double rating;
  final int deliveryTime;
  final String priceRange;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.zone,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.priceRange,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      zone: map['zone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      deliveryTime: map['deliveryTime'] ?? 0,
      priceRange: map['priceRange'] ?? '',
    );
  }
}

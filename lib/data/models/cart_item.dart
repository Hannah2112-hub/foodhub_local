class CartItem {
  final String storeId;
  final String storeName;
  final String productId;
  final String productName;
  final double price;
  int quantity;

  CartItem({
    required this.storeId,
    required this.storeName,
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });

  // Convertir de Map (Firebase)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      storeId: map['storeId'] ?? '',
      storeName: map['storeName'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }

  // Para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }
}

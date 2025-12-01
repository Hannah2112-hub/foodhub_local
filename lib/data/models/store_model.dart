import 'product_model.dart';

class StoreModel {
  final String id;
  final String name;
  final String zone;
  final double avgPrice;
  final int deliveryTime;
  final String imageUrl;
  final List<ProductModel> products;

  StoreModel({
    required this.id,
    required this.name,
    required this.zone,
    required this.avgPrice,
    required this.deliveryTime,
    required this.imageUrl,
    required this.products,
  });
}

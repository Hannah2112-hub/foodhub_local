import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String orderId;
  final String ratedId; // Puede ser restaurantId o deliveryId
  final String ratedType; // "restaurant" o "delivery"
  final String customerId;
  final int rating; // 1-5
  final String comment;
  final Timestamp createdAt;

  Review({
    required this.id,
    required this.orderId,
    required this.ratedId,
    required this.ratedType,
    required this.customerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      orderId: map['orderId'] ?? '',
      ratedId: map['ratedId'] ?? '',
      ratedType: map['ratedType'] ?? '',
      customerId: map['customerId'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'ratedId': ratedId,
      'ratedType': ratedType,
      'customerId': customerId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}

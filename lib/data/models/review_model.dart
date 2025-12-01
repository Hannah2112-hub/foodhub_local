import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String orderId;
  final String ratedId; // restaurantId o deliveryId
  final String ratedType; // 'restaurant' | 'delivery'
  final String customerId;
  final int rating; // 1..5
  final String? comment;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.ratedId,
    required this.ratedType,
    required this.customerId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'orderId': orderId,
        'ratedId': ratedId,
        'ratedType': ratedType,
        'customerId': customerId,
        'rating': rating,
        'comment': comment ?? '',
        'createdAt': createdAt != null ? createdAt!.toUtc() : FieldValue.serverTimestamp(),
      };

  factory ReviewModel.fromMap(Map<String, dynamic> m) => ReviewModel(
        id: m['id'] ?? '',
        orderId: m['orderId'] ?? '',
        ratedId: m['ratedId'] ?? '',
        ratedType: m['ratedType'] ?? '',
        customerId: m['customerId'] ?? '',
        rating: (m['rating'] ?? 0).toInt(),
        comment: m['comment'],
        createdAt: m['createdAt'] != null && m['createdAt'] is Timestamp
            ? (m['createdAt'] as Timestamp).toDate()
            : null,
      );
}

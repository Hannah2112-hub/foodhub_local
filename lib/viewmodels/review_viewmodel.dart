import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/review.dart';

class ReviewViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitReview(Review review) async {
    try {
      final docRef = _firestore.collection('reviews').doc();
      await docRef.set(review.toMap());
    } catch (e) {
      debugPrint('Error al enviar reseña: $e');
      rethrow;
    }
  }
}

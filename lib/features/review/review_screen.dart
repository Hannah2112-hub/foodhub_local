import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/review_viewmodel.dart';
import '../../data/models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewScreen extends StatefulWidget {
  final String orderId;
  final String restaurantId;
  final String deliveryId;

  const ReviewScreen({
    super.key,
    required this.orderId,
    required this.restaurantId,
    required this.deliveryId,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int restaurantRating = 0;
  int deliveryRating = 0;
  final TextEditingController restaurantCommentController = TextEditingController();
  final TextEditingController deliveryCommentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final reviewVM = Provider.of<ReviewViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(title: const Text("Valorar pedido"), backgroundColor: Colors.deepOrange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Valorar Restaurante", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < restaurantRating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: () => setState(() => restaurantRating = index + 1),
                );
              }),
            ),
            TextField(
              controller: restaurantCommentController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Comentario",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Valorar Repartidor", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < deliveryRating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: () => setState(() => deliveryRating = index + 1),
                );
              }),
            ),
            TextField(
              controller: deliveryCommentController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Comentario",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (restaurantRating > 0) {
                    await reviewVM.submitReview(
                      Review(
                        id: '',
                        orderId: widget.orderId,
                        ratedId: widget.restaurantId,
                        ratedType: 'restaurant',
                        customerId: userId,
                        rating: restaurantRating,
                        comment: restaurantCommentController.text,
                        createdAt: Timestamp.now(),
                      ),
                    );
                  }

                  if (deliveryRating > 0) {
                    await reviewVM.submitReview(
                      Review(
                        id: '',
                        orderId: widget.orderId,
                        ratedId: widget.deliveryId,
                        ratedType: 'delivery',
                        customerId: userId,
                        rating: deliveryRating,
                        comment: deliveryCommentController.text,
                        createdAt: Timestamp.now(),
                      ),
                    );
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reseña enviada")),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Enviar reseña", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

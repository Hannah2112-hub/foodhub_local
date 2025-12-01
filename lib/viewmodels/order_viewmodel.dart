import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/models/cart_item.dart';
import 'cart_viewmodel.dart';

class OrderViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Asignar un repartidor aleatorio real
  Future<String?> assignRandomDelivery() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'delivery')
        .get();

    if (snapshot.docs.isEmpty) return null;

    final rand = snapshot.docs[DateTime.now().millisecondsSinceEpoch % snapshot.docs.length];
    return rand.id;
  }

  // Crear pedido
  Future<String> createOrder({
    required String userId,
    required String restaurantId,
    required CartViewModel cartVM,
  }) async {
    final orderId = _firestore.collection('orders').doc().id;
    final deliveryId = await assignRandomDelivery();
    final total = cartVM.items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
    final now = Timestamp.now();

    await _firestore.collection('orders').doc(orderId).set({
      'id': orderId,
      'customerId': userId,
      'restaurantId': restaurantId,
      'deliveryId': deliveryId,
      'status': 'pending',
      'total': total,
      'createdAt': now,
      'updatedAt': now,
    });

    for (final item in cartVM.items) {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .collection('items')
          .doc(item.productId)
          .set({
        'id': item.productId,
        'productId': item.productId,
        'name': item.productName,
        'quantity': item.quantity,
        'price': item.price,
        'subtotal': item.price * item.quantity,
      });
    }

    cartVM.clearCart();
    return orderId;
  }

  // Obtener pedido por ID
  Future<Map<String, dynamic>?> getOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (doc.exists) return doc.data();
    return null;
  }

  // Cambiar estado de pedido (para delivery)
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  // Traer pedidos de un cliente
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Traer pedidos asignados a un repartidor
  Future<List<Map<String, dynamic>>> getDeliveryOrders(String deliveryId) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('deliveryId', isEqualTo: deliveryId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Traer pedidos pendientes (status = pending)
  Future<List<Map<String, dynamic>>> getPendingOrders() async {
    final snapshot = await _firestore
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
  
}

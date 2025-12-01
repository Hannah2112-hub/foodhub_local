import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 Obtener todos los pedidos sin filtrar restaurante
  Stream<List<Map<String, dynamic>>> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  /// 🔥 Aceptar pedido
  Future<void> acceptOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'accepted',
      'updatedAt': Timestamp.now(),
    });
  }

  /// 🔥 Marcar como preparando
  Future<void> markPreparing(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'preparing',
      'updatedAt': Timestamp.now(),
    });
  }

  /// 🔥 Marcar como listo para entrega
  Future<void> markReady(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'on_the_way',
      'updatedAt': Timestamp.now(),
    });
  }
}

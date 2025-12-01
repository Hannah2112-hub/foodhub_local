import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/models/delivery_persons.dart';

class DeliveryViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Pedidos pendientes (sin asignar)
  Future<List<Map<String, dynamic>>> getPendingOrders() async {
    final snapshot = await _firestore
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  // Pedidos asignados al repartidor
  Future<List<Map<String, dynamic>>> getAssignedOrders(String deliveryId) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('deliveryId', isEqualTo: deliveryId)
        .get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  // Aceptar pedido
  Future<void> acceptOrder(String orderId, String deliveryId) async {
    if (deliveryId.isEmpty) return;
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'on_the_way',
      'deliveryId': deliveryId, // UID real del repartidor
      'updatedAt': Timestamp.now(),
    });
  }

  // Marcar pedido como entregado
  Future<void> completeOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'delivered',
      'updatedAt': Timestamp.now(),
    });
  }

  // Obtener datos de un repartidor real de Firestore
  Future<DeliveryPerson?> getDeliveryById(String deliveryId) async {
    if (deliveryId.isEmpty) return null;

    final doc = await _firestore.collection('users').doc(deliveryId).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return DeliveryPerson(
      id: doc.id,
      name: data['name'] ?? 'Sin nombre',
      phone: data['phone'] ?? '-',
    );
  }
}

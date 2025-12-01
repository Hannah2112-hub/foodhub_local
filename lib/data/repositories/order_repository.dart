import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createOrder(OrderModel order) async {
    final docRef = await _firestore.collection('orders').add(order.toMap());
    return docRef.id;
  }

  Future<OrderModel> getOrderById(String id) async {
    final doc = await _firestore.collection('orders').doc(id).get();
    return OrderModel.fromMap(doc.data()!);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status.name,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<OrderModel> getOrderStream(String orderId) {
    return _firestore.collection('orders').doc(orderId).snapshots().map(
          (doc) => OrderModel.fromMap(doc.data()!),
        );
  }

  /// 🔥 Restaurantes NO son reales → mirar TODOS los pedidos
  Stream<List<OrderModel>> getAllOrdersStream() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList(),
        );
  }

  Future<List<OrderModel>> getCustomerOrders(String customerId) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data()))
        .toList();
  }
}

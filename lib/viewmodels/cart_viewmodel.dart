import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../data/models/cart_item.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CartItem> get items => List.unmodifiable(_items);

  double get total =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addItem(CartItem item) {
    final index = _items.indexWhere(
        (e) => e.storeId == item.storeId && e.productId == item.productId);
    if (index != -1) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void decreaseQuantity(String storeId, String productId) {
    final index = _items.indexWhere(
        (e) => e.storeId == storeId && e.productId == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Nueva función para enviar el pedido a Firebase
  Future<void> sendOrder(String customerId) async {
    if (_items.isEmpty) return;

    final orderId = Uuid().v4(); // ID único del pedido
    final orderRef = _firestore.collection('orders').doc(orderId);

    // Documento principal del pedido
    await orderRef.set({
      'id': orderId,
      'customerId': customerId,
      'restaurantId': _items.first.storeId,
      'deliveryId': null,
      'status': 'pending',
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Subcolección de items
    for (var item in _items) {
      final itemId = Uuid().v4();
      await orderRef.collection('items').doc(itemId).set({
        'id': itemId,
        'productId': item.productId,
        'name': item.productName,
        'quantity': item.quantity,
        'price': item.price,
        'subtotal': item.price * item.quantity,
      });
    }
  }
}

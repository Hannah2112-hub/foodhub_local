import 'package:flutter/material.dart';
import '../data/dummy_data.dart'; 

class ManagerViewModel extends ChangeNotifier {
  // Creamos una lista editable de productos
  final List<Map<String, dynamic>> items = [];

  ManagerViewModel() {
    // Cargamos todos los productos del dummy
    for (var store in dummyStores) {
      for (var p in store.products) {
        items.add({
          "productId": p.id,
          "productName": p.name,
          "restaurantName": store.name,
          "available": p.available,
        });
      }
    }
  }

  void toggleAvailability(int index, bool value) {
    items[index]["available"] = value;
    notifyListeners();
  }
}

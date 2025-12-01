import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  // Datos simulados / estáticos (usando tus restaurantes del dummy)
  List<Map<String, dynamic>> commissions = [
    {
      "restaurantName": "Pollería El Fuego",
      "percentage": 10,
      "amount": 2.0,
    },
    {
      "restaurantName": "Comidas Express",
      "percentage": 10,
      "amount": 1.5,
    },
    {
      "restaurantName": "La Pizza de Luigi",
      "percentage": 10,
      "amount": 2.5,
    },
    {
      "restaurantName": "Sushi House",
      "percentage": 10,
      "amount": 3.5,
    },
    {
      "restaurantName": "Tacos El Rey",
      "percentage": 10,
      "amount": 1.8,
    },
  ];

  void updatePercentage(int index, int newPercentage) {
    commissions[index]["percentage"] = newPercentage;
    notifyListeners();
  }
}

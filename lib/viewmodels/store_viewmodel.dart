import 'package:flutter/material.dart';
import '../data/models/store_model.dart';
import '../data/dummy_data.dart';

class StoreViewModel extends ChangeNotifier {
  List<StoreModel> _stores = [];
  List<StoreModel> _filteredStores = [];
  bool _isLoading = false;

  List<StoreModel> get stores => _stores;
  List<StoreModel> get filteredStores => _filteredStores;
  bool get isLoading => _isLoading;

  void fetchStores() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _stores = dummyStores;
      _filteredStores = _stores;
      _isLoading = false;
      notifyListeners();
    });
  }

  void filterByZone(String zone) {
    if (zone.isEmpty) {
      _filteredStores = _stores;
    } else {
      _filteredStores =
          _stores.where((s) => s.zone.toLowerCase() == zone.toLowerCase()).toList();
    }
    notifyListeners();
  }
}

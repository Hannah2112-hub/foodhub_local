import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/store_viewmodel.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<StoreViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(title: const Text('Locales'), backgroundColor: Colors.deepOrange),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filtrar por zona',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: vm.filterByZone,
            ),
          ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.filteredStores.length,
                    itemBuilder: (_, index) {
                      final store = vm.filteredStores[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: store.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    store.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.store, size: 40, color: Colors.deepOrange),
                          title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Entrega: ${store.deliveryTime} min | Precio promedio: \$${store.avgPrice.toStringAsFixed(2)}'),
                          onTap: () {
                            // Abrir productos del local
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

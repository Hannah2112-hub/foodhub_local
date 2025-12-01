import 'package:flutter/material.dart';
import 'package:foodhub_local/widgets/logout_button.dart';
import 'package:provider/provider.dart';
import 'package:foodhub_local/viewmodels/restaurant_viewmodel.dart';

class RestaurantOrdersScreen extends StatelessWidget {
  const RestaurantOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantVM = Provider.of<RestaurantViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Pedidos del restaurante"),
        backgroundColor: Colors.deepOrange,
        actions: const [LogoutButton()],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: restaurantVM.getAllOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return const Center(
              child: Text("No hay pedidos", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final status = order['status'];

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text("Pedido: ${order['id'] ?? 'sin ID'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total: S/. ${order['total']}"),
                      Text("Estado: $status"),
                    ],
                  ),
                  trailing: _buildActionButton(context, restaurantVM, order),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, RestaurantViewModel vm, Map order) {
    final status = order['status'];
    final id = order['id'];

    switch (status) {
      case 'pending':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: () => vm.acceptOrder(id),
          child: const Text("Aceptar"),
        );
      case 'accepted':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: () => vm.markPreparing(id),
          child: const Text("Preparando"),
        );
      case 'preparing':
        return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: () => vm.markReady(id),
          child: const Text("Listo p/ reparto"),
        );
      case 'on_the_way':
        return const Text("Repartidor en camino", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange));
      case 'delivered':
        return const Text("Entregado", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
      default:
        return const Text("Desconocido");
    }
  }
}

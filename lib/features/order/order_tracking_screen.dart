import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../viewmodels/delivery_viewmodel.dart';
import '../../data/models/delivery_persons.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final orderId = args['orderId'] as String;

    final orderVM = Provider.of<OrderViewModel>(context);
    final deliveryVM = Provider.of<DeliveryViewModel>(context, listen: false);

    return FutureBuilder<Map<String, dynamic>?>(
      future: orderVM.getOrder(orderId),
      builder: (context, orderSnapshot) {
        if (orderSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!orderSnapshot.hasData || orderSnapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text("No se encontró el pedido")),
          );
        }

        final order = orderSnapshot.data!;
        final deliveryId = order['deliveryId'] as String? ?? '';

        return FutureBuilder<DeliveryPerson?>(
          future: deliveryId.isNotEmpty ? deliveryVM.getDeliveryById(deliveryId) : Future.value(null),
          builder: (context, deliverySnapshot) {
            final delivery = deliverySnapshot.data;

            return Scaffold(
              backgroundColor: Colors.orange[50],
              appBar: AppBar(
                title: const Text("Tracking del pedido"),
                backgroundColor: Colors.deepOrange,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Estado: ${order['status']}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                            const SizedBox(height: 12),
                            Text("Repartidor: ${delivery?.name ?? 'Aún no asignado'}",
                                style: const TextStyle(fontSize: 18)),
                            Text("Teléfono: ${delivery?.phone ?? '-'}", style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (order['status'] == 'delivered')
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/review',
                              arguments: {
                                'orderId': orderId,
                                'restaurantId': order['restaurantId'],
                                'deliveryId': deliveryId,
                              },
                            );
                          },
                          child: const Text("Valorar pedido", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

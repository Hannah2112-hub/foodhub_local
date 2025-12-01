import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/order_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> orders = [];
  late OrderViewModel orderVM;

  @override
  void initState() {
    super.initState();
    orderVM = Provider.of<OrderViewModel>(context, listen: false);
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      orders = await orderVM.getUserOrders(userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar pedidos: $e")),
      );
      orders = [];
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
        backgroundColor: Colors.deepOrange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.receipt_long, size: 80, color: Colors.deepOrange),
                      SizedBox(height: 16),
                      Text(
                        "No has realizado pedidos aún",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text("Pedido: ${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Estado: ${order['status']}\nTotal: S/. ${order['total']}"),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/order_tracking',
                            arguments: {'orderId': order['id']},
                          );
                        },
                        trailing: order['status'] == 'delivered'
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/review',
                                    arguments: {
                                      'orderId': order['id'],
                                      'restaurantId': order['restaurantId'],
                                      'deliveryId': order['deliveryId'],
                                    },
                                  );
                                },
                                child: const Text("Valorar"),
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:foodhub_local/widgets/logout_button.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/delivery_viewmodel.dart';

class DeliveryHomeScreen extends StatefulWidget {
  final String deliveryId;
  const DeliveryHomeScreen({super.key, required this.deliveryId});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  late DeliveryViewModel deliveryVM;
  bool isLoading = true;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    deliveryVM = Provider.of<DeliveryViewModel>(context, listen: false);
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);

    final pending = await deliveryVM.getPendingOrders();
    final assigned = await deliveryVM.getAssignedOrders(widget.deliveryId);

    setState(() {
      orders = [...pending, ...assigned];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Pedidos para repartir"),
        backgroundColor: Colors.deepOrange,
        actions: const [LogoutButton()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.delivery_dining, size: 80, color: Colors.deepOrange),
                      SizedBox(height: 16),
                      Text(
                        "No hay pedidos asignados",
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
                    final status = order['status'] as String;
                    final isMine = order['deliveryId'] == widget.deliveryId;

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text("Pedido: ${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Cliente: ${order['customerId']}\nEstado: $status"),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isMine && status == 'pending')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  await deliveryVM.acceptOrder(order['id'], widget.deliveryId);
                                  fetchOrders();
                                },
                                child: const Text("Aceptar"),
                              ),
                            if (isMine && status == 'on_the_way')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  await deliveryVM.completeOrder(order['id']);
                                  fetchOrders();
                                },
                                child: const Text("Entregado"),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

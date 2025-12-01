import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../data/models/cart_item.dart';

class CartScreen extends StatelessWidget {
  final String userId;
  final String restaurantId;
  final List<CartItem>? cartItems;

  const CartScreen({
    super.key,
    required this.userId,
    required this.restaurantId,
    this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context);
    final orderVM = Provider.of<OrderViewModel>(context);

    final items = cartItems ?? cartVM.items;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Carrito"),
        backgroundColor: Colors.deepOrange,
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.deepOrange),
                  SizedBox(height: 16),
                  Text(
                    "Tu carrito está vacío",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("S/. ${item.price.toStringAsFixed(2)} x${item.quantity}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.deepOrange,
                          onPressed: () {
                            cartVM.decreaseQuantity(item.storeId, item.productId);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.deepOrange,
                          onPressed: () {
                            cartVM.addItem(item);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total: S/. ${items.fold(0.0, (sum, item) => sum + item.price * item.quantity).toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: items.isEmpty
                    ? null
                    : () async {
                        final orderId = await orderVM.createOrder(
                            userId: userId, restaurantId: restaurantId, cartVM: cartVM);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pedido confirmado")),
                        );

                        Navigator.pushNamed(
                          context,
                          '/order_tracking',
                          arguments: {'orderId': orderId},
                        );
                      },
                child: const Text(
                  "Confirmar pedido",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

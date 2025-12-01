import 'package:flutter/material.dart';
import 'package:foodhub_local/widgets/logout_button.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/store_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../data/models/cart_item.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController _zoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<StoreViewModel>(context, listen: false).fetchStores();
  });
  }

  @override
  Widget build(BuildContext context) {
    final storeVM = Provider.of<StoreViewModel>(context);
    final cartVM = Provider.of<CartViewModel>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Restaurantes'),
        actions: [
          LogoutButton(),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  if (cartVM.items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tu carrito está vacío")),
                    );
                    return;
                  }

                  final firstStore = cartVM.items.first.storeId;

                  Navigator.pushNamed(
                    context,
                    '/cart',
                    arguments: {
                      'userId': user?.uid,
                      'restaurantId': firstStore,
                    },
                  );
                },
              ),
              if (cartVM.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartVM.items.length.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: storeVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtrar por zona
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _zoneController,
                    decoration: InputDecoration(
                      labelText: 'Filtrar por zona',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          storeVM.filterByZone(_zoneController.text);
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => storeVM.filterByZone(value),
                  ),
                ),
                const SizedBox(height: 8),

                // Botón para ver pedidos realizados
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text("Mis Pedidos"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/my_orders'); // ✅ ruta correcta
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Lista de restaurantes
                Expanded(
                  child: ListView.builder(
                    itemCount: storeVM.filteredStores.length,
                    itemBuilder: (context, index) {
                      final store = storeVM.filteredStores[index];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          leading: store.imageUrl.isNotEmpty
                              ? Image.network(
                                  store.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.restaurant),
                          title: Text(store.name),
                          subtitle: Text(
                            'Zona: ${store.zone} | Tiempo: ${store.deliveryTime} min | Promedio: \$${store.avgPrice.toStringAsFixed(2)}',
                          ),
                          children: store.products.isEmpty
                              ? const [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('No hay productos disponibles'),
                                  )
                                ]
                              : store.products.map((product) {
                                  return ListTile(
                                    title: Text(product.name),
                                    subtitle: Text(
                                        '\$${product.price.toStringAsFixed(2)}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add_shopping_cart),
                                      onPressed: () {
                                        cartVM.addItem(
                                          CartItem(
                                            storeId: store.id,
                                            storeName: store.name,
                                            productId: product.id,
                                            productName: product.name,
                                            price: product.price,
                                            quantity: 1,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '${product.name} agregado al carrito'),
                                            duration:
                                                const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
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

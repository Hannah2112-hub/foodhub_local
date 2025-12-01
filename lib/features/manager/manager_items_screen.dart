import 'package:flutter/material.dart';
import 'package:foodhub_local/widgets/logout_button.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager_viewmodel.dart';

class ManagerItemsScreen extends StatelessWidget {
  const ManagerItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ManagerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Productos"),
        backgroundColor: Colors.deepOrange,
        actions: const [LogoutButton()],
      ),
      body: ListView.builder(
        itemCount: vm.items.length,
        itemBuilder: (context, index) {
          final item = vm.items[index];

          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(item["productName"]),
              subtitle: Text("Restaurante: ${item["restaurantName"]}"),
              trailing: Switch(
                value: item["available"],
                activeColor: Colors.deepOrange,
                onChanged: (v) {
                  vm.toggleAvailability(index, v);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

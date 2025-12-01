import 'package:flutter/material.dart';
import 'package:foodhub_local/widgets/logout_button.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin_viewmodel.dart';

class CommissionPanelScreen extends StatelessWidget {
  const CommissionPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminVM = Provider.of<AdminViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Panel de Comisiones"),
        backgroundColor: Colors.deepOrange,
        actions: const [LogoutButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Comisiones por Restaurante",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: adminVM.commissions.length,
                itemBuilder: (context, index) {
                  final item = adminVM.commissions[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(item["restaurantName"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "Comisión: ${item["percentage"]}% - Monto: S/.${item["amount"]}",
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _editPercentage(context, adminVM, index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Editar %"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editPercentage(
      BuildContext context, AdminViewModel vm, int index) {
    final controller = TextEditingController(
      text: vm.commissions[index]["percentage"].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Editar porcentaje"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: "Nuevo porcentaje (%)"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
            child: const Text("Guardar"),
            onPressed: () {
              final newValue = int.tryParse(controller.text);
              if (newValue != null && newValue > 0) {
                vm.updatePercentage(index, newValue);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String role = 'customer';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Logo con cubiertos
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepOrange[100],
                child: Icon(
                  Icons.local_dining,
                  size: 60,
                  color: Colors.deepOrange[800],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Registro FoodHubLocal",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Nombre', prefixIcon: Icon(Icons.person)),
                          onChanged: (v) => name = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Ingrese nombre' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Correo', prefixIcon: Icon(Icons.email)),
                          onChanged: (v) => email = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Ingrese correo' : null,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Contraseña', prefixIcon: Icon(Icons.lock)),
                          obscureText: true,
                          onChanged: (v) => password = v,
                          validator: (v) =>
                              v == null || v.length < 6 ? '6+ caracteres' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                          onChanged: (v) => phone = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Ingrese teléfono' : null,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: role,
                          items: const [
                            DropdownMenuItem(value: 'customer', child: Text('Cliente')),
                            DropdownMenuItem(
                                value: 'restaurant', child: Text('Restaurante')),
                            DropdownMenuItem(
                                value: 'delivery', child: Text('Repartidor')),
                            DropdownMenuItem(value: 'admin', child: Text('Admin')),
                            DropdownMenuItem(value: 'gestor', child: Text('Gestor')),
                          ],
                          onChanged: (v) => setState(() => role = v ?? 'customer'),
                          decoration: const InputDecoration(labelText: 'Rol'),
                        ),
                        const SizedBox(height: 16),
                        if (authVM.error != null)
                          Text(authVM.error!,
                              style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.deepOrange,
                            ),
                            onPressed: authVM.isLoading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate())
                                      return;

                                    await authVM.register(
                                        name: name,
                                        email: email,
                                        password: password,
                                        role: role,
                                        phone: phone);

                                    if (!mounted) return;
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                            child: authVM.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('Registrar', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            '¿Ya tienes cuenta? Inicia sesión',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

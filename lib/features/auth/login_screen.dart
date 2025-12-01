import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                "FoodHubLocal",
                style: TextStyle(
                  fontSize: 32,
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
                            labelText: 'Correo',
                            prefixIcon: Icon(Icons.email),
                          ),
                          onChanged: (v) => email = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Ingrese correo' : null,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          onChanged: (v) => password = v,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Ingrese contraseña'
                              : null,
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

                                    await authVM.login(
                                        email: email, password: password);

                                    final role = authVM.user?.role;
                                    if (role != null) {
                                      switch (role) {
                                        case 'restaurant':
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/restaurantOrders',
                                            arguments: {
                                              "restaurantId": "r1"
                                            },
                                          );
                                          break;
                                        case 'delivery':
                                          Navigator.pushReplacementNamed(
                                              context, '/home_delivery');
                                          break;
                                        case 'admin':
                                          Navigator.pushReplacementNamed(
                                              context, '/home_admin');
                                          break;
                                        case 'gestor':
                                          Navigator.pushReplacementNamed(
                                              context, '/home_gestor');
                                          break;
                                        default:
                                          Navigator.pushReplacementNamed(
                                              context, '/home_customer');
                                      }
                                    }
                                  },
                            child: authVM.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Ingresar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Text(
                            '¿No tienes cuenta? Regístrate',
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

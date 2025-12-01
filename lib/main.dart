import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodhub_local/features/manager/manager_items_screen.dart';
import 'package:foodhub_local/viewmodels/admin_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import 'core/services/auth_service.dart';

// ViewModels
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/store_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/order_viewmodel.dart';
import 'viewmodels/delivery_viewmodel.dart';
import 'viewmodels/review_viewmodel.dart';
import 'viewmodels/restaurant_viewmodel.dart';
import 'viewmodels/manager_viewmodel.dart';

// Screens
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/customer/customer_home_screen.dart';
import 'features/customer/customer_orders_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/order/order_tracking_screen.dart';
import 'features/review/review_screen.dart';
import 'features/delivery/delivery_home_screen.dart';
import 'features/restaurant_panel/restaurant_orders_screen.dart';
import 'features/admin/commission_panel_screen.dart';   // ⭐ NUEVO

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authService)),
        ChangeNotifierProvider(create: (_) => StoreViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => DeliveryViewModel()),
        ChangeNotifierProvider(create: (_) => ReviewViewModel()),
        ChangeNotifierProvider(create: (_) => RestaurantViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => ManagerViewModel())
      ],
      child: MaterialApp(
        title: 'FoodHubLocal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: const LoginScreen(),

        routes: {
          // Auth
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),

          // Customer
          '/home_customer': (_) => const CustomerHomeScreen(),
          '/my_orders': (_) => const CustomerOrdersScreen(),

          // Carrito
          '/cart': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            return CartScreen(
              userId: args['userId'],
              restaurantId: args['restaurantId'],
            );
          },

          // Tracking
          '/order_tracking': (_) => const OrderTrackingScreen(),

          // Reseñas
          '/review': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ReviewScreen(
              orderId: args['orderId'],
              restaurantId: args['restaurantId'],
              deliveryId: args['deliveryId'],
            );
          },

          // Delivery
          '/home_delivery': (_) =>
              const DeliveryHomeScreen(deliveryId: 'd1'),

          // Restaurante (SIEMPRE muestra todos los pedidos)
          '/home_restaurant': (_) => const RestaurantOrdersScreen(),
          '/restaurantOrders': (_) => const RestaurantOrdersScreen(),

          // Admin Home
          '/home_admin': (_) => const CommissionPanelScreen(),

          // Gestor
          '/home_gestor': (_) => const ManagerItemsScreen(),
        },
      ),
    );
  }
}

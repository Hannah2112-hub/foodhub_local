import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Future<void> main() async {
  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;
  final random = Random();

  // Zonas y rangos de precios aleatorios
  final zones = ['Centro', 'Norte', 'Sur', 'Este', 'Oeste'];
  final priceRanges = ['\$', '\$\$', '\$\$\$'];

  // Cantidad de restaurantes y productos por restaurante
  const numRestaurants = 10;
  const productsPerRestaurant = 5;

  for (int r = 1; r <= numRestaurants; r++) {
    final restId = 'rest$r';
    final restaurant = {
      'id': restId,
      'name': 'Restaurante $r',
      'address': 'Av. Aleatoria ${r * 10}',
      'zone': zones[random.nextInt(zones.length)],
      'imageUrl': '',
      'rating': (random.nextDouble() * 2) + 3, // 3.0 a 5.0
      'deliveryTime': 15 + random.nextInt(30), // 15 a 45 min
      'priceRange': priceRanges[random.nextInt(priceRanges.length)],
      'ownerId': 'user_rest$r',
    };

    await firestore.collection('restaurants').doc(restId).set({
      ...restaurant,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Crear productos
    for (int p = 1; p <= productsPerRestaurant; p++) {
      final prodId = 'prod${r}_$p';
      final product = {
        'id': prodId,
        'name': 'Producto $p',
        'price': (5 + random.nextInt(20)).toDouble(), // 5 a 25
        'imageUrl': '',
        'description': 'Descripción del producto $p',
        'available': true,
      };

      await firestore
          .collection('restaurants')
          .doc(restId)
          .collection('products')
          .doc(prodId)
          .set({
        ...product,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  print('🔥 Se crearon $numRestaurants restaurantes con productos aleatorios');
}

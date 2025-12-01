import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

   FirebaseMessaging? _messaging;

  // Inicializar notificaciones
  Future<void> initialize() async {
     _messaging = FirebaseMessaging.instance;
    
    // Pedir permisos
     await _requestPermission();
    
    // Obtener token
     String? token = await _messaging?.getToken();
     print('FCM Token: $token');
    
    print('Notification Service initialized (mock mode)');
  }

  // Solicitar permisos
  Future<void> _requestPermission() async {
     NotificationSettings settings = await _messaging!.requestPermission(
       alert: true,
       badge: true,
       sound: true,
     );
    
     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
       print('User granted permission');
     }
  }

  // Escuchar notificaciones en primer plano
  void listenToForegroundNotifications(Function(Map<String, dynamic>) onMessage) {
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       print('Notification received: ${message.notification?.title}');
       onMessage(message.data);
     });
  }

  // Enviar notificación local (simulada)
  void sendLocalNotification(String title, String body) {
    if (kDebugMode) {
      print('📬 Notification: $title - $body');
    }
  }
}
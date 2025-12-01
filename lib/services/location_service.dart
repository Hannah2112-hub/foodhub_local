import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Obtener ubicación actual
  Future<Map<String, double>> getCurrentLocation() async {
     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       throw Exception('Location services are disabled');
     }

     LocationPermission permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         throw Exception('Location permissions are denied');
       }
     }

     Position position = await Geolocator.getCurrentPosition();
    
    // Mock location (Huancayo, Perú)
    return {
      'latitude': -12.0653,
      'longitude': -75.2049,
    };
  }

  // Obtener dirección desde coordenadas
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
     List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
     Placemark place = placemarks[0];
     return '${place.street}, ${place.locality}, ${place.country}';
    
    // Mock address
    return 'Av. Ferrocarril 123, Huancayo, Perú';
  }

  // Calcular distancia entre dos puntos
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
     return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    
    // Mock distance (en metros)
    return 2500.0;
  }

  // Verificar permisos de ubicación
  Future<bool> checkLocationPermission() async {
     LocationPermission permission = await Geolocator.checkPermission();
     return permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
    
    return true; // Mock
  }

  // Solicitar permisos de ubicación
  Future<bool> requestLocationPermission() async {
     LocationPermission permission = await Geolocator.requestPermission();
     return permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
    
    return true; // Mock
  }

  // Stream de ubicación en tiempo real
   Stream<Position> getLocationStream() {
     return Geolocator.getPositionStream(
       locationSettings: const LocationSettings(
         accuracy: LocationAccuracy.high,
         distanceFilter: 10,
       ),
     );
   }
}

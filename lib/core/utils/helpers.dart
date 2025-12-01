import 'package:intl/intl.dart';

class Helpers {
  // Formatear fecha
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Formatear fecha con hora
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Formatear hora
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Formatear moneda
  static String formatCurrency(double amount) {
    return 'S/ ${amount.toStringAsFixed(2)}';
  }

  // Calcular porcentaje
  static double calculatePercentage(double value, double percentage) {
    return value * (percentage / 100);
  }

  // Tiempo transcurrido desde una fecha
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Ahora';
    }
  }

  // Validar número de teléfono peruano
  static bool isValidPeruvianPhone(String phone) {
    final phoneRegex = RegExp(r'^9\d{8}$');
    return phoneRegex.hasMatch(phone);
  }

  // Truncar texto
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Generar ID único
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
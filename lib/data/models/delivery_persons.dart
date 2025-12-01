class DeliveryPerson {
  final String id;
  final String name;
  final String phone;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DeliveryPerson.fromMap(Map<String, dynamic> map, String id) {
    return DeliveryPerson(
      id: id,
      name: map['name'] ?? 'Sin nombre',
      phone: map['phone'] ?? '',
    );
  }
}

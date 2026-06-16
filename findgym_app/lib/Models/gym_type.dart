class GymType {
  final String id;
  final String name;

  GymType({
    required this.id,
    required this.name,
  });

  factory GymType.fromDoc(doc) {
    final data = doc.data();

    return GymType(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}
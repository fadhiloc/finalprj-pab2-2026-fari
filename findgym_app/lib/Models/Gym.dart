class Gym {
  final String id;
  final String name;
  final String location;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> types;
  final List<String> imageUrls;
  final double rating;
  final int ratingCount;

  Gym({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.types,
    required this.imageUrls,
    required this.rating,
    required this.ratingCount,
  });
}
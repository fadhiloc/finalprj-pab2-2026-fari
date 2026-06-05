class Gym {
  final String name;
  final String location;
  final String description;
  final String built;
  final String type;
  final String? secondaryType;
  final List<String> imageUrls;
  final bool isFavorite;
  final Map<String, String> schedule;
  final String imageAsset;
  final double rating;
  final int ratingCount;


  Gym({
    required this.name,
    required this.location,
    required this.description,
    required this.built,
    required this.type,
    required this.imageUrls,
    this.secondaryType,
    this.isFavorite = false,
    this.rating = 0.0,
    this.ratingCount = 0,
    required this.schedule,
    required this.imageAsset,
    
  });
}

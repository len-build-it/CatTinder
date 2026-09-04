class CatProfile {
  final String id;
  final String name;
  final int age;
  final String breed;
  final String bio;
  final String imageUrl;
  final List<String> tags;
  final int distanceKm;

  const CatProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.breed,
    required this.bio,
    required this.imageUrl,
    required this.tags,
    this.distanceKm = 1,
  });

  CatProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? breed,
    String? bio,
    String? imageUrl,
    List<String>? tags,
    int? distanceKm,
  }) {
    return CatProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      breed: breed ?? this.breed,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}

// Character coming from the public Star Wars API (swapi.info).
// This api has no images and gives most values as strings.
class ApiCharacter {
  const ApiCharacter({
    required this.name,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.films,
    required this.starships,
    required this.vehicles,
    required this.url,
  });

  final String name;
  final String height; // cm
  final String mass; // kg
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final int films; // i only keep the counts, not the urls
  final int starships;
  final int vehicles;
  final String url;

  factory ApiCharacter.fromJson(Map<String, dynamic> json) {
    int count(String key) => (json[key] as List<dynamic>?)?.length ?? 0;
    return ApiCharacter(
      name: json['name'] ?? 'Unknown',
      height: json['height'] ?? 'unknown',
      mass: json['mass'] ?? 'unknown',
      hairColor: json['hair_color'] ?? 'unknown',
      skinColor: json['skin_color'] ?? 'unknown',
      eyeColor: json['eye_color'] ?? 'unknown',
      birthYear: json['birth_year'] ?? 'unknown',
      gender: json['gender'] ?? 'unknown',
      films: count('films'),
      starships: count('starships'),
      vehicles: count('vehicles'),
      url: json['url'] ?? '',
    );
  }
}

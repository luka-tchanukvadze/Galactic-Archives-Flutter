class SwCharacter {
  const SwCharacter({
    required this.name,
    required this.affiliation,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.homeworld,
    required this.midichlorians,
    required this.films,
    required this.tvSeries,
    required this.novels,
    required this.comics,
    required this.games,
    required this.description,
  });

  final String name;
  final String affiliation; // Jedi or Sith
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String homeworld;
  final String midichlorians;
  final List<String> films;
  final List<String> tvSeries;
  final List<String> novels;
  final List<String> comics;
  final List<String> games;
  final String description;
}

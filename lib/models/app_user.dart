class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.faction,
  });

  final String uid;
  final String email;
  final String name;
  final String faction; // jedi or sith

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'faction': faction,
    };
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      faction: map['faction'] ?? 'jedi',
    );
  }
}

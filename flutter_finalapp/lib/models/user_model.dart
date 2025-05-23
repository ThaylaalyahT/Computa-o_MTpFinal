class AppUser {
  final String uid;
  final String name;
  final String email;
  final String type;
  final List<String> disciplines;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.type,
    required this.disciplines,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'type': type,
      'disciplines': disciplines,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      type: map['type'] ?? '',
      disciplines: map['disciplines'] != null && map['disciplines'] is List
          ? List<String>.from(
          (map['disciplines'] as List).map((item) => item.toString()))
          : <String>[],
    );
  }

}

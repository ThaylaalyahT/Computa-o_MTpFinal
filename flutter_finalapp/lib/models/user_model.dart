class AppUser {
  final String uid;
  final String name;
  final String email;
  final String type; // 'aluno' ou 'professor'

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'type': type,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      type: map['type'],
    );
  }
}

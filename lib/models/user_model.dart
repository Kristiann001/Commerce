enum UserRole {
  admin,
  customer,
}

class UserModel {
  final String uid;
  final String email;
  final String name; // Added
  final UserRole role;

  UserModel({
    required this.uid,
    required this.email,
    required this.name, // Added
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Guest', // Added
      role: data['role'] == 'admin' ? UserRole.admin : UserRole.customer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name, // Added
      'role': role == UserRole.admin ? 'admin' : 'customer',
    };
  }
}

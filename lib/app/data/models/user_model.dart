// =========================
// بيانات المستخدم
// users/{uid}
// =========================
class UserModel {
  final String uid;
  final String name;
  final String email;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic>? data) {
    return UserModel(
      uid: uid,
      name: data?["name"] ?? "",
      email: data?["email"] ?? "",
    );
  }
}

class UserModel {
  final int id;
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final String role;
  final String province;
  final String imageUrl;

  UserModel(
      {required this.id,
      required this.email,
      required this.password,
      required this.fullName,
      required this.phoneNumber,
      required this.role,
      required this.province,
      required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'province': province,
      'imageUrl': imageUrl
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        email: map['email'],
        password: map['password'],
        fullName: map['fullName'],
        phoneNumber: map['phoneNumber'],
        role: map['role'],
        province: map['province'],
        imageUrl: map['imageUrl']);
  }
}

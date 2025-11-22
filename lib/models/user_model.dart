class User {
  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String username;
  final String password;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.username,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    address: json['address'],
    username: json['username'],
    password: json['password'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'username': username,
      'password': password,
    };
  }
}

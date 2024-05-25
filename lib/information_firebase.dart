// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String ho;
  String ten;
  String email;
  String username;
  String password;
  User({
    required this.ho,
    required this.ten,
    required this.email,
    required this.username,
    required this.password,

  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        ho: json["ho"],
        ten: json["ten"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "ho": ho,
        "ten": ten,
        "email": email,
        "username": username,
        "password": password,
      };
}

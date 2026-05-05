import 'user_model.dart';

class UserResponseModel {
  final int count;
  final List<UserModel> profiles;

  UserResponseModel({
    required this.count,
    required this.profiles,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      count: json['count'] ?? 0,
      profiles: (json['profiles'] as List)
          .map((e) => UserModel.fromJson(e))
          .toList(),
    );
  }
}
class UserModel {
  final int id;
  final String? userImage;
  final String? phone;
  final String? name;
  final String? email;
  final String? gender;
  final String? bio;
  final String createdAt;
  final int user;

  UserModel({
    required this.id,
    this.userImage,
    this.phone,
    this.name,
    this.email,
    this.gender,
    this.bio,
    required this.createdAt,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userImage: json['user_image'],
      phone: json['user_phone'],
      name: json['user_name'],
      email: json['user_email'],
      gender: json['user_gender'],
      bio: json['user_bio'],
      createdAt: json['created_at'],
      user: json['user'],
    );
  }
}
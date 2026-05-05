class ServiceModel {
  final int id;
  final bool isBooked;
  final String? serviceImage;
  final String? serviceAmount;
  final bool swipeStatus;
  final bool isFavorite;
  final String serviceName;
  final bool serviceStatus;
  final String? serviceDescription;
  final double? latitude;
  final double? longitude;

  final CategoryModel category;
  final SubCategoryModel subcategory;
  final UserProfileModel userProfile;

  ServiceModel({
    required this.id,
    required this.isBooked,
    required this.serviceImage,
    required this.serviceAmount,
    required this.swipeStatus,
    required this.isFavorite,
    required this.serviceName,
    required this.serviceStatus,
    required this.serviceDescription,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.subcategory,
    required this.userProfile,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["id"],
      isBooked: json["is_booked"] ?? false,
      serviceImage: json["service_image"],
      serviceAmount: json["service_amount"],
      swipeStatus: json["swipe_status"] ?? false,
      isFavorite: json["is_favorite"] ?? false,
      serviceName: json["service_name"] ?? "",
      serviceStatus: json["service_status"] ?? false,
      serviceDescription: json["service_description"],
      latitude: (json["latitude"] as num?)?.toDouble(),
      longitude: (json["longitude"] as num?)?.toDouble(),
      category: CategoryModel.fromJson(json["category"]),
      subcategory: SubCategoryModel.fromJson(json["subcategory"]),
      userProfile: UserProfileModel.fromJson(json["user_profile"]),
    );
  }
}

class CategoryModel {
  final int id;
  final String categoryName;
  final String? categoryImage;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      categoryName: json["category_name"] ?? "",
      categoryImage: json["category_image"],
    );
  }
}
class SubCategoryModel {
  final int id;
  final int category;
  final String subcategoryName;
  final String? subcategoryImage;
  final String categoryName;

  SubCategoryModel({
    required this.id,
    required this.category,
    required this.subcategoryName,
    required this.subcategoryImage,
    required this.categoryName,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json["id"],
      category: json["category"],
      subcategoryName: json["subcategory_name"] ?? "",
      subcategoryImage: json["subcategory_image"],
      categoryName: json["category_name"] ?? "",
    );
  }
}
class UserProfileModel {
  final int id;
  final String userPhone;
  final String? userName;
  final String? userEmail;
  final String? userImage;

  UserProfileModel({
    required this.id,
    required this.userPhone,
    required this.userName,
    required this.userEmail,
    required this.userImage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      userPhone: json["user_phone"] ?? "",
      userName: json["user_name"],
      userEmail: json["user_email"],
      userImage: json["user_image"],
    );
  }
}
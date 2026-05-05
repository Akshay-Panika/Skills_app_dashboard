class SubCategoryResponse {
  final String? category;
  final int count;
  final List<SubCategory> data;

  SubCategoryResponse({
    this.category,
    required this.count,
    required this.data,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      category: json['category'], // Agar nahi hoga to null aayega
      count: json['count'] ?? 0,
      data: (json['data'] as List).map((i) => SubCategory.fromJson(i)).toList(),
    );
  }
}

class SubCategory {
  final int id;
  final int category;
  final String subcategoryName;
  final String? subcategoryImage;
  final String categoryName;

  SubCategory({
    required this.id,
    required this.category,
    required this.subcategoryName,
    this.subcategoryImage,
    required this.categoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      category: json['category'],
      subcategoryName: json['subcategory_name'],
      subcategoryImage: json['subcategory_image'],
      categoryName: json['category_name'],
    );
  }
}
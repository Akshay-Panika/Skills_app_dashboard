import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../model/category_model.dart';

class CategoryRepository {

  // 🔹 GET
  static Future<CategoryResponseModel?> getCategory() async {
    try {
      final response = await ApiClient.dio.get('category/');

      if (response.statusCode == 200) {
        return CategoryResponseModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('GET Error: $e');
    }
    return null;
  }

  // 🔹 CREATE (WEB FIXED)
  static Future<CategoryModel?> createCategory({
    required String categoryName,
    List<int>? imageBytes,
    String? fileName,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "category_name": categoryName,
        if (imageBytes != null)
          "category_image": MultipartFile.fromBytes(
            imageBytes,
            filename: fileName ?? "image.png",
          ),
      });

      final response = await ApiClient.dio.post(
        'category/',
        data: formData,
      );

      if (response.statusCode == 201) {
        return CategoryModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('CREATE Error: $e');
    }
    return null;
  }

  // 🔹 UPDATE (WEB FIXED)
  static Future<CategoryModel?> updateCategory({
    required int id,
    required String categoryName,
    List<int>? imageBytes,
    String? fileName,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "category_name": categoryName,
        if (imageBytes != null)
          "category_image": MultipartFile.fromBytes(
            imageBytes,
            filename: fileName ?? "image.png",
          ),
      });

      final response = await ApiClient.dio.put(
        'category/$id/',
        data: formData,
      );

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('UPDATE Error: $e');
    }
    return null;
  }

  // 🔹 DELETE
  static Future<bool> deleteCategory(int id) async {
    try {
      final response = await ApiClient.dio.delete('category/$id/');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('DELETE Error: $e');
    }
    return false;
  }
}
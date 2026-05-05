// subcategory_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../model/subcategory_model.dart';

class SubCategoryRepository {

  // 🔹 GET ALL
  static Future<SubCategoryResponse?> getAllSubCategories() async {
    try {
      final response = await ApiClient.dio.get("subcategory/");
      if (response.statusCode == 200) {
        return SubCategoryResponse.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('GET ALL SubCategory Error: $e');
    }
    return null;
  }

  // 🔹 GET BY CATEGORY ID
  static Future<SubCategoryResponse?> getSubCategoriesByCategoryId(int categoryId) async {
    try {
      final response = await ApiClient.dio.get("subcategory/$categoryId/");
      if (response.statusCode == 200) {
        return SubCategoryResponse.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('GET SubCategory By ID Error: $e');
    }
    return null;
  }

  // 🔹 CREATE
  static Future<SubCategory?> createSubCategory({
    required int categoryId,
    required String name,
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "subcategory_name": name,
        if (imageBytes != null)
          "subcategory_image": MultipartFile.fromBytes(
            imageBytes,
            filename: imageFileName ?? "image.png",
          ),
      });

      final response = await ApiClient.dio.post(
        "subcategory/$categoryId/",
        data: formData,
      );

      if (response.statusCode == 201) {
        return SubCategory.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('CREATE SubCategory Error: $e');
    }
    return null;
  }

  // 🔹 UPDATE
  static Future<SubCategory?> updateSubCategory({
    required int categoryId,
    required int subCategoryId,
    required String name,
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "subcategory_name": name,
        if (imageBytes != null)
          "subcategory_image": MultipartFile.fromBytes(
            imageBytes,
            filename: imageFileName ?? "image.png",
          ),
      });

      final response = await ApiClient.dio.put(
        "subcategory/$categoryId/$subCategoryId/",
        data: formData,
      );

      if (response.statusCode == 200) {
        return SubCategory.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('UPDATE SubCategory Error: $e');
    }
    return null;
  }

  // 🔹 DELETE
  static Future<bool> deleteSubCategory(int categoryId, int subCategoryId) async {
    try {
      final response = await ApiClient.dio.delete(
        "subcategory/$categoryId/$subCategoryId/",
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('DELETE SubCategory Error: $e');
    }
    return false;
  }
}
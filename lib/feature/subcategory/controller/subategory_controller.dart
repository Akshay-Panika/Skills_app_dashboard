// subcategory_controller.dart
import 'dart:typed_data';
import 'package:get/get.dart';
import '../model/subcategory_model.dart';
import '../repository/subcategory_repository.dart';

class SubCategoryController extends GetxController {

  var subCategories = <SubCategory>[].obs;
  var categoryName = ''.obs;
  var count = 0.obs;
  var errorMessage = "".obs;

  // ✅ Separate loaders
  var isListLoading = false.obs;  // GET - grid loader
  var isFormLoading = false.obs;  // CREATE / UPDATE - form loader
  var deletingId = RxnInt();      // null = koi delete nahi ho raha

  bool get hasError => errorMessage.isNotEmpty;

  @override
  void onInit() {
    fetchAllSubCategories();
    super.onInit();
  }

  // 🔹 GET ALL
  Future<void> fetchAllSubCategories() async {
    try {
      isListLoading(true);
      errorMessage("");

      final response = await SubCategoryRepository.getAllSubCategories();

      if (response != null) {
        subCategories.value = response.data;
        categoryName.value = "All Subcategories";
        count.value = response.count;
      } else {
        errorMessage("No subcategories found");
      }
    } catch (e) {
      errorMessage("Failed to load subcategories");
    } finally {
      isListLoading(false);
    }
  }

  // 🔹 GET BY CATEGORY ID
  Future<void> fetchSubCategories(int categoryId) async {
    try {
      isListLoading(true);
      errorMessage("");

      final response = await SubCategoryRepository.getSubCategoriesByCategoryId(categoryId);

      if (response != null) {
        subCategories.value = response.data;
        categoryName.value = response.category ?? "Unknown";
        count.value = response.count;
      } else {
        errorMessage("No subcategories found");
      }
    } catch (e) {
      errorMessage("Failed to load subcategories");
    } finally {
      isListLoading(false);
    }
  }

  Future<void> refreshSubCategories() async => await fetchAllSubCategories();

  // 🔹 CREATE
  Future<bool> createSubItem({
    required int categoryId,
    required String name,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      isFormLoading(true);
      errorMessage("");

      final newItem = await SubCategoryRepository.createSubCategory(
        categoryId: categoryId,
        name: name,
        imageBytes: imageBytes,
        imageFileName: imageFileName,
      );

      if (newItem != null) {
        subCategories.insert(0, newItem);
        count.value++;
        return true;
      } else {
        errorMessage("Create failed");
        return false;
      }
    } catch (e) {
      errorMessage("Create error");
      return false;
    } finally {
      isFormLoading(false);
    }
  }

  // 🔹 UPDATE
  Future<bool> updateSubItem({
    required int categoryId,
    required int subCategoryId,
    required String name,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      isFormLoading(true);
      errorMessage("");

      final updated = await SubCategoryRepository.updateSubCategory(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        name: name,
        imageBytes: imageBytes,
        imageFileName: imageFileName,
      );

      if (updated != null) {
        final idx = subCategories.indexWhere((e) => e.id == subCategoryId);
        if (idx != -1) {
          subCategories[idx] = updated;
          subCategories.refresh();
        }
        return true;
      } else {
        errorMessage("Update failed");
        return false;
      }
    } catch (e) {
      errorMessage("Update error");
      return false;
    } finally {
      isFormLoading(false);
    }
  }

  // 🔹 DELETE
  Future<void> deleteSubItem(int categoryId, int subCategoryId) async {
    try {
      deletingId.value = subCategoryId; // ✅ sirf us ID ko mark karo
      errorMessage("");

      final success = await SubCategoryRepository.deleteSubCategory(
        categoryId,
        subCategoryId,
      );

      if (success) {
        subCategories.removeWhere((e) => e.id == subCategoryId);
        count.value--;
      } else {
        errorMessage("Delete failed");
      }
    } catch (e) {
      errorMessage("Delete error");
    } finally {
      deletingId.value = null; // ✅ reset
    }
  }
}
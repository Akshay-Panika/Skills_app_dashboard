import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class CategoryController extends GetxController {
  var categoryList = <CategoryModel>[].obs;

  // ✅ Separate loaders for each operation
  var isListLoading = false.obs;   // GET - grid loader
  var isFormLoading = false.obs;
  var deletingId = RxnInt(); // null = koi delete nahi ho raha

  var errorMessage = "".obs;

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  bool get hasError => errorMessage.isNotEmpty;

  Future<void> getCategories() async {
    try {
      isListLoading(true);
      errorMessage("");

      final response = await CategoryRepository.getCategory();

      if (response != null && response.data != null) {
        categoryList.value = response.data!;
      } else {
        errorMessage("No categories found");
      }
    } catch (e) {
      errorMessage("Failed to load categories");
    } finally {
      isListLoading(false);
    }
  }

  Future<void> refreshCategories() async => await getCategories();

  Future<void> createCategory({
    required String name,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    try {
      isFormLoading(true);

      final newCategory = await CategoryRepository.createCategory(
        categoryName: name,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      if (newCategory != null) {
        categoryList.insert(0, newCategory);
      } else {
        errorMessage("Create failed");
      }
    } finally {
      isFormLoading(false);
    }
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    try {
      isFormLoading(true);

      final updated = await CategoryRepository.updateCategory(
        id: id,
        categoryName: name,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      if (updated != null) {
        final index = categoryList.indexWhere((e) => e.id == id);
        if (index != -1) {
          categoryList[index] = updated;
          categoryList.refresh();
        }
      } else {
        errorMessage("Update failed");
      }
    } finally {
      isFormLoading(false);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      deletingId.value = id; // ✅ sirf us ID ko mark karo

      final success = await CategoryRepository.deleteCategory(id);

      if (success) {
        categoryList.removeWhere((e) => e.id == id);
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
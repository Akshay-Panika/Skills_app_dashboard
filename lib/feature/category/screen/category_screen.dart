import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_button.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';
import '../../../core/widget/app_dilog.dart';
import '../controller/category_controller.dart';
import '../model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _categoryController = Get.find<CategoryController>();
  final _categoryNameController = TextEditingController();
  final _searchController = TextEditingController();

  bool _isAdd = false;
  bool _isEdit = false;
  CategoryModel? _selectedCategory;

  Uint8List? _imageBytes;
  PlatformFile? _pickedFile;

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // ✅ Listen to search input
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        _imageBytes = result.files.first.bytes;
      });
    }
  }

  /// ✅ Filtered list based on search query
  List<CategoryModel> get _filteredList {
    if (_searchQuery.isEmpty) return _categoryController.categoryList;
    return _categoryController.categoryList
        .where((c) => (c.categoryName ?? "").toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        /// LEFT SIDE
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ✅ Search Box
                  _inputBox(context, "Search Category..."),

                  if (!_isAdd)
                    AppCard(
                      hasBorder: true,
                      height: context.sWidth * 0.03,
                      color: AppColor.surface,
                      margin: EdgeInsets.zero,
                      onTap: () {
                        setState(() {
                          _isAdd = true;
                          _isEdit = false;
                        });
                      },
                      child: Center(
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.add, color: AppColor.subtitle),
                            Text(
                              "Add",
                              style: GoogleFonts.poppins(
                                fontSize: context.text12,
                                color: AppColor.subtitle,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: context.sWidth * 0.02),

              /// CATEGORY LIST
              Expanded(
                child: Obx(() {
                  if (_categoryController.isListLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColor.primary),
                    );
                  }

                  if (_categoryController.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_categoryController.errorMessage.value),
                          ElevatedButton(
                            onPressed: _categoryController.refreshCategories,
                            child: const Text("Retry"),
                          )
                        ],
                      ),
                    );
                  }

                  /// ✅ Use filtered list
                  final list = _filteredList;

                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? "No Categories Found"
                            : "No results for \"$_searchQuery\"",
                        style: GoogleFonts.poppins(color: AppColor.subtitle),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _isAdd ? 5 : 7,
                      crossAxisSpacing: context.sWidth * 0.02,
                      mainAxisSpacing: context.sWidth * 0.02,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (_, index) {
                      final category = list[index];
                      return _skillCard(context, category: category);
                    },
                  );
                }),
              ),
            ],
          ),
        ),

        /// RIGHT PANEL (ADD / EDIT)
        if (_isAdd)
          Expanded(
            flex: 1,
            child: AppCard(
              hasBorder: true,
              margin: EdgeInsets.only(left: 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: context.sWidth * 0.01),

                      Text(
                        _isEdit ? "Edit Category" : "Add Category",
                        style: GoogleFonts.poppins(
                          fontSize: context.text10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: context.sWidth * 0.02),

                      /// IMAGE PICKER
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: AppCard(
                            width: double.infinity,
                            hasBorder: true,
                            color: AppColor.surface,
                            margin: EdgeInsets.zero,
                            child: _imageBytes != null
                            // ✅ Newly picked image
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                                : (_isEdit && _selectedCategory?.categoryImage != null)
                            // ✅ Edit mode - show existing network image
                                ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _selectedCategory!.categoryImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Tap to change",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            // ✅ Add mode - upload placeholder
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload, size: 30, color: AppColor.subtitle),
                                const SizedBox(height: 10),
                                Text(
                                  "Upload Image",
                                  style: GoogleFonts.poppins(color: AppColor.subtitle, fontSize: context.text10,fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: context.sWidth * 0.01),

                      _inputField(
                        context,
                        icon: Icons.edit_note,
                        hint: "Category Name",
                        controller: _categoryNameController,
                      ),

                      SizedBox(height: context.sWidth * 0.02),

                      /// SAVE / UPDATE BUTTON
                      Obx(() => AppButton(
                        isLoading: _categoryController.isFormLoading.value,
                        text: _isEdit ? "Update" : "Save",
                        onPressed: _categoryController.isFormLoading.value
                            ? null
                            : () {
                          if (_categoryNameController.text.trim().isEmpty) return;

                          if (_isEdit && _selectedCategory != null) {
                            _categoryController.updateCategory(
                              id: _selectedCategory!.id!,
                              name: _categoryNameController.text.trim(),
                              imageBytes: _imageBytes,
                              fileName: _pickedFile?.name,
                            ).then((_) => _resetForm());
                          } else {
                            _categoryController.createCategory(
                              name: _categoryNameController.text.trim(),
                              imageBytes: _imageBytes,
                              fileName: _pickedFile?.name,
                            ).then((_) => _resetForm());
                          }
                        },
                      )),

                    ],
                  ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.close),
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// RESET FORM
  void _resetForm() {
    _categoryNameController.clear();
    setState(() {
      _isAdd = false;
      _isEdit = false;
      _selectedCategory = null;
      _imageBytes = null;
      _pickedFile = null;
    });
  }

  /// ✅ SEARCH BOX - now uses _searchController
  Widget _inputBox(BuildContext context, String hint) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.primary.withOpacity(.1)),
    );

    return SizedBox(
      width: context.sWidth * 0.18,
      child: TextFormField(
        controller: _searchController,
        style: GoogleFonts.poppins(fontSize: context.text12, color: AppColor.subtitle),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: context.text12, color: AppColor.subtitle),
          prefixIcon: Icon(Icons.search, color: AppColor.subtitle,),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close, color: AppColor.subtitle, size: 16),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
            filled: true,
          fillColor: AppColor.surface,
        ),
      ),
    );
  }

  /// CATEGORY CARD
  Widget _skillCard(BuildContext context, {required CategoryModel category}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAdd = true;
          _isEdit = true;
          _selectedCategory = category;
          _categoryNameController.text = category.categoryName ?? "";
          _imageBytes = null;
          _pickedFile = null;
        });
      },
      child: Stack(
        children: [
          AppCard(
            margin: EdgeInsets.zero,
            width: double.infinity,
            hasBorder: true,
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Image.network(
                    category.categoryImage.toString(),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                Text(
                  category.categoryName ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: context.text10,
                  ),
                ),
              ],
            ),
          ),

          /// DELETE
          Positioned(
            right: 0,
            top: 0,
            child: Obx(() {
              final isDeleting = _categoryController.deletingId.value == category.id;
              return isDeleting
                  ? const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
                  : IconButton(
                onPressed: () async {
                  final confirm = await AppDialog.show(
                    context,
                    title: "Delete",
                    message: "Are you sure you want to delete this category?",
                    confirmText: "Yes",
                    cancelText: "No",
                  );

                  if (confirm) {
                    _categoryController.deleteCategory(category.id!);
                  }
                },
                icon: const Icon(Icons.delete,size: 18,),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// INPUT FIELD
Widget _inputField(
    BuildContext context, {
      TextEditingController? controller,
      required String hint,
      required IconData icon,
    }) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColor.primary.withOpacity(.1)),
  );

  return TextFormField(
    controller: controller,
    style: GoogleFonts.poppins(fontSize: context.text12),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: context.text12),
      prefixIcon: Icon(icon),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
    ),
  );
}
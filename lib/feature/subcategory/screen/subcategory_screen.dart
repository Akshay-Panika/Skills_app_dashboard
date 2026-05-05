import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_button.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';
import 'package:skill_daan_dashboard/core/widget/flutter_toast.dart';
import '../../../core/widget/app_dilog.dart';
import '../../category/controller/category_controller.dart';
import '../controller/subategory_controller.dart';
import '../model/subcategory_model.dart';

class SubcategoryScreen extends StatefulWidget {
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final _subcategoryController = Get.find<SubCategoryController>();
  final _categoryController = Get.find<CategoryController>();

  final _subcategoryNameController = TextEditingController();
  final _searchController = TextEditingController();

  bool _isAdd = false;
  bool _isEdit = false;
  SubCategory? _selectedSubCategory;
  int? _selectedCategoryId;

  Uint8List? _imageBytes;
  PlatformFile? _pickedFile;

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // _subcategoryController.fetchAllSubCategories();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _subcategoryNameController.dispose();
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

  List<SubCategory> get _filteredList {
    if (_searchQuery.isEmpty) return _subcategoryController.subCategories;
    return _subcategoryController.subCategories
        .where((s) => s.subcategoryName.toLowerCase().contains(_searchQuery))
        .toList();
  }

  Future<void> _onSave() async {
    final name = _subcategoryNameController.text.trim();

    if (name.isEmpty || _selectedCategoryId == null) {
      FlutterToast.error("Error, Please fill all fields");
      return;
    }

    if (_isEdit) {
      final success = await _subcategoryController.updateSubItem(
        categoryId: _selectedCategoryId!,
        subCategoryId: _selectedSubCategory!.id,
        name: name,
        imageBytes: _imageBytes,
        imageFileName: _pickedFile?.name,
      );

      if (success) {
        debugPrint("Success, Subcategory updated successfully");
        _resetForm();
      } else {
        debugPrint("Error, ${_subcategoryController.errorMessage.value}");
      }
    } else {
      if (_imageBytes == null) {
        FlutterToast.error("Image is required");
        return;
      }

      final success = await _subcategoryController.createSubItem(
        categoryId: _selectedCategoryId!,
        name: name,
        imageBytes: _imageBytes!,
        imageFileName: _pickedFile?.name,
      );

      if (success) {
        debugPrint("Success, Subcategory created successfully");
        _resetForm();
      } else {
        debugPrint("Error, ${ _subcategoryController.errorMessage.value}");
      }
    }
  }

  void _resetForm() {
    _subcategoryNameController.clear();
    setState(() {
      _isAdd = false;
      _isEdit = false;
      _selectedSubCategory = null;
      _selectedCategoryId = null;
      _imageBytes = null;
      _pickedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _inputBox(context, "Search Subcategories..."),
                  if (!_isAdd)
                    AppCard(
                      hasBorder: true,
                      height: context.sWidth * 0.03,
                      color: AppColor.surface,
                      margin: EdgeInsets.zero,
                      onTap: () => setState(() {
                        _isAdd = true;
                        _isEdit = false;
                      }),
                      child: Center(
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.add, color: AppColor.subtitle),
                            Text("Add",
                                style: GoogleFonts.poppins(
                                    fontSize: context.text12,
                                    color: AppColor.subtitle,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: context.sWidth * 0.02),

              /// SUBCATEGORY GRID
              Expanded(
                child: Obx(() {
                  if (_subcategoryController.isListLoading.value) {
                    return Center(
                        child: CircularProgressIndicator(color: AppColor.primary));
                  }

                  if (_subcategoryController.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade300, size: 40),
                          const SizedBox(height: 8),
                          Text(_subcategoryController.errorMessage.value,
                              style: GoogleFonts.poppins(color: AppColor.subtitle)),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: _subcategoryController.refreshSubCategories,
                            icon: const Icon(Icons.refresh),
                            label: Text("Retry", style: GoogleFonts.poppins()),
                          )
                        ],
                      ),
                    );
                  }

                  final list = _filteredList;

                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? "No Subcategories Found"
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
                    itemBuilder: (_, index) =>
                        _skillCard(context, subCategory: list[index]),
                  );
                }),
              ),
            ],
          ),
        ),
        if (_isAdd)
          Expanded(
            flex: 1,
            child: AppCard(
              hasBorder: true,
              margin: const EdgeInsets.only(left: 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: context.sWidth * 0.01),
                      Text(
                        _isEdit ? "Edit Subcategory" : "Add Subcategory",
                        style: GoogleFonts.poppins(
                            fontSize: context.text10,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: context.sWidth * 0.02),

                      Expanded(
                        child: AppCard(
                          width: double.infinity,
                          height: 150,
                          hasBorder: true,
                          color: AppColor.surface,
                          margin: EdgeInsets.zero,
                          onTap: _pickImage,
                          child: _imageBytes != null
                          // ✅ Nai pick ki hui image
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _imageBytes!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                              : (_isEdit && _selectedSubCategory?.subcategoryImage != null)
                          // ✅ Edit mode - existing network image + "Tap to change" overlay
                              ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  _selectedSubCategory!.subcategoryImage!,
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
                                style: GoogleFonts.poppins(
                                  color: AppColor.subtitle,
                                  fontSize: context.text10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: context.sWidth * 0.015),

                      _buildCategoryDropdown(),

                      SizedBox(height: context.sWidth * 0.01),

                      _inputField(
                        context,
                        icon: Icons.edit_note,
                        hint: "Subcategory Name",
                        controller: _subcategoryNameController,
                      ),

                      SizedBox(height: context.sWidth * 0.02),

                      /// ✅ isFormLoading - sirf button ka loader
                      Obx(() => AppButton(
                        isLoading:
                        _subcategoryController.isFormLoading.value,
                        text: _isEdit ? "Update" : "Save",
                        onPressed: _onSave,
                      )),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                        onPressed: _resetForm,
                        icon: const Icon(Icons.close)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: Text("Select Parent Category",
              style: GoogleFonts.poppins(fontSize: context.text12,fontWeight: FontWeight.w400,)),
          value: _selectedCategoryId,
          items: _categoryController.categoryList.map((cat) {
            return DropdownMenuItem(
                value: cat.id,
                child: Text(cat.categoryName ?? "",
                    style: GoogleFonts.poppins(fontSize: context.text12,fontWeight: FontWeight.w400,)
            ));
          }).toList(),
          onChanged: (val) => setState(() => _selectedCategoryId = val),
        ),
      )),
    );
  }

  Widget _inputBox(BuildContext context, String hint) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary.withOpacity(.1)));
    return SizedBox(
      width: context.sWidth * 0.18,
      child: TextFormField(
        controller: _searchController,
        style: GoogleFonts.poppins(
            fontSize: context.text12, color: AppColor.subtitle),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(Icons.search, color: AppColor.subtitle),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () => _searchController.clear())
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

  Widget _skillCard(BuildContext context, {required SubCategory subCategory}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAdd = true;
          _isEdit = true;
          _selectedSubCategory = subCategory;
          _subcategoryNameController.text = subCategory.subcategoryName;
          _selectedCategoryId = subCategory.category;
          // ✅ Edit open hone pe purani image clear karo
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
              spacing: 5,
              children: [
                Expanded(
                  child: Image.network(
                    subCategory.subcategoryImage ?? "",
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image),
                  ),
                ),
                Text(subCategory.subcategoryName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: context.text10)),
                Text(subCategory.categoryName,
                    style:
                    GoogleFonts.poppins(color: AppColor.subtitle, fontSize: context.text10)),
              ],
            ),
          ),

          /// ✅ deletingId se sirf us card pe spinner
          Positioned(
            right: 0,
            top: 0,
            child: Obx(() {
              final isDeleting =
                  _subcategoryController.deletingId.value == subCategory.id;
              return isDeleting
                  ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
                  : IconButton(
                onPressed: () async {
                  final confirm = await AppDialog.show(
                    context,
                    title: "Delete",
                    message: "Delete this subcategory?",
                    confirmText: "Yes",
                    cancelText: "No",
                  );

                  if (confirm) {
                    _subcategoryController.deleteSubItem(
                      subCategory.category,
                      subCategory.id,
                    );
                  }
                },
                icon: const Icon(Icons.delete, size: 18),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _inputField(BuildContext context,
      {TextEditingController? controller,
        required String hint,
        required IconData icon}) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary.withOpacity(.1)));
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(fontSize: context.text12),
      decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: border,
          enabledBorder: border,
          focusedBorder: border),
    );
  }
}
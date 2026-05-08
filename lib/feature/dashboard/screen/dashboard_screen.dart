import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';
import 'package:skill_daan_dashboard/feature/category/controller/category_controller.dart';
import 'package:skill_daan_dashboard/feature/skills/controller/service_controller.dart';
import 'package:skill_daan_dashboard/feature/users/model/user_model.dart';
import 'package:intl/intl.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../../users/controller/user_controller.dart';

class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});

  final _userController = Get.find<UserController>();
  final _categoryController = Get.find<CategoryController>();
  final _subcategoryController = Get.find<SubCategoryController>();
  final _serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Wrap(
          spacing: context.sWidth * 0.0,
          runSpacing: context.sWidth * 0.0,
          children: [
            Obx(() {
                return _statCard(context, "Total Users", "${ _userController.totalCount.value.toString()}", Icons.people);
              }
            ),
            Obx(() {
              return _statCard(context, "Active Users", "${ _userController.totalCount.value.toString()}", Icons.people);
            }
            ),
            Obx(() {
              return _statCard(context, "Categories", "${ _categoryController.categoryList.length}", Icons.category);
            }
            ),
            Obx(() {
              return _statCard(context, "Subcategories", "${ _subcategoryController.subCategories.length}", Icons.layers);
            }
            ),
            Obx(() {
              return _statCard(context, "Total Skills", "${ _serviceController.services.length}", Icons.star);
            }
            ),
            _statCard(context, "Share App", "______", Icons.share),
          ],
        ),

        SizedBox(height: context.sWidth * 0.0),


        Expanded(
          child: Row(
            children: [

              Expanded(
                flex: 2,
                child:   AppCard(
                  hasBorder: true,
                  padding: EdgeInsets.all(context.sWidth*0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, "New Users"),

                      SizedBox(height: context.sWidth * 0.01),

                      Expanded(
                        child: Obx(() {
                          if (_userController.isLoading.value) {
                            return Center(child: CircularProgressIndicator(color: AppColor.primary,));
                          }
                            return ListView.separated(
                              itemCount: _userController.userList.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: context.sWidth * 0.008),
                              itemBuilder: (_, index) {
                                final user =  _userController.userList[index];
                                return _userItem(context, user);
                                },
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔹 QUICK ACTIONS
              Expanded(
                child:   AppCard(
                  hasBorder: true,
                  padding: EdgeInsets.all(context.sWidth*0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, "Quick Actions"),

                      SizedBox(height: context.sWidth * 0.01),

                     Expanded(child: SingleChildScrollView(
                       child: Column(
                         children: [
                           _actionButton(context, "Add User", Icons.person_add),
                           _actionButton(context, "Add Category", Icons.category),
                           _actionButton(context, "Add Skill", Icons.star),
                           _actionButton(context, "View Reports", Icons.bar_chart),
                         ],
                       ),
                     ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 STAT CARD
  Widget _statCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      ) {
    return AppCard(
      hasBorder: true,
      width: context.sWidth * 0.18,
      // padding: EdgeInsets.all(context.sWidth * 0.015),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColor.primary),
          ),

          SizedBox(width: context.sWidth * 0.01),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: context.text10,
                  color: AppColor.subtitle,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: context.text14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 🔹 SECTION TITLE
  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: context.text14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 🔹 ACTIVITY ITEM
  Widget _userItem(BuildContext context, UserModel user) {
    return AppCard(
      padding: EdgeInsets.all(context.sWidth * 0.0),
      margin: EdgeInsets.zero,
      child: Row(
        children: [

          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: context.sWidth * 0.015,
            child: ClipOval(
              child: Image.network(
                user.userImage!,
                width: context.sWidth * 0.04,
                height: context.sWidth * 0.04,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (_, __, ___) {
                  return Icon(
                    Icons.person,
                    size: context.sWidth * 0.014,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: context.sWidth * 0.01),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name!,
                  style: GoogleFonts.poppins(
                    fontSize: context.text12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(user.phone!,
                  style: GoogleFonts.poppins(
                    fontSize: context.text12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.subtitle
                  ),
                ),
              ],
            ),
          ),

          Text(
            DateFormat('dd MMM yyyy').format(DateTime.parse(user.createdAt)),
            style: GoogleFonts.poppins(
              fontSize: context.text10,
              fontWeight: FontWeight.w500,
              color: AppColor.subtitle,
            ),
          )
        ],
      ),
    );
  }

  Widget _actionButton(
      BuildContext context,
      String title,
      IconData icon,
      ) {
    return AppCard(
      padding: EdgeInsets.only(bottom: context.sWidth * 0.008),
      child: Row(
        children: [
          Icon(icon, size: 18, color:  AppColor.primary),
          SizedBox(width: context.sWidth * 0.01),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: context.text12,
            ),
          ),
        ],
      ),
    );
  }
}

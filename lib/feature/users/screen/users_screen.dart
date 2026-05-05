import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';

import '../controller/user_controller.dart';
import '../model/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  final _userController = Get.find<UserController>();
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            _inputBox(context, "Search users..."),
          ],
        ),

        SizedBox(height: context.sWidth * 0.02),

        /// 🔥 API + REACTIVE UI
        Expanded(
          child: Obx(() {

            if (_userController.isLoading.value) {
              return Center(child: CircularProgressIndicator(color: AppColor.primary,));
            }

            /// 🔍 FILTER LOGIC
            final filteredUsers = _userController.userList.where((user) {
              final name = (user.name ?? "").toLowerCase();
              final email = (user.email ?? "").toLowerCase();
              final phone = (user.phone ?? "").toLowerCase();

              return name.contains(_searchQuery) ||
                  email.contains(_searchQuery) ||
                  phone.contains(_searchQuery);
            }).toList();

            if (filteredUsers.isEmpty) {
              return const Center(child: Text("No users found"));
            }

            return ListView.separated(
              itemCount: filteredUsers.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: context.sWidth * 0.01),
              itemBuilder: (_, index) {
                final user = filteredUsers[index];
                return _userCard(context, user);
              },
            );
          }),
        )
      ],
    );
  }

  /// 🔥 USER CARD WITH REAL DATA
  Widget _userCard(BuildContext context, UserModel user) {
    return AppCard(
      hasBorder: true,
      padding: EdgeInsets.all(context.sWidth * 0.012),
      margin: EdgeInsets.zero,
      child: Row(
        children: [

          CircleAvatar(
            radius: context.sWidth * 0.02,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: Image.network(
                user.userImage ?? "",
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
                    size: context.sWidth * 0.02,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: context.sWidth * 0.015),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? "No Name",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: context.text12,
                  ),
                ),
                SizedBox(height: 4),

                Text(
                  user.email ?? "No Email",
                  style: GoogleFonts.poppins(
                    fontSize: context.text10,
                    color: AppColor.subtitle,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  user.phone ?? "No Phone",
                  style: GoogleFonts.poppins(
                    fontSize: context.text10,
                    color: AppColor.subtitle,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  user.bio ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: context.text10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: View user
                },
                child: const Icon(
                  Icons.visibility,
                  size: 22,
                  color: Colors.grey,
                ),
              ),

              SizedBox(width: context.sWidth * 0.02),

              GestureDetector(
                onTap: () {
                  // TODO: Delete user
                },
                child: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
              ),

              SizedBox(width: context.sWidth * 0.01),
            ],
          )
        ],
      ),
    );
  }

  /// 🔍 SEARCH BOX
  Widget _inputBox(BuildContext context, String hint) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.primary.withOpacity(.1)),
    );

    return SizedBox(
      width: context.sWidth * 0.18,
      child: TextFormField(
        controller: _searchController,
        style: GoogleFonts.poppins(
          fontSize: context.text12,
          color: AppColor.subtitle,
        ),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(Icons.search, color: AppColor.subtitle),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = "";
                });
              })
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
}
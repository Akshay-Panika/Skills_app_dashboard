import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';
import 'package:skill_daan_dashboard/feature/dashboard/screen/dashboard_screen.dart';

import '../../category/screen/category_screen.dart';
import '../../skills/screen/skills_screen.dart';
import '../../subcategory/screen/subcategory_screen.dart';
import '../../users/screen/users_screen.dart';

class LandScreen extends StatefulWidget {
  const LandScreen({super.key});

  @override
  State<LandScreen> createState() => _LandScreenState();
}

class _LandScreenState extends State<LandScreen> {
  int selectedIndex = 0;
  final List<Map<String, dynamic>> menuItems = [
    {"icon": FontAwesomeIcons.tableColumns, "title": "Dashboard"},
    {"icon": FontAwesomeIcons.list, "title": "Categories"},
    {"icon": FontAwesomeIcons.list, "title": "Subcategories"},
    {"icon": FontAwesomeIcons.chalkboardUser, "title": "Skills"},
    {"icon": FontAwesomeIcons.users, "title": "Users"},
  ];

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return CategoryScreen();
      case 2:
        return SubcategoryScreen();
      case 3:
        return SkillsScreen();
      case 4:
        return UsersScreen();
      default:
        return DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.sWidth < 700;

    return Scaffold(
      backgroundColor: AppColor.surface,

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal:context.sWidth*0.03,vertical: context.sWidth*0.01),
            decoration: BoxDecoration(
              color: AppColor.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    FaIcon(FontAwesomeIcons.chalkboardTeacher, size: context.sWidth*0.016,color: AppColor.primary,),
                    Text("Skill Daan", style: GoogleFonts.poppins(fontSize: context.text14,fontWeight: FontWeight.w600,color: AppColor.primary),),
                  ],
                ),
                // IconButton(onPressed: () {
                //
                // }, icon: FaIcon(FontAwesomeIcons.solidBell,size: 16,color: AppColor.primary,))
              ],
            ),
          ),

          if(context.sWidth < 1000)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: context.sWidth*0.4,),
              Center(
                child: Text(
                  "Please use Desktop/Laptop",
                  style: GoogleFonts.poppins(
                    fontSize: context.text16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700
                  ),
                ),
              ),
            ],
          ),

          if(context.sWidth > 1000)
          Expanded(
            child: Row(
              children: [
                Container(
                  width: context.sWidth*0.12,
                  // padding: EdgeInsets.symmetric(horizontal: context.sWidth*0.02, vertical: context.sWidth*0.02),
                  decoration: BoxDecoration(
                    color: AppColor.white
                  ),

                  child:Column(
                    // spacing: context.sWidth * 0.016,
                    children: List.generate(menuItems.length, (index) {
                      final item = menuItems[index];

                      return _menuButton(
                        context,
                        icon: item["icon"],
                        title: item["title"],
                        isSelected: selectedIndex == index,
                        ontap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColor.white,
                    margin: EdgeInsets.all(context.sWidth*0.02),
                    padding: EdgeInsets.all(context.sWidth*0.02),
                    child: _getScreen(selectedIndex),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _menuButton(
    BuildContext context,
    {
      FaIconData? icon,
      String? title,
      VoidCallback? ontap,
      bool isSelected = false,
    }){
  return AppCard(
    onTap: ontap,
    margin: EdgeInsets.zero,
    borderRadius: 2,
    padding: EdgeInsets.symmetric(horizontal: context.sWidth*0.01,vertical:  context.sWidth*0.01),
    color: isSelected
        ? AppColor.primary.withOpacity(0.1)
        : AppColor.white,
    child: Row(
      spacing: context.sWidth*0.01,
      children: [
       FaIcon(icon, size: context.sWidth*0.008,),
       Text(title.toString(), style: GoogleFonts.poppins(fontSize: context.sWidth*0.008,fontWeight: FontWeight.w500),),
      ],
    ),
  );
}
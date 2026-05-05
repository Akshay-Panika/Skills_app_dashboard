import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      {
        "title": "Flutter Development",
        "category": "Tech",
        "type": "Mobile",
        "students": "120",
        "level": "Intermediate",
        "image": "https://cdn-icons-png.flaticon.com/512/5968/5968705.png"
      },
      {
        "title": "Graphic Design",
        "category": "Non-Tech",
        "type": "Creative",
        "students": "80",
        "level": "Beginner",
        "image": "https://cdn-icons-png.flaticon.com/512/1055/1055687.png"
      },
      {
        "title": "Digital Marketing",
        "category": "Non-Tech",
        "type": "Marketing",
        "students": "200",
        "level": "Advanced",
        "image": "https://cdn-icons-png.flaticon.com/512/4149/4149643.png"
      },
      {
        "title": "Python Programming",
        "category": "Tech",
        "type": "Backend",
        "students": "150",
        "level": "Intermediate",
        "image": "https://cdn-icons-png.flaticon.com/512/5968/5968350.png"
      },
      {
        "title": "Public Speaking",
        "category": "Non-Tech",
        "type": "Soft Skill",
        "students": "60",
        "level": "Beginner",
        "image": "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
      },
      {
        "title": "Web Development",
        "category": "Tech",
        "type": "Full Stack",
        "students": "220",
        "level": "Advanced",
        "image": "https://cdn-icons-png.flaticon.com/512/2721/2721297.png"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Filters (Same as UI image)
        Row(
          children: [
            _inputBox(context, "Search..."),
            _dropdown(context, "Category"),
            _dropdown(context, "Subcategory"),
            _dropdown(context, "All"), /// Free & Paid
          ],
        ),

        SizedBox(height: context.sWidth*0.02),

        /// 🔹 Grid
        Expanded(
          child: GridView.builder(
            itemCount: skills.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.sWidth > 1200 ? 3 : 2,
              crossAxisSpacing: context.sWidth*0.02,
              mainAxisSpacing: context.sWidth*0.02,
              childAspectRatio: 2.4,
            ),
            itemBuilder: (_, index) {
              final skill = skills[index];
              return _skillCard(context, skill);
            },
          ),
        )
      ],
    );
  }

  Widget _inputBox(BuildContext context, String hint) {
    return AppCard(
      width: context.sWidth * 0.18,
      color: AppColor.surface,
      padding: EdgeInsets.zero,
      child: TextField(
        style: GoogleFonts.poppins(fontSize: context.text12),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: context.text12),
          filled: true,
          fillColor: Colors.transparent,
         border: InputBorder.none
        ),
      ),
    );
  }

  Widget _dropdown(BuildContext context, String hint) {
    return AppCard(
      color: AppColor.surface,
      padding: EdgeInsets.symmetric(horizontal: context.sWidth*0.02),
      child: DropdownButton(
        underline: const SizedBox(),
        hint: Text(hint),
        style: GoogleFonts.poppins(fontSize: context.text12),
        items: const [],
        onChanged: (_) {},
      ),
    );
  }

  Widget _skillCard(BuildContext context, Map skill) {
    return AppCard(
      margin: EdgeInsets.zero,
      hasBorder: true,
      child: Row(
        spacing: context.sWidth*0.01,
        children: [
          Container(
            width: context.sWidth*0.1,
            color: Colors.grey.shade100,
            child: Image.network(skill["image"]),
          ),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),

                /// Title
                Text(
                  skill["title"],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: context.text12,
                  ),
                ),

                const SizedBox(height: 4),

                /// Type
                Text(
                  skill["type"],
                  style: GoogleFonts.poppins(color: AppColor.subtitle),
                ),

                const Spacer(),

                /// Info Row
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.userGroup, size: context.sWidth*0.008),
                    const SizedBox(width: 5),
                    Text(skill["students"]),
                    const SizedBox(width: 12),
                    FaIcon(FontAwesomeIcons.chalkboardTeacher, size: context.sWidth*0.008),
                    const SizedBox(width: 5),
                    Text(skill["level"]),
                  ],
                ),

                const SizedBox(height: 6),

                /// View More
                 Text(
                  "View More",
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontSize: context.text10,
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
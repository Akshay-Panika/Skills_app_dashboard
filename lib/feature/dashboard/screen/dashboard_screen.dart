import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {
        "name": "Akshay Sharma",
        "email": "akshay@gmail.com",
        "phone": "+91 9876543210",
        "bio": "Admin | Manages platform",
        "role": "Admin",
        "isVisible": true,
        "image": "https://randomuser.me/api/portraits/men/1.jpg"
      },
      {
        "name": "Rahul Verma",
        "email": "rahul@gmail.com",
        "phone": "+91 9123456780",
        "bio": "Active learner",
        "role": "User",
        "isVisible": true,
        "image": "https://randomuser.me/api/portraits/men/2.jpg"
      },
      {
        "name": "Priya Singh",
        "email": "priya@gmail.com",
        "phone": "+91 9988776655",
        "bio": "Teaches UI/UX",
        "role": "Instructor",
        "isVisible": true,
        "image": "https://randomuser.me/api/portraits/women/3.jpg"
      },
      {
        "name": "Amit Patel",
        "email": "amit@gmail.com",
        "phone": "+91 9012345678",
        "bio": "Backend enthusiast",
        "role": "User",
        "isVisible": true,
        "image": "https://randomuser.me/api/portraits/men/4.jpg"
      },
      {
        "name": "Neha Gupta",
        "email": "neha@gmail.com",
        "phone": "+91 9090909090",
        "bio": "Flutter Instructor",
        "role": "Instructor",
        "isVisible": true,
        "image": "https://randomuser.me/api/portraits/women/5.jpg"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Wrap(
          spacing: context.sWidth * 0.0,
          runSpacing: context.sWidth * 0.0,
          children: [
            _statCard(context, "Total Users", "1,245", Icons.people),
            _statCard(context, "Active Users", "980", Icons.person),
            _statCard(context, "Categories", "12", Icons.category),
            _statCard(context, "Subcategories", "36", Icons.layers),
            _statCard(context, "Total Skills", "128", Icons.star),
            _statCard(context, "Revenue", "₹52,340", Icons.currency_rupee),
          ],
        ),

        SizedBox(height: context.sWidth * 0.0),

        /// 🔥 LOWER SECTION
        Expanded(
          child: Row(
            children: [

              Expanded(
                flex: 2,
                child:   AppCard(
                  hasBorder: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, "New Users"),

                      SizedBox(height: context.sWidth * 0.01),

                      Expanded(
                        child: ListView.separated(
                          itemCount: users.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: context.sWidth * 0.008),
                          itemBuilder: (_, index) {
                            return _userItem(context, users[index]);                          },
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
  Widget _userItem(BuildContext context, Map user) {
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
                user["image"],
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
                Text(
                  user["name"],
                  style: GoogleFonts.poppins(
                    fontSize: context.text12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user["email"],
                  style: GoogleFonts.poppins(
                    fontSize: context.text10,
                    color: AppColor.subtitle,
                  ),
                ),
              ],
            ),
          ),

          Text('Time',style: GoogleFonts.poppins(fontSize: context.text10,fontWeight: FontWeight.w500,color: AppColor.subtitle),)
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

/// 🔥 MOCK DATA
final activities = [
  "New user registered",
  "Course purchased",
  "Instructor added a new skill",
  "Payment received",
  "Category added",
  "User updated profile",
];
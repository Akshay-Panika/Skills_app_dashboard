import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

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

        Expanded(
          child: ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: context.sWidth * 0.01),
            itemBuilder: (_, index) {
              final user = users[index];
              return _userCard(context, user, index);
            },
          ),
        )
      ],
    );
  }

  /// 🔥 USER CARD (UPDATED)
  Widget _userCard(BuildContext context, Map user, int index) {
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
                    size: context.sWidth * 0.02,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: context.sWidth * 0.015),

          Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user["name"],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: context.text12,
                  ),
                ),
                SizedBox(height: 4),

                Text(
                  user["email"],
                  style: GoogleFonts.poppins(
                    fontSize: context.text10,
                    color: AppColor.subtitle,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  user["phone"],
                  style: GoogleFonts.poppins(
                    fontSize: context.text10,
                    color: AppColor.subtitle,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  user["bio"],
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
                  setState(() {
                    users[index]["isVisible"] = !(users[index]["isVisible"] as bool);
                  });
                },
                child: Icon(
                  user["isVisible"]
                      ? Icons.visibility
                      : Icons.visibility_off,
                  size: 22,
                  color: user["isVisible"]
                      ? Colors.green
                      : Colors.grey,
                ),
              ),

              SizedBox(width: context.sWidth * 0.02),

              _iconButton(Icons.delete, color: Colors.red),
              SizedBox(width: context.sWidth * 0.01),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        icon,
        size: 20,
        color: color ?? Colors.grey,
      ),
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
          border: InputBorder.none,
        ),
      ),
    );
  }
}
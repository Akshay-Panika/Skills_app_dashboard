import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'feature/dashboard/screen/land_screen.dart';
import 'feature/subcategory/binding/subcategory_binding.dart';
import 'firebase_options.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Skill Daan',
      debugShowCheckedModeBanner: false,
      initialBinding: SubCategoryBinding(),
      home: LandScreen(),
    );
  }
}
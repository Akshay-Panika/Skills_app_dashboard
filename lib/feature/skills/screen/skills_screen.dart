import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_daan_dashboard/core/constant/app_color.dart';
import 'package:skill_daan_dashboard/core/constant/app_size.dart';
import 'package:skill_daan_dashboard/core/widget/app_card.dart';
import '../controller/service_controller.dart';
import '../model/service_model.dart';

class SkillsScreen extends StatefulWidget {
   SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final _serviceController = Get.find<ServiceController>();
   final _searchController = TextEditingController();
   String _searchQuery = "";

   String selectedType = "All";
   final List<String> types = ["All", "Free", "Paid"];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  /// 🔥 FILTER LOGIC
  List<ServiceModel> get _filteredServices {
    final all = _serviceController.services;

    return all.where((service) {
      final nameMatch =
      service.serviceName.toLowerCase().contains(_searchQuery);

      final typeMatch = _filterType(service);

      return nameMatch && typeMatch;
    }).toList();
  }

  bool _filterType(ServiceModel service) {
    if (selectedType == "All") return true;

    if (selectedType == "Free") {
      return service.serviceAmount == null ||
          service.serviceAmount == "0";
    }

    if (selectedType == "Paid") {
      return service.serviceAmount != null &&
          service.serviceAmount != "0";
    }

    return true;
  }

   @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Filters (Same as UI image)
        Row(
          children: [
            _inputBox(context, "Search Service..."),
            SizedBox(width: context.sWidth * 0.01),

            appDropdown<String>(
              context: context,
              width: 130,
              items: types,
              value: selectedType,
              label: (e) => e,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedType = val;
                  });
                }
              },
            )
          ],
        ),

        SizedBox(height: context.sWidth*0.02),

        /// 🔹 Grid
        Expanded(
          child: Obx(() {
            if (_serviceController.isLoading.value) {
              return Center(child: CircularProgressIndicator(color: AppColor.primary,));
            }

            if (_filteredServices.isEmpty) {
              return const Center(child: Text("No services found"));
            }
              return GridView.builder(
                itemCount: _filteredServices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.sWidth > 1200 ? 3 : 2,
                  crossAxisSpacing: context.sWidth*0.02,
                  mainAxisSpacing: context.sWidth*0.02,
                  childAspectRatio: 2.4,
                ),
                itemBuilder: (_, index) {
                  final service = _filteredServices[index];
                  return _skillCard(context, service);
                },
              );
            }
          ),
        )
      ],
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

  Widget appDropdown<T>({
    required BuildContext context,
    required List<T> items,
    required T value,
    required String Function(T) label,
    required Function(T?) onChanged,
    double? width,
    Color? color,
  }) {
    return AppCard(
      width: width,
      hasBorder: true,
      color: color ?? AppColor.surface,
      padding:
      EdgeInsets.symmetric(horizontal: context.sWidth * 0.02),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        elevation: 2,
        menuMaxHeight: 200,
        items: items.map((e) {
          return DropdownMenuItem<T>(
            value: e,
            child: Text(label(e)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _skillCard(BuildContext context, ServiceModel service) {
    return AppCard(
      margin: EdgeInsets.zero,
      hasBorder: true,
      child: Row(
        spacing: context.sWidth*0.01,
        children: [
          Container(
            width: context.sWidth*0.1,
            color: Colors.grey.shade100,
            child: Image.network(service.serviceImage!),
          ),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),

                /// Title
                Text(service.serviceName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: context.text12,
                  ),
                ),
                Text(service.serviceDescription!,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: context.text12,
                    color: AppColor.subtitle
                  ),
                ),

                const SizedBox(height: 4),

                /// Type
                Text(
                  (service.serviceAmount == null ||
                      service.serviceAmount == "0")
                      ? "Free"
                      : "₹ ${service.serviceAmount}",
                  style: GoogleFonts.poppins(
                      color: AppColor.success),
                ),

                const Spacer(),

                /// Info Row
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.userGroup, size: context.sWidth*0.008),
                    const SizedBox(width: 5),
                    Text("________"),
                    const SizedBox(width: 12),
                    FaIcon(FontAwesomeIcons.chalkboardTeacher, size: context.sWidth*0.008),
                    const SizedBox(width: 5),
                    Text("________"),
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
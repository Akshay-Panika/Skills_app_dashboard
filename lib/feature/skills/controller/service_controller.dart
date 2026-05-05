import 'package:get/get.dart';
import '../model/service_model.dart';
import '../repository/service_repository.dart';

class ServiceController extends GetxController {
  final ServiceRepository _repo = ServiceRepository();

  var services = <ServiceModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getServices();
    super.onInit();
  }

  Future<void> getServices() async {
    try {
      isLoading(true);

      final result = await _repo.getServices();

      services.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
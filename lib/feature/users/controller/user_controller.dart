import 'package:get/get.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';

class UserController extends GetxController {
  final repo = UserRepository();

  var isLoading = false.obs;
  var userList = <UserModel>[].obs;
  var totalCount = 0.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      final response = await repo.getUsers();

      userList.assignAll(response.profiles);
      totalCount.value = response.count;

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
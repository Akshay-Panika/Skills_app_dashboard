import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../model/user_model.dart';

class UserRepository {

  Future<UserResponseModel> getUsers() async {
    try {
      final Response response =
      await ApiClient.dio.get("profiles/");

      return UserResponseModel.fromJson(response.data);

    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Something went wrong");
    }
  }
}
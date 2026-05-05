import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/service_model.dart';

class ServiceRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await _dio.get("service/list/");

      final List data = response.data["services"];

      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to load services: $e");
    }
  }
}
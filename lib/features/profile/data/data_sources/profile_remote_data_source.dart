import 'package:dio/dio.dart';
import 'package:wasel/core/error/failure.dart';
import 'package:wasel/core/services/api_service.dart';
import 'package:wasel/core/utils/endpoint.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';

class ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSource({required this.apiService});

  Future<AuthModel> getProfile() async {
    try {
      final response = await apiService.get(endPoint: Endpoint.getProfile);
      return AuthModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}

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

  Future<AuthModel> updateProfile({required Map<String, dynamic> data}) async {
    try {
      final response = await apiService.patch(
        endPoint: Endpoint.updateProfile,
        data: data,
      );
      return AuthModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<AuthModel> updateProfileImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await apiService.patch(
        endPoint: Endpoint.profileImage,
        data: formData,
        isMultipart: true,
      );
      return AuthModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}

import 'package:dio/dio.dart';
import 'package:wasel/core/error/failure.dart';
import 'package:wasel/core/services/api_service.dart';
import 'package:wasel/core/utils/endpoint.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/auth/data/models/request_otp_response_model.dart';

class AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSource({required this.apiService});

  Future<RequestOtpResponseModel> requestEmailOtp({
    required String email,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: Endpoint.requestEmailOtp,
        data: {'email': email},
      );
      return RequestOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<AuthModel> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: Endpoint.verifyEmail,
        data: {'email': email, 'code': code},
      );
      return AuthModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<RequestOtpResponseModel> requestPhoneOtp({
    required String phone,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: Endpoint.requestPhoneOtp,
        data: {'phone': phone},
      );
      return RequestOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<AuthModel> verifyPhone({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: Endpoint.verifyPhone,
        data: {'phone': phone, 'code': code},
      );
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
}

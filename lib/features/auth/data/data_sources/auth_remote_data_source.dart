import 'package:wasel/core/services/api_service.dart';

class AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSource({required this.apiService});

  // Future<AuthModel> login({required String mobile, String? fcmToken}) async {
  //   try {
  //     final response = await apiService.post(
  //       endPoint: Endpoint.loginEndpoint,
  //       data: {'mobile': mobile, if (fcmToken != null) 'fcm_token': fcmToken},
  //     );
  //     return AuthModel.fromJson(response);
  //   } on DioException catch (e) {
  //     throw ServerFailure.fromDioError(e);
  //   } catch (e) {
  //     throw ServerFailure(message: e.toString());
  //   }
  // }

  // Future<String> logout() async {
  //   try {
  //     final response = await apiService.post(
  //       endPoint: Endpoint.logoutEndpoint,
  //       data: null,
  //     );
  //     return response['message'];
  //   } on DioException catch (e) {
  //     throw ServerFailure.fromDioError(e);
  //   } catch (e) {
  //     throw ServerFailure(message: e.toString());
  //   }
  // }

  // Future<String> deleteAccount() async {
  //   try {
  //     final response = await apiService.delete(
  //       endPoint: Endpoint.accountEndpoint,
  //     );
  //     return response['message'];
  //   } on DioException catch (e) {
  //     throw ServerFailure.fromDioError(e);
  //   } catch (e) {
  //     throw ServerFailure(message: e.toString());
  //   }
  // }
}

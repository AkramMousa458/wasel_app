import 'package:wasel/features/auth/data/data_sources/auth_remote_data_source.dart';

class AuthRepoImpl {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepoImpl(this.remoteDataSource);

  // Future<Either<ApiFailure, AuthModel>> login({
  //   required String mobile,
  //   String? fcmToken,
  // }) async {
  //   try {
  //     final result = await remoteDataSource.login(
  //       mobile: mobile,
  //       fcmToken: fcmToken,
  //     );
  //     return Right(result);
  //   } catch (e) {
  //     if (e is ServerFailure) {
  //       return Left(e);
  //     }
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }

  // Future<Either<ApiFailure, String>> logout() async {
  //   try {
  //     final result = await remoteDataSource.logout();
  //     return Right(result);
  //   } catch (e) {
  //     if (e is ServerFailure) {
  //       return Left(e);
  //     }
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }

  // Future<Either<ApiFailure, String>> deleteAccount() async {
  //   try {
  //     final result = await remoteDataSource.deleteAccount();
  //     return Right(result);
  //   } catch (e) {
  //     if (e is ServerFailure) {
  //       return Left(e);
  //     }
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }
}

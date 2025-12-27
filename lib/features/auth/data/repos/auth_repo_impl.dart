import 'package:dartz/dartz.dart';
import 'package:wasel/core/error/failure.dart';
import 'package:wasel/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/auth/data/models/request_otp_response_model.dart';

class AuthRepoImpl {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepoImpl(this.remoteDataSource);

  Future<Either<ApiFailure, RequestOtpResponseModel>> requestPhoneOtp({
    required String phone,
  }) async {
    try {
      final result = await remoteDataSource.requestPhoneOtp(phone: phone);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<ApiFailure, AuthModel>> verifyPhone({
    required String phone,
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifyPhone(
        phone: phone,
        code: code,
      );
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

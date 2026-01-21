import 'package:dartz/dartz.dart';
import 'package:wasel/core/error/failure.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/data/data_sources/profile_remote_data_source.dart';

class ProfileRepoImpl {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepoImpl({required this.remoteDataSource});

  Future<Either<ApiFailure, UserModel>> getProfile() async {
    try {
      final authModel = await remoteDataSource.getProfile();
      if (authModel.user != null) {
        return Right(authModel.user!);
      } else {
        return Left(ServerFailure(message: 'User data not found'));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<ApiFailure, AuthModel>> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final result = await remoteDataSource.updateProfile(data: data);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<ApiFailure, AuthModel>> updateProfileImage(
    String imagePath,
  ) async {
    try {
      final result = await remoteDataSource.updateProfileImage(imagePath);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<ApiFailure, AuthModel>> deleteProfileImage() async {
    try {
      final result = await remoteDataSource.deleteProfileImage();
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

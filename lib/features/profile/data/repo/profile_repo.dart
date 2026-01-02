import 'package:dartz/dartz.dart';
import 'package:wasel/core/error/failure.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';

abstract class ProfileRepo {
  Future<Either<ApiFailure, UserModel>> getProfile();
}

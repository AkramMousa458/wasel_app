import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:wasel/core/utils/app_string.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/services/api_service.dart';
import 'package:wasel/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:wasel/features/auth/data/repos/auth_repo_impl.dart';

import 'package:wasel/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:wasel/features/profile/data/repo/profile_repo_impl.dart';
// unused import removed

final locator = GetIt.instance;

Future<void> setupLocator({Logger? logger}) async {
  // Register logger first
  locator.registerSingleton<Logger>(
    logger ??
        Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 80,
            colors: true,
            printEmojis: true,
          ),
        ),
  );

  // Register Dio with interceptors
  final dio = Dio()
    ..interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
        logPrint: (object) => locator<Logger>().d(object),
      ),
    );

  locator.registerSingleton<Dio>(dio);

  // Register ApiService
  locator.registerSingleton<ApiService>(
    ApiService(
      locator<Dio>(),
      logger: locator<Logger>(),
      baseUrl: AppString.baseUrl,
    ),
  );

  // Register LocalStorage
  locator.registerSingleton<LocalStorage>(
    await LocalStorage.init(logger: locator<Logger>()),
  );

  // Auth Dependencies
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiService: locator<ApiService>()),
  );

  locator.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(locator<AuthRemoteDataSource>()),
  );

  // Profile Dependencies
  locator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(apiService: locator<ApiService>()),
  );

  locator.registerLazySingleton<ProfileRepoImpl>(
    () => ProfileRepoImpl(remoteDataSource: locator<ProfileRemoteDataSource>()),
  );
  // ProfileCubitFactory removed
}

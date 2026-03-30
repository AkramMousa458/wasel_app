import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/app/presentation/manager/app_state.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/auth/data/repos/auth_repo_impl.dart';
import 'package:wasel/features/profile/data/repo/profile_repo_impl.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  Future<void> checkAuth() async {
    emit(AppInitial());
    final localStorage = locator<LocalStorage>();
    final storedRefreshToken = localStorage.refreshToken;
    final storedAccessToken = localStorage.authToken;

    final hasRefreshToken =
        storedRefreshToken != null && storedRefreshToken.isNotEmpty;
    final hasAccessToken =
        storedAccessToken != null && storedAccessToken.isNotEmpty;

    if (!hasRefreshToken && !hasAccessToken) {
      log('AppCubit: No tokens found. Unauthenticated.');
      emit(AppUnauthenticated());
      return;
    }

    if (hasRefreshToken) {
      final refreshResult = await locator<AuthRepoImpl>().refreshAccessToken(
        refreshToken: storedRefreshToken!,
      );
      await refreshResult.fold(
        (failure) async {
          log('AppCubit: Token refresh failed — ${failure.message}. Logging out.');
          await localStorage.logout();
          emit(AppUnauthenticated());
        },
        (authModel) async {
          if (authModel.accessToken != null) {
            await localStorage.saveAuthToken(authModel.accessToken!);
          }
          if (authModel.refreshToken != null) {
            await localStorage.saveRefreshToken(authModel.refreshToken!);
          }
          log('AppCubit: Token refreshed successfully.');
        },
      );
      if (state is AppUnauthenticated) return;
    }

    final result = await locator<ProfileRepoImpl>().getProfile();

    result.fold(
      (failure) {
        log('AppCubit: API failed, falling back to local. ${failure.message}');
        _emitStateFromUser(localStorage.getUserProfile());
      },
      (freshUser) async {
        log('AppCubit: Got fresh user from API.');
        await localStorage.saveUserProfile(freshUser);
        _emitStateFromUser(freshUser);
      },
    );
  }

  void _emitStateFromUser(UserModel? user) {
    if (user == null) {
      emit(AppIncompleteProfile());
      return;
    }
    if (user.isBanned ?? false) {
      emit(AppUserBanned());
    } else if (user.isDeleted ?? false) {
      emit(AppUserDeleted());
    } else if (user.name != null &&
        (user.name!.en.isNotEmpty || user.name!.ar.isNotEmpty)) {
      emit(AppAuthenticated());
    } else {
      emit(AppIncompleteProfile());
    }
  }

  Future<void> logout() async {
    final localStorage = locator<LocalStorage>();
    await localStorage.logout();
    emit(AppLogout());
  }
}

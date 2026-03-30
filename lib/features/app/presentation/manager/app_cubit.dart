import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/app/presentation/manager/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  void checkAuth() {
    emit(
      AppInitial(),
    ); // Reset state to ensure listener catches the next emission
    final localStorage = locator<LocalStorage>();
    final token = localStorage.authToken;
    log('token: $token');

    if (token != null && token.isNotEmpty) {
      final user = localStorage.getUserProfile();

      // Check if profile is complete (e.g. has name)
      // Adjust this logic based on your specific "complete" criteria
      if (user != null &&
          user.name != null &&
          (user.name!.en.isNotEmpty || user.name!.ar.isNotEmpty)) {
        log('user is authenticated');
        emit(AppAuthenticated());
      } else if (user != null && (user.isBanned ?? false)) {
        log('user is banned');
        emit(AppUserBanned());
      } else if (user != null && (user.isDeleted ?? false)) {
        log('user is deleted');
        emit(AppUserDeleted());
      } else {
        log('user is incomplete');
        emit(AppIncompleteProfile());
      }
    } else {
      log('user is unauthenticated');
      emit(AppUnauthenticated());
    }
  }

  Future<void> logout() async {
    final localStorage = locator<LocalStorage>();
    await localStorage.logout();
    emit(AppLogout());
  }
}

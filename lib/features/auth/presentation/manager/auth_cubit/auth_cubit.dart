import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/auth/data/models/request_otp_response_model.dart';
import 'package:wasel/features/auth/data/repos/auth_repo_impl.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepoImpl authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> requestOtp(String phone) async {
    emit(AuthLoading());
    final result = await authRepo.requestPhoneOtp(phone: phone);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (response) => emit(AuthOtpSent(response)),
    );
  }

  Future<void> verifyOtp(String phone, String code) async {
    emit(AuthLoading());
    final result = await authRepo.verifyPhone(phone: phone, code: code);
    result.fold((failure) => emit(AuthFailure(failure.message)), (
      authModel,
    ) async {
      if (authModel.token != null) {
        await locator<LocalStorage>().saveAuthToken(authModel.token!);
      }
      emit(AuthLoginSuccess(authModel));
    });
  }

  Future<void> logout() async {
    emit(AuthLoading());
    // If there is an API call for logout, call it here:
    // await authRepo.logout();

    // Clear local session
    await locator<LocalStorage>().logout();
    emit(AuthLogoutSuccess());
  }
}

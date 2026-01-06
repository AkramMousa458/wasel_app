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

  Future<void> requestEmailOtp(String email) async {
    emit(AuthLoading());
    final result = await authRepo.requestEmailOtp(email: email);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (response) => emit(AuthOtpSent(response)),
    );
  }

  Future<void> verifyEmail(String email, String code) async {
    emit(AuthLoading());
    final result = await authRepo.verifyEmail(email: email, code: code);
    result.fold((failure) => emit(AuthFailure(failure.message)), (authModel) {
      if (authModel.token != null) {
        locator<LocalStorage>().saveAuthToken(authModel.token!);
      }
      if (authModel.user != null) {
        locator<LocalStorage>().saveUserProfile(authModel.user!);
      }
      emit(AuthLoginSuccess(authModel));
    });
  }

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
    result.fold((failure) => emit(AuthFailure(failure.message)), (authModel) {
      if (authModel.token != null) {
        locator<LocalStorage>().saveAuthToken(authModel.token!);
        locator<LocalStorage>().saveUserProfile(authModel.user!);
      }
      emit(AuthLoginSuccess(authModel));
    });
  }

  Future<void> completeProfile({
    required String arabicName,
    required String englishName,
    String? state,
    String? governorate,
    String? city,
    String? street,
    String? building,
    String? floor,
    String? door,
    double? lat,
    double? lng,
    String? pushToken,
  }) async {
    emit(AuthLoading());

    final Map<String, dynamic> data = {
      "name": {"en": englishName, "ar": arabicName},
      "address": {
        "state": state ?? "",
        "city": city ?? "",
        "street": street ?? "",
        "building": building ?? "",
        "floor": floor ?? "",
        "door": door ?? "",
        "governorate": governorate ?? "",
      },
    };

    if (lat != null && lng != null) {
      data["location"] = {
        "type": "Point",
        "coordinates": [lng, lat],
      };
    }

    if (pushToken != null) {
      data["pushToken"] = pushToken;
    }

    final result = await authRepo.updateProfile(data: data);
    result.fold((failure) => emit(AuthFailure(failure.message)), (authModel) {
      if (authModel.token != null) {
        locator<LocalStorage>().saveAuthToken(authModel.token!);
      }
      if (authModel.user != null) {
        locator<LocalStorage>().saveUserProfile(authModel.user!);
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

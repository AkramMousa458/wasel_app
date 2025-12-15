import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/auth/data/repos/auth_repo_impl.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepoImpl authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> login(String mobile, String? fcmToken) async {
    emit(AuthLoading());
    // final result = await authRepo.login(mobile: mobile, fcmToken: fcmToken);
    // result.fold(
    //   (failure) => emit(AuthFailure(failure.message)),
    //   (authModel) => emit(AuthLoginSuccess(authModel)),
    // );
  }


  // Future<void> logout() async {
  //   emit(AuthLoading());
  //   final result = await authRepo.logout();
  //   result.fold((failure) => emit(AuthFailure(failure.message)), (
  //     message,
  //   ) async {
  //     await locator<LocalStorage>().clearAuthToken();
  //     locator<LocalStorage>().clearUserProfile();
  //     emit(AuthLogoutSuccess());
  //   });
  // }

  // Future<void> deleteAccount() async {
  //   emit(AuthLoading());
  //   final result = await authRepo.deleteAccount();
  //   result.fold((failure) => emit(AuthFailure(failure.message)), (
  //     message,
  //   ) async {
  //     await locator<LocalStorage>().clearAuthToken();
  //     locator<LocalStorage>().clearUserProfile();
  //     emit(AuthDeleteAccountSuccess());
  //   });
  // }
}

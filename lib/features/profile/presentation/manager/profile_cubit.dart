import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/profile/data/repo/profile_repo_impl.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepoImpl profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getProfile() async {
    if (!isClosed) emit(ProfileLoading());
    final result = await profileRepo.getProfile();
    result.fold(
      (failure) {
        if (!isClosed) emit(ProfileError(failure.message));
      },
      (user) {
        if (!isClosed) emit(ProfileLoaded(user));
      },
    );
  }
  
}

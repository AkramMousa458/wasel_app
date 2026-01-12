import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/profile/data/repo/profile_repo_impl.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';

import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepoImpl profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getProfile() async {
    // 1. Try to load from Local Storage first
    final cachedUser = locator<LocalStorage>().getUserProfile();

    if (cachedUser != null) {
      if (!isClosed) emit(ProfileLoaded(cachedUser));
    } else {
      if (!isClosed) emit(ProfileLoading());
    }

    // 2. Sync with Server
    final result = await profileRepo.getProfile();
    result.fold(
      (failure) {
        // If we have cached data, we can silently fail or show a snackbar (but here we just keep the cached state)
        // Only emit error if we have NO data to show
        if (cachedUser == null && !isClosed) {
          emit(ProfileError(failure.message));
        }
      },
      (user) async {
        // 3. Update Local Storage & UI
        await locator<LocalStorage>().saveUserProfile(user);
        if (!isClosed) emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> updateProfile({
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
    if (!isClosed) emit(ProfileUpdating());

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

    final result = await profileRepo.updateProfile(data: data);
    result.fold(
      (failure) {
        if (!isClosed) emit(ProfileError(failure.message));
      },
      (authModel) async {
        if (authModel.token != null) {
          await locator<LocalStorage>().saveAuthToken(authModel.token!);
        }
        if (authModel.user != null) {
          await locator<LocalStorage>().saveUserProfile(authModel.user!);
          if (!isClosed) {
            emit(
              ProfileLoaded(authModel.user!),
            );
          }
        }
        if (!isClosed) emit(ProfileUpdateSuccess(authModel));
      },
    );
  }
}

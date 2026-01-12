import 'package:equatable/equatable.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';

import 'dart:io';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final File? localImage;
  const ProfileLoaded(this.user, {this.localImage});
  @override
  List<Object?> get props => [user, localImage];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final AuthModel authModel;
  const ProfileUpdateSuccess(this.authModel);
  @override
  List<Object?> get props => [authModel];
}
class ProfileImageUpdated extends ProfileState {
  final String message;
  const ProfileImageUpdated(this.message);
  @override
  List<Object?> get props => [message];
}

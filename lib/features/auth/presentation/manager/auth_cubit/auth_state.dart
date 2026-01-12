part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final RequestOtpResponseModel response;

  const AuthOtpSent(this.response);

  @override
  List<Object?> get props => [response];
}

class AuthLoginSuccess extends AuthState {
  final AuthModel authModel;

  const AuthLoginSuccess(this.authModel);

  @override
  List<Object?> get props => [authModel];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthUpdateProfileSuccess extends AuthState {
  final AuthModel authModel;

  const AuthUpdateProfileSuccess(this.authModel);

  @override
  List<Object?> get props => [authModel];
}
class AuthLogoutSuccess extends AuthState {}

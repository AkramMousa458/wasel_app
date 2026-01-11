import 'package:equatable/equatable.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class AppInitial extends AppState {}

final class AppUnauthenticated extends AppState {}
final class AppLogout extends AppState {}

final class AppIncompleteProfile extends AppState {}

final class AppAuthenticated extends AppState {}
final class AppUserBanned extends AppState {}
final class AppUserDeleted extends AppState {}

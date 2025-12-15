import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

enum ConnectionStatus { connected, disconnected }

class ConnectionCubit extends Cubit<ConnectionStatus> {
  final Connectivity _connectivity = Connectivity();
  late final InternetConnectionChecker _checker;

  StreamSubscription<InternetConnectionStatus>? _internetSub;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  ConnectionCubit() : super(ConnectionStatus.connected) {
    _initialize();
  }

  Future<void> _initialize() async {
    // connectivity changes (wifi, mobile, none)
    _connectivitySub = _connectivity.onConnectivityChanged.listen((
      results,
    ) async {
      await _checkNow();
    });

    // internet checker (ping test)
    _checker = InternetConnectionChecker.createInstance(
      checkInterval: const Duration(seconds: 5),
      checkTimeout: const Duration(seconds: 5),
    );

    _internetSub = _checker.onStatusChange.listen((status) {
      final isConnected = status == InternetConnectionStatus.connected;
      emit(
        isConnected
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
      );
      log("Internet status: $isConnected");
    });

    // initial check
    await _checkNow();
  }

  Future<void> _checkNow() async {
    try {
      final hasInternet = await _checker.hasConnection;
      emit(
        hasInternet
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
      );
    } catch (e) {
      emit(ConnectionStatus.disconnected);
      log("Error checking internet: $e");
    }
  }

  // Add this method to manually check connection
  Future<void> checkConnection() async {
    await _checkNow();
  }

  @override
  Future<void> close() {
    _internetSub?.cancel();
    _connectivitySub?.cancel();
    return super.close();
  }
}

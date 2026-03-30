import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  static const int _cooldownSeconds = 60;

  OtpCubit() : super(const OtpState());

  void startResendCooldown() {
    emit(state.copyWith(remainingSeconds: _cooldownSeconds));
  }

  void tickTimer() {
    if (state.remainingSeconds <= 0) return;
    emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
  }

  void updateDigit(int index, String value) {
    emit(state.copyWith(currentDigits: value));
  }

  bool canResend() => state.remainingSeconds <= 0;
}

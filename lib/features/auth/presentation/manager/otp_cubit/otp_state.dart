part of 'otp_cubit.dart';

class OtpState extends Equatable {
  final int remainingSeconds;
  final String currentDigits;

  const OtpState({
    this.remainingSeconds = 60,
    this.currentDigits = '',
  });

  OtpState copyWith({
    int? remainingSeconds,
    String? currentDigits,
  }) {
    return OtpState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentDigits: currentDigits ?? this.currentDigits,
    );
  }

  @override
  List<Object?> get props => [remainingSeconds, currentDigits];
}

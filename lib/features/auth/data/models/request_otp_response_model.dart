import 'package:equatable/equatable.dart';

class RequestOtpResponseModel extends Equatable {
  final bool? success;
  final String? provider;
  final String? code;
  final String? message;

  const RequestOtpResponseModel({
    this.success,
    this.provider,
    this.code,
    this.message,
  });

  factory RequestOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestOtpResponseModel(
      success: json['success'],
      provider: json['provider'],
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'provider': provider,
      'code': code,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [success, provider, code, message];
}

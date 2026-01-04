import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  final bool? success;
  final String? token;
  final UserModel? user;

  const AuthModel({this.success, this.token, this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      success: json['success'],
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'token': token, 'user': user?.toJson()};
  }

  @override
  List<Object?> get props => [success, token, user];
}

class UserModel extends Equatable {
  final String? sId;
  final UserName? name;
  final String? email;
  final String? phone;
  final String? phoneCountry;
  final String? role;
  final String? image;
  final bool? isActive;
  final bool? isBanned;
  final bool? isDeleted;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? lastOnlineAt;
  final UserAddress? address;
  final double? spend;
  final dynamic wallet;
  final String? pushToken;
  final String? createdAt;
  final String? updatedAt;
  final int? iV;
  final bool? online;

  const UserModel({
    this.sId,
    this.name,
    this.email,
    this.phone,
    this.phoneCountry,
    this.role,
    this.image,
    this.isActive,
    this.isBanned,
    this.isDeleted,
    this.emailVerified,
    this.phoneVerified,
    this.lastOnlineAt,
    this.address,
    this.spend,
    this.wallet,
    this.pushToken,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.online,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      sId: json['_id'],
      name: json['name'] != null ? UserName.fromJson(json['name']) : null,
      email: json['email'],
      phone: json['phone'],
      phoneCountry: json['phoneCountry'],
      role: json['role'],
      image: json['image'],
      isActive: json['isActive'],
      isBanned: json['isBanned'],
      isDeleted: json['isDeleted'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      lastOnlineAt: json['lastOnlineAt'],
      address: json['address'] != null
          ? UserAddress.fromJson(json['address'])
          : null,
      spend: json['spend'] != null ? (json['spend'] as num).toDouble() : 0,
      wallet: json['wallet'],
      pushToken: json['pushToken'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      online: json['online'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name?.toJson(),
      'email': email,
      'phone': phone,
      'phoneCountry': phoneCountry,
      'role': role,
      'image': image,
      'isActive': isActive,
      'isBanned': isBanned,
      'isDeleted': isDeleted,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'lastOnlineAt': lastOnlineAt,
      'address': address?.toJson(),
      'spend': spend,
      'wallet': wallet,
      'pushToken': pushToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'online': online,
    };
  }

  @override
  List<Object?> get props => [
    sId,
    name,
    email,
    phone,
    phoneCountry,
    role,
    image,
    isActive,
    isBanned,
    isDeleted,
    emailVerified,
    phoneVerified,
    lastOnlineAt,
    address,
    spend,
    wallet,
    pushToken,
    createdAt,
    updatedAt,
    iV,
    online,
  ];
}

class UserName extends Equatable {
  final String en;
  final String ar;

  const UserName({required this.en, required this.ar});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(en: json['en'] ?? '', ar: json['ar'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'en': en, 'ar': ar};
  }

  @override
  List<Object?> get props => [en, ar];
}

class UserAddress extends Equatable {
  final String governorate;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String door;

  const UserAddress({
    required this.governorate,
    required this.city,
    required this.street,
    required this.building,
    required this.floor,
    required this.door,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      building: json['building'] ?? '',
      floor: json['floor'] ?? '',
      door: json['door'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'governorate': governorate,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'door': door,
    };
  }

  @override
  List<Object?> get props => [governorate, city, street, building, floor, door];
}

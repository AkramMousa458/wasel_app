import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  final bool? success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;

  const AuthModel({
    this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      success: json['success'],
      message: json['message'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
    };
  }

  @override
  List<Object?> get props => [success, message, accessToken, refreshToken, user];
}

class UserModel extends Equatable {
  final String? sId;
  final UserName? name;
  final String? email;
  final String? phone;
  final String? phoneCountry;
  final String? birthDate;
  final String? role;
  final String? image;
  final String? status;
  final bool? isActive;
  final bool? isBanned;
  final bool? isDeleted;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? lastOnlineAt;
  final dynamic driverProfile;
  final dynamic merchantProfile;
  final dynamic wallet;
  final double? spend;
  final String? pushToken;
  final List<dynamic> savedAddresses;
  final String? createdAt;
  final String? updatedAt;
  final int? iV;
  final UserAddress? address;
  final bool? online;
  final UserLocation? location;

  const UserModel({
    this.sId,
    this.name,
    this.email,
    this.phone,
    this.phoneCountry,
    this.birthDate,
    this.role,
    this.image,
    this.status,
    this.isActive,
    this.isBanned,
    this.isDeleted,
    this.emailVerified,
    this.phoneVerified,
    this.lastOnlineAt,
    this.driverProfile,
    this.merchantProfile,
    this.wallet,
    this.spend,
    this.pushToken,
    this.savedAddresses = const [],
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.address,
    this.online,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      sId: json['_id'] ?? json['id'],
      name: json['name'] != null ? UserName.fromJson(json['name']) : null,
      email: json['email'],
      phone: json['phone'],
      phoneCountry: json['phoneCountry'],
      birthDate: json['birthDate'],
      role: json['role'],
      image: json['image'],
      status: json['status'],
      isActive: json['isActive'],
      isBanned: json['isBanned'],
      isDeleted: json['isDeleted'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      lastOnlineAt: json['lastOnlineAt'],
      driverProfile: json['driverProfile'],
      merchantProfile: json['merchantProfile'],
      wallet: json['wallet'],
      spend: json['spend'] != null ? (json['spend'] as num).toDouble() : 0,
      pushToken: json['pushToken'],
      savedAddresses: json['savedAddresses'] != null
          ? List<dynamic>.from(json['savedAddresses'])
          : [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      address: json['address'] != null
          ? UserAddress.fromJson(json['address'])
          : null,
      online: json['online'],
      location: json['location'] != null
          ? UserLocation.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name?.toJson(),
      'email': email,
      'phone': phone,
      'phoneCountry': phoneCountry,
      'birthDate': birthDate,
      'role': role,
      'image': image,
      'status': status,
      'isActive': isActive,
      'isBanned': isBanned,
      'isDeleted': isDeleted,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'lastOnlineAt': lastOnlineAt,
      'driverProfile': driverProfile,
      'merchantProfile': merchantProfile,
      'wallet': wallet,
      'spend': spend,
      'pushToken': pushToken,
      'savedAddresses': savedAddresses,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'address': address?.toJson(),
      'online': online,
      'location': location?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    sId,
    name,
    email,
    phone,
    phoneCountry,
    birthDate,
    role,
    image,
    status,
    isActive,
    isBanned,
    isDeleted,
    emailVerified,
    phoneVerified,
    lastOnlineAt,
    driverProfile,
    merchantProfile,
    wallet,
    spend,
    pushToken,
    savedAddresses,
    createdAt,
    updatedAt,
    iV,
    address,
    online,
    location,
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
  final String state;
  final String governorate;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String door;

  const UserAddress({
    required this.state,
    required this.governorate,
    required this.city,
    required this.street,
    required this.building,
    required this.floor,
    required this.door,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      state: json['state'] ?? '',
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
      'state': state,
      'governorate': governorate,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'door': door,
    };
  }

  @override
  List<Object?> get props => [
    state,
    governorate,
    city,
    street,
    building,
    floor,
    door,
  ];
}

class UserLocation extends Equatable {
  final String type;
  final List<double> coordinates;

  const UserLocation({required this.type, required this.coordinates});

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      type: json['type'] ?? '',
      coordinates: json['coordinates'] != null
          ? List<double>.from(
              (json['coordinates'] as List).map((e) => (e as num).toDouble()),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  @override
  List<Object?> get props => [type, coordinates];
}

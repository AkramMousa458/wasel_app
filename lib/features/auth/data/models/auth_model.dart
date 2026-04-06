import 'package:equatable/equatable.dart';

/// =======================
/// AUTH MODEL
/// =======================
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

/// =======================
/// USER MODEL
/// =======================
class UserModel extends Equatable {
  final String? id;
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
  final bool? online;

  final double? spend;
  final dynamic wallet;
  final String? pushToken;

  final List<SavedAddress> savedAddresses;

  final String? createdAt;
  final String? updatedAt;
  final int? iV;
  final UserLocation? location;

  const UserModel({
    this.id,
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
    this.online,
    this.spend,
    this.wallet,
    this.pushToken,
    this.savedAddresses = const [],
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
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
      online: json['online'],
      spend: (json['spend'] as num?)?.toDouble(),
      wallet: json['wallet'],
      pushToken: json['pushToken'],
      savedAddresses: json['savedAddresses'] != null
          ? List<SavedAddress>.from(
              json['savedAddresses'].map((e) => SavedAddress.fromJson(e)),
            )
          : const [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      location: json['location'] != null
          ? UserLocation.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
      'online': online,
      'spend': spend,
      'wallet': wallet,
      'pushToken': pushToken,
      'savedAddresses': savedAddresses
          .map((address) => address.toJson())
          .toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'location': location?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
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
    online,
    spend,
    wallet,
    spend,
    pushToken,
    savedAddresses,
    birthDate,
    createdAt,
    updatedAt,
    iV,
    online,
    location,
  ];
}

/// =======================
/// USER NAME
/// =======================
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

/// =======================
/// SAVED ADDRESS
/// =======================
class SavedAddress extends Equatable {
  final String? id;
  final String label;
  final AddressDetails address;
  final UserLocation location;
  final bool isDefault;

  const SavedAddress({
    this.id,
    required this.label,
    required this.address,
    required this.location,
    required this.isDefault,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      id: json['_id'] ?? json['id'],
      label: json['label'] ?? '',
      address: AddressDetails.fromJson(json['address'] ?? {}),
      location: UserLocation.fromJson(json['location'] ?? {}),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': label,
      'location': location.toJson(),
      'isDefault': isDefault,
    };
  }

  @override
  List<Object?> get props => [id, label, address, location, isDefault];
}

/// =======================
/// ADDRESS DETAILS
/// =======================
class AddressDetails extends Equatable {
  final String governorate;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String door;

  const AddressDetails({
    required this.governorate,
    required this.city,
    required this.street,
    required this.building,
    required this.floor,
    required this.door,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
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

/// =======================
/// USER LOCATION (GEOJSON)
/// =======================
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
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  @override
  List<Object?> get props => [type, coordinates];
}

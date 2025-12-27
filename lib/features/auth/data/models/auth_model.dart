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
  final UserName? name;
  final UserAddress? address;
  final String? sId;
  final String? phone;
  final String? role;
  final bool? isActive;
  final bool? isBanned;
  final bool? isDeleted;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? createdAt;
  final String? updatedAt;
  final int? iV;
  final UserLocation? location;
  final String? pushToken;
  final String? id;

  const UserModel({
    this.name,
    this.address,
    this.sId,
    this.phone,
    this.role,
    this.isActive,
    this.isBanned,
    this.isDeleted,
    this.emailVerified,
    this.phoneVerified,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.location,
    this.pushToken,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] != null ? UserName.fromJson(json['name']) : null,
      address: json['address'] != null
          ? UserAddress.fromJson(json['address'])
          : null,
      sId: json['_id'],
      phone: json['phone'],
      role: json['role'],
      isActive: json['isActive'],
      isBanned: json['isBanned'],
      isDeleted: json['isDeleted'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      location: json['location'] != null
          ? UserLocation.fromJson(json['location'])
          : null,
      pushToken: json['pushToken'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name?.toJson(),
      'address': address?.toJson(),
      '_id': sId,
      'phone': phone,
      'role': role,
      'isActive': isActive,
      'isBanned': isBanned,
      'isDeleted': isDeleted,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'location': location?.toJson(),
      'pushToken': pushToken,
      'id': id,
    };
  }

  @override
  List<Object?> get props => [
    name,
    address,
    sId,
    phone,
    role,
    isActive,
    isBanned,
    isDeleted,
    emailVerified,
    phoneVerified,
    createdAt,
    updatedAt,
    iV,
    location,
    pushToken,
    id,
  ];
}

class UserName extends Equatable {
  final String? en;
  final String? ar;

  const UserName({this.en, this.ar});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(en: json['en'], ar: json['ar']);
  }

  Map<String, dynamic> toJson() {
    return {'en': en, 'ar': ar};
  }

  @override
  List<Object?> get props => [en, ar];
}

class UserAddress extends Equatable {
  final String? state;
  final String? city;
  final String? street;
  final String? building;
  final String? floor;
  final String? door;

  const UserAddress({
    this.state,
    this.city,
    this.street,
    this.building,
    this.floor,
    this.door,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      state: json['state'],
      city: json['city'],
      street: json['street'],
      building: json['building'],
      floor: json['floor'],
      door: json['door'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'door': door,
    };
  }

  @override
  List<Object?> get props => [state, city, street, building, floor, door];
}

class UserLocation extends Equatable {
  final String? type;
  final List<double>? coordinates;

  const UserLocation({this.type, this.coordinates});

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  @override
  List<Object?> get props => [type, coordinates];
}

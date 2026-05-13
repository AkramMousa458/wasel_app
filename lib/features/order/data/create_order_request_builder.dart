import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/order/data/models/order_draft_model.dart';

/// Builds the JSON body for `POST api/v1/orders` from the local order wizard draft.
Map<String, dynamic> buildCreateOrderRequestBody({
  required OrderDraftModel draft,
  required UserModel? user,
  required String customerDeviceId,
  required String languageCode,
}) {
  final pickupLat = draft.pickupLatitude;
  final pickupLng = draft.pickupLongitude;
  final dropLat = draft.dropoffLatitude;
  final dropLng = draft.dropoffLongitude;

  if (pickupLat == null ||
      pickupLng == null ||
      dropLat == null ||
      dropLng == null) {
    throw StateError('Order draft is missing pickup/dropoff coordinates.');
  }

  final contactName = _displayName(user, languageCode);
  final contactPhone = (user?.phone ?? '').trim();

  final deliveryFee = draft.deliveryFee ?? 0;
  final itemSubtotal = (draft.serviceFee ?? 0) > 0 ? draft.serviceFee! : 1.0;
  final discountAmount = 0.0;
  final total = itemSubtotal + deliveryFee - discountAmount;

  final title = _itemTitle(draft);
  final notes = (draft.details ?? '').trim();

  return {
    'items': [
      {
        'product': draft.packageSize ?? 'parcel',
        'title': title,
        'qty': 1,
        'unitPrice': itemSubtotal,
        'extras': <Map<String, dynamic>>[],
        'notes': notes,
      },
    ],
    'pickup': {
      'address': draft.pickupAddress ?? '',
      'contactName': contactName,
      'contactPhone': contactPhone,
      'location': {
        'type': 'Point',
        'coordinates': [pickupLng, pickupLat],
      },
      'notes': '',
    },
    'pickupStops': <dynamic>[],
    'dropoff': {
      'address': draft.dropoffAddress ?? '',
      'contactName': contactName,
      'contactPhone': contactPhone,
      'location': {
        'type': 'Point',
        'coordinates': [dropLng, dropLat],
      },
      'notes': notes,
    },
    'requestType': 'pickup_from_shop',
    'typePayOrder': 'fixed',
    'notes': notes,
    'slaTier': 'standard',
    'subTotal': itemSubtotal,
    'deliveryFee': deliveryFee,
    'discountAmount': discountAmount,
    'total': total,
    'currency': 'EGP',
    'paymentMethod': _paymentMethodApi(draft.paymentMethodId),
    'customerDeviceId': customerDeviceId,
    'coupon': {
      'code': '',
      'discountAmount': 0,
    },
  };
}

String _displayName(UserModel? user, String languageCode) {
  if (user?.name == null) return 'Customer';
  final raw = languageCode == 'ar' ? user!.name!.ar : user!.name!.en;
  final trimmed = raw.trim();
  return trimmed.isNotEmpty ? trimmed : 'Customer';
}

String _itemTitle(OrderDraftModel draft) {
  final details = (draft.details ?? '').trim();
  if (details.isEmpty) return 'Parcel';
  return details.length <= 120 ? details : details.substring(0, 120);
}

String _paymentMethodApi(String? paymentMethodId) {
  switch (paymentMethodId) {
    case 'debit_credit_card':
      return 'card';
    case 'apple_pay':
      return 'apple_pay';
    case 'cash_on_delivery':
    default:
      return 'cash';
  }
}

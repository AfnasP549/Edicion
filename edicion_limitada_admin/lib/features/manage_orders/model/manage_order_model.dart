import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrderModel {
  final String id;
  final String userId;
  final List<AdminOrderItem> items;
  final AdminAddressModel address;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;

  AdminOrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory AdminOrderModel.fromMap(Map<String, dynamic> map) {
    return AdminOrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: List<AdminOrderItem>.from(
        (map['items'] ?? []).map((x) => AdminOrderItem.fromMap(x)),
      ),
      address: AdminAddressModel.fromMap(map['address'] ?? {}),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

class AdminOrderItem {
  final String productId;
  final int quantity;
  final double price;
  final String productName;
  final String imageUrl;

  AdminOrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.imageUrl,
  });

  factory AdminOrderItem.fromMap(Map<String, dynamic> map) {
    return AdminOrderItem(
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
      productName: map['productName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}




class AdminAddressModel {
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AdminAddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory AdminAddressModel.fromMap(Map<String, dynamic> map) {
    return AdminAddressModel(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
    );
  }

  @override
  String toString() {
    return '$street, $city, $state $postalCode, $country';
  }
}
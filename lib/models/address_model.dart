class AddressModel {
  final String id;
  final String userId;
  final String name;
  final String address;
  final String city;
  final String phone;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.isDefault,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map, String docId) {
    return AddressModel(
      id: docId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'address': address,
      'city': city,
      'phone': phone,
      'isDefault': isDefault,
    };
  }
}

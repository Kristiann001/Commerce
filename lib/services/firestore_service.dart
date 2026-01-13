import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/address_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get _productsRef => _db.collection('products');
  CollectionReference get _ordersRef => _db.collection('orders');
  CollectionReference get _addressesRef => _db.collection('addresses');

  // ===== PRODUCTS =====
  
  Future<void> addProduct(ProductModel product) async {
    await _productsRef.add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productsRef.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  Stream<List<ProductModel>> getProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // ===== ORDERS =====

  Future<String> createOrder(OrderModel order) async {
    final docRef = await _ordersRef.add(order.toMap());
    return docRef.id;
  }

  Stream<List<OrderModel>> getOrdersForUser(String userId) {
    return _ordersRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _ordersRef.doc(orderId).update({'status': status});
  }

  // ===== ADDRESSES =====

  Future<String> addAddress(AddressModel address) async {
    // If this is set as default, unset other defaults first
    if (address.isDefault) {
      await _unsetDefaultAddresses(address.userId);
    }
    final docRef = await _addressesRef.add(address.toMap());
    return docRef.id;
  }

  Stream<List<AddressModel>> getAddressesForUser(String userId) {
    return _addressesRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddressModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateAddress(AddressModel address) async {
    if (address.isDefault) {
      await _unsetDefaultAddresses(address.userId);
    }
    await _addressesRef.doc(address.id).update(address.toMap());
  }

  Future<void> deleteAddress(String addressId) async {
    await _addressesRef.doc(addressId).delete();
  }

  Future<void> setDefaultAddress(String addressId, String userId) async {
    await _unsetDefaultAddresses(userId);
    await _addressesRef.doc(addressId).update({'isDefault': true});
  }

  Future<void> _unsetDefaultAddresses(String userId) async {
    final snapshot = await _addressesRef
        .where('userId', isEqualTo: userId)
        .where('isDefault', isEqualTo: true)
        .get();
    
    for (var doc in snapshot.docs) {
      await doc.reference.update({'isDefault': false});
    }
  }

  Future<AddressModel?> getDefaultAddress(String userId) async {
    final snapshot = await _addressesRef
        .where('userId', isEqualTo: userId)
        .where('isDefault', isEqualTo: true)
        .limit(1)
        .get();
    
    if (snapshot.docs.isNotEmpty) {
      return AddressModel.fromMap(
        snapshot.docs.first.data() as Map<String, dynamic>,
        snapshot.docs.first.id,
      );
    }
    return null;
  }
}

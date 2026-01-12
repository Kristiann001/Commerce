import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection Reference
  CollectionReference get _productsRef => _db.collection('products');

  // Add Product
  Future<void> addProduct(ProductModel product) async {
    await _productsRef.add(product.toMap());
  }

  // Update Product
  Future<void> updateProduct(ProductModel product) async {
    await _productsRef.doc(product.id).update(product.toMap());
  }

  // Delete Product
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  // Get Products Stream
  Stream<List<ProductModel>> getProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}

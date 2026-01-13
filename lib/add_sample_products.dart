import 'package:cloud_firestore/cloud_firestore.dart';

/// Sample Product Data Generator
/// Run this to populate your Firestore with sample products

Future<void> addSampleProducts() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference products = firestore.collection('products');

  // ignore: avoid_print
  print('🛍️ Adding sample products to Firestore...\n');

  final List<Map<String, dynamic>> sampleProducts = [
    {
      'name': 'Classic White Sneakers',
      'description': 'Comfortable all-day wear sneakers with premium leather finish. Perfect for casual outings and daily activities.',
      'price': 89.99,
      'category': 'Shoes',
      'imageUrl': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
      'stock': 50,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Denim Jacket',
      'description': 'Vintage-style denim jacket with a modern fit. Made from high-quality denim fabric.',
      'price': 129.99,
      'category': 'Men',
      'imageUrl': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
      'stock': 30,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Floral Summer Dress',
      'description': 'Light and breezy summer dress with beautiful floral patterns. Perfect for warm weather.',
      'price': 79.99,
      'category': 'Women',
      'imageUrl': 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500',
      'stock': 25,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Leather Backpack',
      'description': 'Premium leather backpack with multiple compartments. Ideal for work or travel.',
      'price': 149.99,
      'category': 'Accessories',
      'imageUrl': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      'stock': 20,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Wireless Headphones',
      'description': 'Premium noise-cancelling wireless headphones with 30-hour battery life.',
      'price': 199.99,
      'category': 'Electronics',
      'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      'stock': 40,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Cotton T-Shirt',
      'description': 'Soft cotton t-shirt available in multiple colors. Comfortable fit for everyday wear.',
      'price': 29.99,
      'category': 'Men',
      'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
      'stock': 100,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Running Shoes',
      'description': 'Lightweight running shoes with excellent cushioning and support.',
      'price': 119.99,
      'category': 'Shoes',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      'stock': 45,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Yoga Pants',
      'description': 'High-waisted yoga pants with moisture-wicking fabric. Perfect for workouts.',
      'price': 59.99,
      'category': 'Women',
      'imageUrl': 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=500',
      'stock': 60,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Smart Watch',
      'description': 'Feature-packed smartwatch with fitness tracking and notifications.',
      'price': 249.99,
      'category': 'Electronics',
      'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      'stock': 35,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Kids Hoodie',
      'description': 'Cozy hoodie for kids with fun designs. Soft and comfortable.',
      'price': 39.99,
      'category': 'Kids',
      'imageUrl': 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=500',
      'stock': 55,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Sunglasses',
      'description': 'Stylish UV-protection sunglasses with polarized lenses.',
      'price': 69.99,
      'category': 'Accessories',
      'imageUrl': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500',
      'stock': 70,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Winter Coat',
      'description': 'Warm winter coat with water-resistant outer layer.',
      'price': 189.99,
      'category': 'Men',
      'imageUrl': 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=500',
      'stock': 22,
      'createdAt': FieldValue.serverTimestamp(),
    },
  ];

  // ignore: unused_local_variable
  int count = 0;
  for (var productData in sampleProducts) {
    await products.add(productData);
    count++;
    // ignore: avoid_print
    print('✅ Added: ${productData['name']} (\$${productData['price']})');
  }

  // ignore: avoid_print
  print('Refresh your app to see the products.');
}

void main() async {
  await addSampleProducts();
}

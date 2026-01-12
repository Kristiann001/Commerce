import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/product_card.dart';
import 'product_details_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

class FilteredProductsScreen extends StatelessWidget {
  final String category;

  const FilteredProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: StreamBuilder<List<ProductModel>>(
        stream: firestoreService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allProducts = snapshot.data ?? [];
          // Client-side filtering for simplicity (Firestore queries strictly require indexes for robust filtering)
          // For a small app, this is fine.
          final filteredProducts = allProducts.where((p) => p.category == category).toList();

          if (filteredProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No items found in $category', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Consumer<WishlistProvider>(
                builder: (context, wishlist, _) {
                  return ProductCard(
                    product: product,
                    isFavorite: wishlist.isInWishlist(product.id),
                    onFavorite: () => wishlist.toggleWishlist(product),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                    ),
                    onAdd: () {
                      Provider.of<CartProvider>(context, listen: false).addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to Cart!'), duration: Duration(milliseconds: 500)),
                      );
                    },
                  );
                }
              );
            },
          );
        },
      ),
    );
  }
}

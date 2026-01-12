import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/glass_box.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Parallax Header
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
                  child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
                ),
                actions: [
                  Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isFav = wishlist.isInWishlist(product.id);
                      return Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? Colors.red : Colors.black),
                          onPressed: () => wishlist.toggleWishlist(product),
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_${product.id}',
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(product.imageUrl, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),

              // 2. Product Info
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(product.name, style: Theme.of(context).textTheme.displayMedium)),
                            Text('\$${product.price.toStringAsFixed(2)}', 
                                 style: const TextStyle(fontSize: 26, color: AppTheme.primaryColor, fontWeight: FontWeight.w900)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Rating simulated
                        Row(children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                          const Text(' 4.8 ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('(120 reviews)', style: TextStyle(color: Colors.grey[600])),
                        ]),
                        const SizedBox(height: 24),
                        Text('Description', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 12),
                        Text(product.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTrustBadge(Icons.verified_user_rounded, 'Secure\nPayment'),
                            _buildTrustBadge(Icons.local_shipping_rounded, 'Fast\nDelivery'),
                            _buildTrustBadge(Icons.cached_rounded, 'Easy\nReturns'),
                          ],
                        ),
                        const SizedBox(height: 120), // Space for floating cart bar
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. Floating Glass Action Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: GlassBox(
              blur: 20,
              opacity: 0.9,
              borderRadius: 25,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Price', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.name} added to cart!'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

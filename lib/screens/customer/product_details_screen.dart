import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 450,
                pinned: true,
                backgroundColor: Colors.transparent,
                leading: _buildCycleButton(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
                actions: [
                  Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isFav = wishlist.isInWishlist(widget.product.id);
                      return _buildCycleButton(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        () => wishlist.toggleWishlist(widget.product),
                        color: isFav ? Colors.red : Colors.black,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_${widget.product.id}',
                    child: widget.product.imageUrl.isNotEmpty
                        ? Image.network(widget.product.imageUrl, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.product.category,
                                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'KES ${widget.product.price.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Description'),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(color: Colors.grey[600], height: 1.6),
                      ),
                      const SizedBox(height: 24),

                      const SizedBox(height: 24),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(24),
                // ignore: deprecated_member_use
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20)],
              ),
              child: Row(
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                        'KES ${widget.product.price.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  FutureBuilder<UserModel?>(
                    future: Provider.of<AuthService>(context, listen: false).getCurrentUser(),
                    builder: (context, snapshot) {
                      final isOwner = snapshot.hasData && snapshot.data!.role == UserRole.admin;
                      
                      if (isOwner) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Admin View Only',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      return ElevatedButton(
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false).addToCart(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${widget.product.name} added to cart!'), behavior: SnackBarBehavior.floating),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text('Add to Cart'),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleButton(IconData icon, VoidCallback onTap, {Color color = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        // ignore: deprecated_member_use
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold));
  }




}

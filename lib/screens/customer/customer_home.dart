import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; 
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart'; // Added
import '../../services/auth_service.dart'; // Added
import '../../services/firestore_service.dart';
import '../../utils/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product_card.dart';
import 'product_details_screen.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All', 'T-Shirt', 'Crop Tops', 'Blazers', 'Pants', 'Shoes'];

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Background decoration (subtle gradient spheres)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppTheme.primaryColor.withValues(alpha: 0.2), Colors.transparent]),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Glassmorphic App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 80,
                floating: true,
                pinned: false, // Let it scroll away for more space
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.primaryColor, width: 2)),
                                padding: const EdgeInsets.all(2),
                                child: const CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), 
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<UserModel?>(
                                    future: Provider.of<AuthService>(context, listen: false).getCurrentUser(),
                                    builder: (context, snapshot) {
                                      String name = snapshot.data?.name ?? 'Guest';
                                      return Text('Hi, $name!', style: Theme.of(context).textTheme.titleLarge);
                                    },
                                  ),
                                  Text('Find your style', style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
                            ),
                            child: const Icon(Icons.notifications_none_rounded, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Search & Filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(20),
                             boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10)],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                               border: InputBorder.none,
                               enabledBorder: InputBorder.none,
                               focusedBorder: InputBorder.none,
                               contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor, // Dark button for contrast
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // 3. Carousel Banner
              SliverToBoxAdapter(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 180.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    // removed slideResizeMode
                    viewportFraction: 0.85,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  ),
                  items: [1, 2, 3].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            gradient: i == 1 
                              ? const LinearGradient(colors: [Color(0xFF2962FF), Color(0xFF82B1FF)])
                              : i == 2 ? const LinearGradient(colors: [Color(0xFF6200EA), Color(0xFFB388FF)])
                              : const LinearGradient(colors: [Color(0xFFFF6D00), Color(0xFFFF9E80)]),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
                          ),
                          child: Stack(
                            children: [
                              Positioned(right: -30, bottom: -30, child: Icon(Icons.shopping_bag_outlined, size: 150, color: Colors.white.withValues(alpha: 0.1))),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                                      child: const Text('New Collection', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('Summer Sale\nUp to 50% Off', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppTheme.primaryColor,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        minimumSize: const Size(0, 36),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                      ),
                                      child: const Text('Shop Now'),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // 4. Categories
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 45, // Slightly larger height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedCategoryIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 12),
                        child: TextButton(
                          onPressed: () => setState(() => _selectedCategoryIndex = index),
                          style: TextButton.styleFrom(
                            backgroundColor: isSelected ? AppTheme.secondaryColor : Colors.white, // Black pill when selected
                            foregroundColor: isSelected ? Colors.white : Colors.grey[600],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: isSelected ? BorderSide.none : BorderSide(color: Colors.grey[200]!)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                            elevation: isSelected ? 4 : 0,
                            shadowColor: Colors.black.withValues(alpha: 0.2),
                          ),
                          child: Text(_categories[index], style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // 5. Product Grid (Masonry)
              StreamBuilder<List<ProductModel>>(
                stream: firestoreService.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(child: _buildSkeletonGrid());
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const SliverFillRemaining(child: Center(child: Text('No products available.')));
                  }

                  // Responsive Column Count
                  int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;
                  if (MediaQuery.of(context).size.width > 900) crossAxisCount = 4;

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Consumer<WishlistProvider>(
                          builder: (context, wishlist, child) {
                            return ProductCard(
                              product: product,
                              isFavorite: wishlist.isInWishlist(product.id),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product))),
                              onFavorite: () => wishlist.toggleWishlist(product),
                              onAdd: () {
                                 Provider.of<CartProvider>(context, listen: false).addToCart(product);
                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for floating nav
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}

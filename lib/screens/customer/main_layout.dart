import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/glass_box.dart';
import 'customer_home.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'account_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch wishlist when user logs in/app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
    });
  }

  final List<Widget> _screens = [
    const CustomerHome(),
    const CategoriesScreen(),
    const CartScreen(), // Will handle M-Pesa logic later
    const WishlistScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for floating nav
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Floating Glass Navbar
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400), // Limit width on desktop
                child: GlassBox(
                  blur: 20,
                  opacity: 0.8,
                  borderRadius: 30,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                        _buildNavItem(1, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Catg'),
                        _buildNavItem(2, Icons.shopping_bag_rounded, Icons.shopping_bag_outlined, 'Cart'),
                        _buildNavItem(3, Icons.favorite_rounded, Icons.favorite_outline_rounded, 'Saved'),
                        _buildNavItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Me'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String tooltip) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.all(10),
        decoration: isSelected 
            ? BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
          size: 26,
        ),
      ),
    );
  }
}

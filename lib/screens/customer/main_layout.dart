import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';
import 'customer_home.dart';
import 'discover_screen.dart';
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
    const DiscoverScreen(),
    const CartScreen(),
    const WishlistScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.explore_rounded, Icons.explore_outlined, 'Explore'),
                _buildNavItem(2, Icons.shopping_bag_rounded, Icons.shopping_bag_outlined, 'Cart'),
                _buildNavItem(3, Icons.favorite_rounded, Icons.favorite_outline_rounded, 'Saved'),
                _buildNavItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Me'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String tooltip) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: isSelected 
            ? BoxDecoration(
                // ignore: deprecated_member_use
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
          size: 26,
        ),
      ),
    );
  }
}

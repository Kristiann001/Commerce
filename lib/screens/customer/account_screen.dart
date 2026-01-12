import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/app_theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Account'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: AppTheme.secondaryColor,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Guest', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('guest@example.com', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            
            // Account Sections
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildSectionCard([
                       _buildTile(Icons.shopping_bag_outlined, 'Orders', 'Check your order status'),
                       const Divider(height: 1),
                       _buildTile(Icons.favorite_border, 'Saved Items', 'Your wishlist'),
                       const Divider(height: 1),
                       _buildTile(Icons.history, 'Recently Viewed', 'Items you looked at'),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionCard([
                       _buildTile(Icons.location_on_outlined, 'Address Book', 'Shipping addresses'),
                       const Divider(height: 1),
                       _buildTile(Icons.credit_card, 'Saved Cards', 'Payment methods'),
                    ]),
                     const SizedBox(height: 16),
                    _buildSectionCard([
                       _buildTile(Icons.settings_outlined, 'Settings', 'Notifications, Password'),
                       const Divider(height: 1),
                       ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Logout', style: TextStyle(color: Colors.red)),
                        onTap: () {
                           Provider.of<AuthService>(context, listen: false).signOut();
                        },
                      ),
                    ]),
                     const SizedBox(height: 20),
                     const Text('App Version 1.0.0', style: TextStyle(color: Colors.grey)),
                     const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Column(children: children),
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}

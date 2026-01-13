import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/app_theme.dart';
import '../profile/security_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: FutureBuilder(
                future: authService.getCurrentUser(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  final userName = user?.name ?? 'Guest User';
                  final userEmail = user?.email ?? 'guest@shoplon.com';

                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person_rounded, size: 40, color: AppTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Account Options
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('My Shopping'),
                  const SizedBox(height: 12),
                  _buildOptionTile(
                    context,
                    Icons.shopping_bag_outlined,
                    'My Orders',
                    'Check status & history',
                    () {},
                  ),
                  _buildOptionTile(
                    context,
                    Icons.favorite_outline_rounded,
                    'Wishlist',
                    'All your saved items',
                    () {},
                  ),
                  _buildOptionTile(
                    context,
                    Icons.local_shipping_outlined,
                    'Shipping Address',
                    'Manage locations',
                    () {},
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Settings & Privacy'),
                  const SizedBox(height: 12),
                  _buildOptionTile(
                    context,
                    Icons.security_rounded,
                    'Security',
                    'Password, biometric & more',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SecurityScreen()),
                      );
                    },
                  ),
                  _buildOptionTile(
                    context,
                    Icons.notifications_none_rounded,
                    'Notifications',
                    'Alerts & updates',
                    () {},
                  ),
                  _buildOptionTile(
                    context,
                    Icons.language_rounded,
                    'Language',
                    'English (United States)',
                    () {},
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Support'),
                  const SizedBox(height: 12),
                  _buildOptionTile(
                    context,
                    Icons.help_outline_rounded,
                    'Help Center',
                    'FAQs & support',
                    () {},
                  ),
                  _buildOptionTile(
                    context,
                    Icons.info_outline_rounded,
                    'Privacy Policy',
                    'Terms and conditions',
                    () {},
                  ),

                  const SizedBox(height: 32),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => authService.signOut(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom padding for nav bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

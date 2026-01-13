import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_theme.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newArrivals = false;
  bool _priceDrops = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shopping Alerts'),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSwitchTile(
                'Order Updates',
                'Get notified about your order status',
                Icons.local_shipping_outlined,
                _orderUpdates,
                (value) => setState(() => _orderUpdates = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Promotions & Sales',
                'Special offers and discounts',
                Icons.local_offer_outlined,
                _promotions,
                (value) => setState(() => _promotions = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'New Arrivals',
                'Be the first to know about new products',
                Icons.new_releases_outlined,
                _newArrivals,
                (value) => setState(() => _newArrivals = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'Price Drops',
                'When items in your wishlist go on sale',
                Icons.trending_down,
                _priceDrops,
                (value) => setState(() => _priceDrops = value),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Notification Channels'),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildSwitchTile(
                'Email Notifications',
                'Receive updates via email',
                Icons.email_outlined,
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                'SMS Notifications',
                'Receive updates via SMS',
                Icons.sms_outlined,
                _smsNotifications,
                (value) => setState(() => _smsNotifications = value),
              ),
            ]),
            const SizedBox(height: 32),
            Text(
              'You can change these preferences at any time.',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
              textAlign: TextAlign.center,
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

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.5),
        activeThumbColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 70, color: Colors.grey[200]);
  }
}

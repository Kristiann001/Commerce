import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../profile/change_password_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  late bool _faceId;
  late bool _fingerprint;
  late bool _twoStep;

  @override
  void initState() {
    super.initState();
    _faceId = true;
    _fingerprint = false;
    _twoStep = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Biometric'),
          _buildToggleTile('Face ID', 'Use face recognition for authentication', _faceId, (value) {
            setState(() => _faceId = value);
          }),
          _buildToggleTile('Fingerprint', 'Use fingerprint for authentication', _fingerprint, (value) {
            setState(() => _fingerprint = value);
          }),
          const SizedBox(height: 24),
          _buildSectionHeader('Two-Factor Authentication'),
          _buildToggleTile('Two-Step Verification', 'Add an extra layer of security', _twoStep, (value) {
            setState(() => _twoStep = value);
          }),
          const SizedBox(height: 24),
          _buildActionTile(
            Icons.lock_outline, 
            'Change Password', 
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()))
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor),
      ),
    );
  }

  Widget _buildToggleTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        value: value,
        activeThumbColor: AppTheme.primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

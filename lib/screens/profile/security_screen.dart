import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _faceId = true;
  bool _fingerprint = false;
  bool _twoStep = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Biometrics'),
          _buildToggleTile(
            'Face ID', 
            'Use Face ID for quick login', 
            _faceId, 
            (v) => setState(() => _faceId = v)
          ),
          _buildToggleTile(
            'Fingerprint', 
            'Use Fingerprint for secure payments', 
            _fingerprint, 
            (v) => setState(() => _fingerprint = v)
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Authentication'),
          _buildToggleTile(
            'Two-Step Verification', 
            'Add an extra layer of security', 
            _twoStep, 
            (v) => setState(() => _twoStep = v)
          ),
          const SizedBox(height: 12),
          _buildActionTile(Icons.lock_outline, 'Change Password', () {}),
          _buildActionTile(Icons.devices_outlined, 'Recognized Devices', () {}),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Changes'),
          ),
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

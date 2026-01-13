import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Terms of Use',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    '1. Acceptance of Terms',
                    'By accessing or using the Shoplon application, you agree to be bound by these terms and conditions. If you do not agree, please refrain from using the service.'
                  ),
                  _buildSection(
                    '2. User Obligations',
                    'Users are responsible for maintaining the confidentiality of their accounts and passwords. Any unauthorized use must be reported immediately.'
                  ),
                  _buildSection(
                    '3. Privacy Policy',
                    'Your privacy is important to us. Our privacy policy explains how we collect, use, and protect your personal information.'
                  ),
                  _buildSection(
                    '4. Intellectual Property',
                    'All content, including logos, designs, and text, is the property of Shoplon and protected by copyright laws.'
                  ),
                  _buildSection(
                    '5. Limitation of Liability',
                    'Shoplon is not liable for any direct or indirect damages resulting from the use or inability to use the application.'
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      onChanged: (v) => setState(() => _isAgreed = v!),
                      activeColor: AppTheme.primaryColor,
                    ),
                    const Expanded(
                      child: Text(
                        'I agree to the Terms & Conditions and Privacy Policy',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAgreed ? () => Navigator.pop(context) : null,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

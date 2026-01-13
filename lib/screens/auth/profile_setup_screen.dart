import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../customer/main_layout.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String email;
  const ProfileSetupScreen({super.key, required this.email});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    if (_formKey.currentState!.validate()) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Simulate saving profile data
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Navigate directly to MainLayout (skip OTP)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Almost There!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Complete your profile to get started',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Avatar placeholder
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+254712345678',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio (Optional)',
                  hintText: 'Tell us about yourself',
                  prefixIcon: Icon(Icons.edit),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: _completeSetup,
                child: const Text('Complete Setup'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

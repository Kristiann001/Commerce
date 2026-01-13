import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import 'auth/profile_setup_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserRole _role = UserRole.customer;
  bool _isLoading = false;
  String? _errorMessage;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _errorMessage = "Passwords do not match");
        return;
      }
      
      setState(() { _isLoading = true; _errorMessage = null; });

      final authService = Provider.of<AuthService>(context, listen: false);
      String? error = await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        _role,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (error != null) {
            _errorMessage = error;
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSetupScreen(email: _emailController.text),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Slightly off-white background for contrast
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWideScreen ? 500 : double.infinity),
                child: isWideScreen
                    ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: _buildFormContent(),
                        ),
                      )
                    : _buildFormContent(), // No card on mobile, just content
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Create Account', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Join us today', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            validator: (v) => v!.isEmpty ? 'Name required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
            validator: (v) => v!.isEmpty ? 'Email required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
            validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline)),
            validator: (v) => v!.isEmpty ? 'Confirm password' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<UserRole>(
            // ignore: deprecated_member_use
            value: _role,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.badge_outlined)),
            onChanged: (UserRole? newValue) => setState(() => _role = newValue!),
            items: UserRole.values.map((UserRole role) {
              return DropdownMenuItem<UserRole>(
                value: role,
                child: Text(role == UserRole.admin ? 'Seller/Admin' : 'Customer'),
              );
            }).toList(),
          ),
          


          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13), textAlign: TextAlign.center),
            ),

          const SizedBox(height: 32),
          
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}

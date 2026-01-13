import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'providers/cart_provider.dart'; // Import CartProvider
import 'providers/wishlist_provider.dart'; // Import WishlistProvider
import 'providers/notification_provider.dart'; // Import NotificationProvider
import 'providers/language_provider.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/customer/main_layout.dart'; // Import MainLayout
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart'; // Import AppTheme

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<WishlistProvider>(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Ecommerce Access',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          } else {
            return FutureBuilder<UserModel?>(
              future: authService.getCurrentUser(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (userSnapshot.hasData && userSnapshot.data != null) {
                  final userModel = userSnapshot.data!;
                  if (userModel.role == UserRole.admin) {
                    return const AdminDashboard();
                  } else {
                    return const MainLayout(); // Use MainLayout for Customers
                  }
                }
                return const LoginScreen(); 
              },
            );
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

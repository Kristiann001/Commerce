import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Shoplon Ultra Palette
  static const Color primaryColor = Color(0xFF6C3EE8); // Vibrant Purple/Blue
  static const Color primaryVariant = Color(0xFF512DA8);
  static const Color secondaryColor = Color(0xFF1A1A1A); // Deep Charcoal
  static const Color accentColor = Color(0xFFFFB300); // Amber/Gold for contrast
  static const Color backgroundColor = Color(0xFFFBFBFE); // Very clean off-white
  static const Color surfaceColor = Colors.white;
  static const Color fieldColor = Color(0xFFF3F4F8); // Grey for input fields
  
  // Custom Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C3EE8), Color(0xFF512DA8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.bold, color: secondaryColor, letterSpacing: -1.0),
        displayMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: secondaryColor, letterSpacing: -0.5),
        displaySmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: secondaryColor),
        headlineMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: secondaryColor),
        titleLarge: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: secondaryColor),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: secondaryColor), // Switched to Outfit for modern look
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: secondaryColor.withValues(alpha: 0.8)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // Transparent for glass effect
        foregroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
        iconTheme: const IconThemeData(color: secondaryColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent, // For floating nav
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false, // Cleaner look
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // Slightly less rounded
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          elevation: 0, // Flat design for buttons is more modern in Shoplon
          shadowColor: primaryColor.withValues(alpha: 0.3),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: primaryColor, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
      useMaterial3: true,
    );
  }
}

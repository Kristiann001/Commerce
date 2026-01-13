import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'sw': return 'Swahili';
      case 'fr': return 'French';
      case 'es': return 'Spanish';
      case 'ar': return 'Arabic';
      case 'zh': return 'Chinese';
      default: return 'English';
    }
  }
}

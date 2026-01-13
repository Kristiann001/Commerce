import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'language_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _content = [
    OnboardingContent(
      title: 'Choose Your Style',
      description: 'Discover thousands of premium products tailored to your unique taste.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingContent(
      title: 'Easy Add to Cart',
      description: 'Add your favorites to the cart with a single tap and manage them easily.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    OnboardingContent(
      title: 'Secure Online Payment',
      description: 'Pay safely using M-Pesa, Credit Cards, or your digital wallet.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
    OnboardingContent(
      title: 'Real-time Tracking',
      description: 'Follow your package from our warehouse to your front door.',
      imagePath: 'assets/images/onboarding_4.png',
    ),
    OnboardingContent(
      title: 'Find Nearby Stores',
      description: 'Pick up your items or visit us in person at our physical locations.',
      imagePath: 'assets/images/onboarding_5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _finishOnboarding(),
                child: const Text('Skip', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) => setState(() => _currentPage = page),
                itemCount: _content.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _content[index].imagePath,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 60),
                        Text(
                          _content[index].title,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _content[index].description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _content.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == _content.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _currentPage == _content.length - 1 ? Icons.check : Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _currentPage == index ? AppTheme.primaryColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LanguageScreen()),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

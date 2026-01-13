import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

/// Simple Test Screen to verify UI rendering
/// This screen has hardcoded content to test if anything displays

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('UI Test Screen', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test 1: Basic Text
            const Text(
              '✅ Test 1: Basic Text',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            
            // Test 2: Colored Container
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text(
                '✅ Test 2: Red Container',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            
            // Test 3: AppTheme Colors
            Container(
              width: double.infinity,
              height: 100,
              color: AppTheme.primaryColor,
              alignment: Alignment.center,
              child: const Text(
                '✅ Test 3: Purple (Primary Color)',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            
            // Test 4: Google Fonts
            Text(
              '✅ Test 4: Google Fonts (Outfit)',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            
            // Test 5: Icon
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 40),
                SizedBox(width: 12),
                Text('✅ Test 5: Icons', style: TextStyle(fontSize: 18, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 20),
            
            // Test 6: Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button works!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('✅ Test 6: Click Me'),
            ),
            const SizedBox(height: 20),
            
            // Test 7: Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅ Test 7: Card Widget',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a card with shadow and padding.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Test 8: List
            const Text(
              '✅ Test 8: List Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              5,
              (index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                ),
                title: Text('List Item ${index + 1}', style: const TextStyle(color: Colors.black)),
                subtitle: Text('Subtitle for item ${index + 1}', style: TextStyle(color: Colors.grey[600])),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎉 All Tests Passed!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'If you can see this screen, the UI rendering is working correctly.',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

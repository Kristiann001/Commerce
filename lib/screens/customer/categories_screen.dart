import 'package:flutter/material.dart';
import 'filtered_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'icon': Icons.phone_android, 'label': 'Phones'},
    {'icon': Icons.laptop, 'label': 'Computing'},
    {'icon': Icons.checkroom, 'label': 'Fashion'},
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.sports_soccer, 'label': 'Sports'},
    {'icon': Icons.gamepad, 'label': 'Gaming'},
    {'icon': Icons.local_grocery_store, 'label': 'Grocery'},
    {'icon': Icons.health_and_safety, 'label': 'Health'},
    {'icon': Icons.baby_changing_station, 'label': 'Baby'},
    {'icon': Icons.more_horiz, 'label': 'Others'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
             child: Container(
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(8),
               ),
               child: const TextField(
                 decoration: InputDecoration(
                   hintText: 'Search categories',
                   prefixIcon: Icon(Icons.search, color: Colors.grey),
                   border: InputBorder.none,
                   contentPadding: EdgeInsets.all(12),
                 ),
               ),
             ),
          ),
        ),
      ),
      body: Row(
        children: [
          // Sidebar (Left)
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
               // Handle side navigation
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.star_border), selectedIcon: Icon(Icons.star), label: Text('Top')),
              NavigationRailDestination(icon: Icon(Icons.trending_up), label: Text('Trending')),
              NavigationRailDestination(icon: Icon(Icons.new_releases), label: Text('New')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Grid (Right)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns for better visibility
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilteredProductsScreen(category: _categories[index]['label'] as String),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_categories[index]['icon'] as IconData, size: 40, color: Theme.of(context).primaryColor),
                        const SizedBox(height: 12),
                        Text(_categories[index]['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

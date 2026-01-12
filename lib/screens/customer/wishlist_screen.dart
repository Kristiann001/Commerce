import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';
import 'product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: wishlist.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                   const SizedBox(height: 16),
                   const Text('Your wishlist is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: wishlist.items.length,
              itemBuilder: (context, index) {
                final product = wishlist.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Hero(
                       tag: 'product_${product.id}',
                       child: Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                             color: Colors.grey[200],
                             borderRadius: BorderRadius.circular(8),
                          ),
                          child: product.imageUrl.isNotEmpty
                              ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(product.imageUrl, fit: BoxFit.cover))
                              : const Icon(Icons.image),
                       ),
                    ),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('\$${product.price}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                       icon: const Icon(Icons.delete_outline, color: Colors.red),
                       onPressed: () => wishlist.toggleWishlist(product),
                    ),
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)));
                    },
                  ),
                );
              },
            ),
    );
  }
}

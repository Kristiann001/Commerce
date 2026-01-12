import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/mpesa_service.dart';
import '../../utils/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final mpesaService = MpesaService(); // Ideally inject or provider

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your Cart is Empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Container(
                            width: 50, height: 50,
                            color: Colors.grey[200],
                            child: item.product.imageUrl.isNotEmpty
                                ? Image.network(item.product.imageUrl, fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image))
                                : const Icon(Icons.image),
                          ),
                          title: Text(item.product.name),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}', 
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => cart.removeFromCart(item.product),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('\$${cart.totalAmount.toStringAsFixed(2)}', 
                               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showCheckoutDialog(context, cart.totalAmount, mpesaService, cart),
                          child: const Text('Checkout with M-Pesa'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showCheckoutDialog(BuildContext context, double amount, MpesaService mpesaService, CartProvider cart) {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total Amount: \$${amount.toStringAsFixed(2)}'),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'M-Pesa Phone Number (254...)'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              String? error = await mpesaService.startStkPush(phoneController.text, amount);
              if (context.mounted) {
                if (error == null) {
                  cart.clearCart(); // Clear cart on success
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Request Sent!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
                }
              }
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/mpesa_service.dart';
import '../../utils/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final mpesaService = MpesaService();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('My Cart', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: cart.items.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Dismissible(
                        key: Key('cart_${item.product.id}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => cart.removeFromCart(item.product),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                        child: _buildCartItem(context, item, cart),
                      );
                    },
                  ),
                ),
                _buildPriceSummary(context, cart, mpesaService),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to your cart to see them here.',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(item.product.category, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    ),
                    Row(
                      children: [
                        _qtyBtn(Icons.remove, () => cart.decrementQuantity(item.product)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        _qtyBtn(Icons.add, () => cart.addToCart(item.product)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context, CartProvider cart, MpesaService mpesaService) {
    final subtotal = cart.totalAmount;
    final shipping = 5.00;
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 120), // Extra bottom padding for floating nav
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _summaryRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _summaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCheckoutBottomSheet(context, total, mpesaService, cart),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('Checkout with M-Pesa'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppTheme.secondaryColor : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppTheme.primaryColor : AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }

  void _showCheckoutBottomSheet(BuildContext context, double amount, MpesaService mpesaService, CartProvider cart) {
    final phoneController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Checkout', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Confirm your payment of \$${amount.toStringAsFixed(2)} via M-Pesa.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 32),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'M-Pesa Number',
                hintText: '254...',
                prefixIcon: Icon(Icons.phone_iphone_rounded),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                   Navigator.pop(context);
                   // Show a dummy loading
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing M-Pesa Payment...')));
                   await Future.delayed(const Duration(seconds: 2));
                   
                  String? error = await mpesaService.startStkPush(phoneController.text, amount);
                  if (context.mounted) {
                    if (error == null) {
                      cart.clearCart();
                      _showSuccessDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
                    }
                  }
                },
                child: const Text('Confirm Payment'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text('Payment Successful!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your order has been placed successfully.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Home')),
          ],
        ),
      ),
    );
  }
}

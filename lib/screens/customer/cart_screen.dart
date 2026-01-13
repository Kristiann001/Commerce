import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import '../../services/mpesa_service.dart';
import '../../utils/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final mpesaService = MpesaService();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
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
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
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
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
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

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartProvider cart,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
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
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.category,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // KES Currency
                    Text(
                      'KES ${item.product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        _qtyBtn(
                          Icons.remove,
                          () => cart.decrementQuantity(item.product),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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

  Widget _buildPriceSummary(
    BuildContext context,
    CartProvider cart,
    MpesaService mpesaService,
  ) {
    final subtotal = cart.totalAmount;
    final shipping = 200.0; // KES shipping
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 120),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', 'KES ${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 12),
          _summaryRow('Shipping', 'KES ${shipping.toStringAsFixed(0)}'),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _summaryRow(
            'Total',
            'KES ${total.toStringAsFixed(0)}',
            isTotal: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  _showCheckoutBottomSheet(context, total, mpesaService, cart),
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

  void _showCheckoutBottomSheet(
    BuildContext context,
    double amount,
    MpesaService mpesaService,
    CartProvider cart,
  ) {
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Confirm your payment of KES ${amount.toStringAsFixed(0)} via M-Pesa.',
              style: TextStyle(color: Colors.grey[600]),
            ),
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
            FutureBuilder<UserModel?>(
              future: Provider.of<AuthService>(context, listen: false).getCurrentUser(),
              builder: (context, snapshot) {
                final isAdmin = snapshot.hasData && snapshot.data!.role == UserRole.admin;
                
                if (isAdmin) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Admins cannot make purchases.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final phone = phoneController.text.trim();
                      if (phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a phone number')),
                        );
                        return;
                      }
    
                      // Close bottom sheet first or handle loading state?
                      // User wants to "confirm number to finalize".
                      // We'll keep the bottom sheet open but show loading on the button.
                      
                      setState(() => _isLoading = true);
    
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing M-Pesa Payment...'), duration: Duration(seconds: 1)),
                      );
    
                      // Simulate M-Pesa delay
                      await Future.delayed(const Duration(seconds: 2));
    
                      // STK Push
                      String? error = await mpesaService.startStkPush(phone, amount);
    
                      if (!mounted) return;
    
                      if (error == null) {
                        try {
                          // ignore: use_build_context_synchronously
                          final authService = Provider.of<AuthService>(context, listen: false);
                          final firestoreService = FirestoreService();
                          final user = await authService.getCurrentUser();
    
                          if (user == null) {
                             throw Exception('User not logged in');
                          }
    
                          // Default Address
                          String shippingAddress = 'Nairobi, Kenya';
                          try {
                            final address = await firestoreService.getDefaultAddress(user.uid);
                            if (address != null) {
                              shippingAddress = '${address.address}, ${address.city}';
                            }
                          } catch (e) {
                            debugPrint('Error fetching address: $e');
                          }
    
                          // Create Order
                          final order = OrderModel(
                            id: '',
                            orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                            userId: user.uid,
                            items: cart.items.map((item) => OrderItem(
                              productId: item.product.id,
                              productName: item.product.name,
                              imageUrl: item.product.imageUrl,
                              price: item.product.price,
                              quantity: item.quantity,
                            )).toList(),
                            total: amount,
                            status: 'Processing',
                            shippingAddress: shippingAddress,
                            createdAt: DateTime.now(),
                          );
    
                          await firestoreService.createOrder(order);
    
                          if (!context.mounted) return;
    
                          // Notifications
                          final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
                          notificationProvider.addPaymentNotification(
                            amount,
                            cart.items.length == 1 ? cart.items.first.product.name : '${cart.items.length} items',
                          );
                          notificationProvider.addOrderNotification(order.orderId);
    
                          // Clear Cart & Success
                          cart.clearCart();
                          if (context.mounted) {
                            Navigator.pop(context); // Close Bottom Sheet
                            _showSuccessDialog(context, amount);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Order creation failed: $e')),
                            );
                          }
                        } finally {
                           if (mounted) setState(() => _isLoading = false);
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment Error: $error')),
                          );
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Pay with M-Pesa'),
                  ),
                );
              }
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }



  void _showSuccessDialog(BuildContext context, double amount) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'KES ${amount.toStringAsFixed(0)} paid successfully.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Check your notifications for details.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

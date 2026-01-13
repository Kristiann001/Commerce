import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.icon = Icons.notifications,
    this.iconColor = Colors.blue,
  });
}

class NotificationProvider extends ChangeNotifier {
  final List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;
  int get count => _notifications.length;
  bool get hasNotifications => _notifications.isNotEmpty;

  void addPaymentNotification(double amount, String productName) {
    _notifications.insert(0, NotificationItem(
      title: 'Payment Successful!',
      message: 'Your payment of KES ${amount.toStringAsFixed(0)} for $productName is complete.',
      time: DateTime.now(),
      icon: Icons.check_circle,
      iconColor: Colors.green,
    ));
    notifyListeners();
  }

  void addOrderNotification(String orderId) {
    _notifications.insert(0, NotificationItem(
      title: 'Order Confirmed',
      message: 'Your order #$orderId has been placed successfully.',
      time: DateTime.now(),
      icon: Icons.shopping_bag,
      iconColor: Colors.purple,
    ));
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  void removeAt(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }
}

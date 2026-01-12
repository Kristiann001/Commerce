import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MpesaService {
  
  final String _consumerKey = 'YOUR_CONSUMER_KEY';
  final String _consumerSecret = 'YOUR_CONSUMER_SECRET';
  final String _passkey = 'YOUR_PASSKEY';
  final String _shortcode = '174379'; // Test Shortcode
  final String _baseUrl = 'https://sandbox.safaricom.co.ke';

  Future<String?> getAccessToken() async {
    String credentials = base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/oauth/v1/generate?grant_type=client_credentials'),
        headers: {'Authorization': 'Basic $credentials'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      } else {
         return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> startStkPush(String phoneNumber, double amount) async {
    // Basic validation
    if(phoneNumber.isEmpty) return 'Phone number required';
    
    // Ensure 1 KES for testing if needed, or use amount
    int amountInt = amount.toInt(); 
    if (amountInt < 1) amountInt = 1;

    String? token = await getAccessToken();
    if (token == null) return 'Failed to authenticate with M-Pesa';

    String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String password = base64Encode(utf8.encode('$_shortcode$_passkey$timestamp'));

    final payload = {
      "BusinessShortCode": _shortcode,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerPayBillOnline",
      "Amount": amountInt,
      "PartyA": phoneNumber,
      "PartyB": _shortcode,
      "PhoneNumber": phoneNumber,
      "CallBackURL": "https://mydomain.com/path", // Needs valid URL for production
      "AccountReference": "EcommerceStore",
      "TransactionDesc": "Purchase"
    };

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/mpesa/stkpush/v1/processrequest'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data['ResponseCode'] == '0') {
          return null; // Success
        } else {
          return data['CustomerMessage'] ?? 'Payment failed';
        }
      } else {
        return data['errorMessage'] ?? 'Network error';
      }
    } catch (e) {
      return e.toString();
    }
  }
}

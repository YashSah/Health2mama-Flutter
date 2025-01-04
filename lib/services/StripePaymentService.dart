import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:health2mama/Utils/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripePaymentService {
  static Future<void> initialize() async {
    Stripe.publishableKey = Constants.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  static Future<bool> createPaymentIntent(int amount) async {
    try {
      final clientSecret = await _getClientSecret(amount);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your Merchant Name',
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      return true; // Payment successful
    } catch (e) {
      print('Error during payment: $e');
      return false; // Payment failed
    }
  }

  static Future<String> _getClientSecret(int amount) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${Constants.stripeSecretKey}'
      },
      body: {
        'amount': amount.toString(),
        'currency': 'usd', // Specify the currency here
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['client_secret'];
    } else {
      throw Exception('Failed to get client secret');
    }
  }
}


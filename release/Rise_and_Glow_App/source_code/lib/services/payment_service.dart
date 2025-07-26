import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:uuid/uuid.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  // Paytm Configuration (Use test/staging values for development)
  static const String _merchantId = "YOUR_MERCHANT_ID"; // Replace with your merchant ID
  static const String _merchantKey = "YOUR_MERCHANT_KEY"; // Replace with your merchant key
  static const String _website = "WEBSTAGING"; // Use "DEFAULT" for production
  static const String _callbackUrl = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID="; // Staging callback URL
  static const String _environment = "staging"; // Use "production" for live

  // Generate checksum for Paytm
  String _generateChecksum(Map<String, String> parameters, String merchantKey) {
    var sortedKeys = parameters.keys.toList()..sort();
    var queryString = sortedKeys.map((key) => '$key=${parameters[key]}').join('&');
    var checksumData = '$queryString|$merchantKey';
    var bytes = utf8.encode(checksumData);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate unique order ID
  String _generateOrderId() {
    const uuid = Uuid();
    return 'ORDER_${uuid.v4().substring(0, 8).toUpperCase()}';
  }

  // Initialize Paytm payment
  Future<Map<String, dynamic>> initiatePayment({
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? orderId,
  }) async {
    try {
      final String finalOrderId = orderId ?? _generateOrderId();
      
      // Prepare payment parameters
      Map<String, String> paytmParams = {
        "MID": _merchantId,
        "WEBSITE": _website,
        "CHANNEL_ID": "WAP",
        "INDUSTRY_TYPE_ID": "Retail",
        "ORDER_ID": finalOrderId,
        "CUST_ID": customerEmail,
        "TXN_AMOUNT": amount.toStringAsFixed(2),
        "CALLBACK_URL": "$_callbackUrl$finalOrderId",
        "EMAIL": customerEmail,
        "MOBILE_NO": customerPhone,
      };

      // Generate checksum
      String checksum = _generateChecksum(paytmParams, _merchantKey);
      paytmParams["CHECKSUMHASH"] = checksum;

      // Start Paytm transaction
      var response = await AllInOneSdk.startTransaction(
        _merchantId,
        finalOrderId,
        amount.toStringAsFixed(2),
        paytmParams["CHECKSUMHASH"]!,
        _callbackUrl,
        _environment == "staging",
        false, // restrictAppInvoke
        true,  // enableAssist
      );

      return {
        'success': true,
        'orderId': finalOrderId,
        'response': response,
        'message': 'Payment initiated successfully'
      };
    } catch (error) {
      return {
        'success': false,
        'error': error.toString(),
        'message': 'Failed to initiate payment'
      };
    }
  }

  // Verify payment status
  Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String txnId,
  }) async {
    try {
      // In a real app, you would call your backend API to verify the payment
      // This is just a mock implementation
      
      Map<String, String> verifyParams = {
        "MID": _merchantId,
        "ORDERID": orderId,
        "TXNID": txnId,
      };

      String checksum = _generateChecksum(verifyParams, _merchantKey);
      verifyParams["CHECKSUMHASH"] = checksum;

      // Mock verification response
      await Future.delayed(const Duration(seconds: 2));
      
      // In reality, you would make an HTTP request to Paytm's verification API
      return {
        'success': true,
        'status': 'TXN_SUCCESS',
        'message': 'Payment verified successfully',
        'orderId': orderId,
        'txnId': txnId,
      };
    } catch (error) {
      return {
        'success': false,
        'error': error.toString(),
        'message': 'Failed to verify payment'
      };
    }
  }

  // Handle payment response
  Map<String, dynamic> handlePaymentResponse(dynamic response) {
    try {
      if (response != null && response is Map) {
        String status = response['STATUS'] ?? '';
        String orderId = response['ORDERID'] ?? '';
        String txnId = response['TXNID'] ?? '';
        String txnAmount = response['TXNAMOUNT'] ?? '';
        String respCode = response['RESPCODE'] ?? '';
        String respMsg = response['RESPMSG'] ?? '';

        if (status == 'TXN_SUCCESS' && respCode == '01') {
          return {
            'success': true,
            'status': status,
            'orderId': orderId,
            'txnId': txnId,
            'amount': txnAmount,
            'message': 'Payment completed successfully'
          };
        } else {
          return {
            'success': false,
            'status': status,
            'orderId': orderId,
            'message': respMsg.isNotEmpty ? respMsg : 'Payment failed'
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Invalid payment response'
        };
      }
    } catch (error) {
      return {
        'success': false,
        'error': error.toString(),
        'message': 'Error processing payment response'
      };
    }
  }

  // Get payment methods available
  List<Map<String, dynamic>> getPaymentMethods() {
    return [
      {
        'id': 'paytm_wallet',
        'name': 'Paytm Wallet',
        'icon': '💳',
        'description': 'Pay using your Paytm wallet balance'
      },
      {
        'id': 'credit_card',
        'name': 'Credit Card',
        'icon': '💳',
        'description': 'Visa, MasterCard, American Express'
      },
      {
        'id': 'debit_card',
        'name': 'Debit Card',
        'icon': '💳',
        'description': 'All major bank debit cards'
      },
      {
        'id': 'net_banking',
        'name': 'Net Banking',
        'icon': '🏦',
        'description': 'All major banks supported'
      },
      {
        'id': 'upi',
        'name': 'UPI',
        'icon': '📱',
        'description': 'GooglePay, PhonePe, Paytm UPI'
      },
    ];
  }

  // Calculate payment processing fee (if any)
  double calculateProcessingFee(double amount) {
    // Usually 2-3% for payment gateway fees
    // For demo purposes, we'll use 2%
    return amount * 0.02;
  }

  // Get total amount including fees
  double getTotalAmount(double baseAmount) {
    double processingFee = calculateProcessingFee(baseAmount);
    return baseAmount + processingFee;
  }
}

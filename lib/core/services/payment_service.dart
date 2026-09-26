// import 'package:flutter/foundation.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../../data/models/responses/razorpay_order_response.dart';

// class PaymentService {
//   // 🔑 Razorpay Key constant inside PaymentService
//   static const String razorpayKeyId = 'rzp_test_NOROZZ';

//   final Razorpay _razorpay = Razorpay();

//   Function(PaymentSuccessResponse)? _onSuccessCallback;
//   Function(PaymentFailureResponse)? _onErrorCallback;
//   Function(ExternalWalletResponse)? _onExternalWalletCallback;

//   PaymentService() {
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void dispose() {
//     _razorpay.clear();
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     debugPrint(
//       "✅ Razorpay Payment Success: paymentId=${response.paymentId}, orderId=${response.orderId}",
//     );
//     _onSuccessCallback?.call(response);
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     debugPrint(
//       "❌ Razorpay Payment Error: code=${response.code}, message=${response.message}",
//     );
//     _onErrorCallback?.call(response);
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     debugPrint("👛 Razorpay External Wallet: ${response.walletName}");
//     _onExternalWalletCallback?.call(response);
//   }

//   /// Open Razorpay Checkout SDK Interface
//   void openCheckout({
//     RazorpayOrderData? orderData,
//     num? amount,
//     String? orderId,
//     String? userPhone,
//     String? userName,
//     String? title,
//     String? description,
//     required Function(PaymentSuccessResponse) onSuccess,
//     required Function(PaymentFailureResponse) onError,
//     Function(ExternalWalletResponse)? onExternalWallet,
//   }) {
//     _onSuccessCallback = onSuccess;
//     _onErrorCallback = onError;
//     _onExternalWalletCallback = onExternalWallet;

//     // Use Key from orderData if backend returns it, else default to razorpayKeyId constant inside PaymentService
//     final String key = (orderData?.keyId != null && orderData!.keyId!.isNotEmpty)
//         ? orderData.keyId!
//         : razorpayKeyId;

//     final num finalAmount = orderData?.amount ?? ((amount ?? 0) * 100);
//     final String finalOrderId = orderData?.orderId ?? orderId ?? 'order_${DateTime.now().millisecondsSinceEpoch}';
//     final String phone = orderData?.user?.phone ?? userPhone ?? '';
//     final String name = orderData?.user?.name ?? userName ?? 'NOROZZ Customer';

//     final options = {
//       'key': key,
//       'amount': finalAmount,
//       'name': title ?? 'NOROZZ',
//       'order_id': finalOrderId,
//       'description': description ?? 'Payment',
//       'timeout': 180,
//       'prefill': {
//         'contact': phone,
//         'name': name,
//       },
//       'theme': {'color': '#16A34A'},
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint("Error launching Razorpay Checkout SDK: $e");
//     }
//   }
// }

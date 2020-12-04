import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:meta/meta.dart';
import 'package:payment_service/src/payment_status.dart';
import 'payment.dart';

class PayHerePayment implements Payment {
  PayHerePayment({
    @required this.userId,
    @required this.name,
    @required this.email,
  }) {
    this.paymentObject = {
      "sandbox": true,
      "merchant_id": "1216113",
      "merchant_secret": "4eVLjfKaquK8gdw1hsdvcJ48Xv2rugSg98bStsAdBtFC",
      // "notify_url": "http://sample.com/notify",
      "order_id": "organic_nom1",
      "items": "Hello from Flutter!",
      "amount": "50.00",
      "currency": "LKR",
      "first_name": name,
      "last_name": "Perera",
      "email": email,
      "phone": "0771234567",
      "address": "No.1, Galle Road",
      "city": "Colombo",
      "country": "Sri Lanka",
      "delivery_address": "No. 46, Galle road, Kalutara South",
      "delivery_city": "Kalutara",
      "delivery_country": "Sri Lanka",
      "custom_1": userId,
      "custom_2": ""
    };
  }

  final userId;
  final name;
  final email;
  var paymentObject;

  @override
  Future<PaymentStatus> pay() async {
    PayHere.startPayment(
      paymentObject,
      (paymentId) {
        print("One Time Payment Success. Payment Id: $paymentId");
        return PaymentStatus.Completed;
      },
      (error) {
        print("One Time Payment Failed. Error: $error");
        return PaymentStatus.Failed;
      },
      () {
        print("One Time Payment Dismissed");
        return PaymentStatus.Canceled;
      },
    );
    return PaymentStatus.Unknown;
  }
}

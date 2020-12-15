import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:meta/meta.dart';
import 'package:payment_service/src/payment_status.dart';
import 'payment.dart';

class PayHerePayment implements Payment {
  PayHerePayment({
    @required this.userId,
    @required this.name,
    @required this.email,
    this.onSuccess,
    this.onError,
    this.onDismissed,
  }) {
    this.paymentObject = {
      "sandbox": true,
      "merchant_id": "1216113",
      "merchant_secret": "4eVLjfKaquK8gdw1hsdvcJ48Xv2rugSg98bStsAdBtFC",
      "notify_url": "http://sample.com/notify",
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

  PayHerePayment.purchaseChecker(this.userId,
      {this.email = "",
      this.name = "",
      this.onSuccess,
      this.onError,
      this.onDismissed});

  final userId;
  final name;
  final email;
  var paymentObject;

  final Function(String paymentId) onSuccess;
  final Function(String error) onError;
  final Function onDismissed;

  @override
  PaymentStatus pay() {
    PaymentStatus status = PaymentStatus.Pending;
    PayHere.startPayment(
      paymentObject,
      (paymentId) => onSuccess(paymentId),
      (error) => onError(error),
      onDismissed(),
    );
    print("Payment Cycle done");
    return status;
  }
}

// import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
// import 'package:meta/meta.dart';
// import 'payment.dart';

// class PayHerePay implements Payment {
//   PayHerePay({
//     @required this.userId,
//     @required this.name,
//     @required this.email,
//   }) {
//     this.paymentObject = {
//       "sandbox": true,
//       "merchant_id": "1216113",
//       "merchant_secret": "4eVLjfKaquK8gdw1hsdvcJ48Xv2rugSg98bStsAdBtFC",
//       "notify_url": "http://sample.com/notify",
//       "order_id": "organic_nom",
//       "items": "Hello from Flutter!",
//       "amount": "50.00",
//       "currency": "LKR",
//       "first_name": name,
//       "last_name": "Perera",
//       "email": email,
//       "phone": "0771234567",
//       "address": "No.1, Galle Road",
//       "city": "Colombo",
//       "country": "Sri Lanka",
//       "delivery_address": "No. 46, Galle road, Kalutara South",
//       "delivery_city": "Kalutara",
//       "delivery_country": "Sri Lanka",
//       "custom_1": userId,
//       "custom_2": ""
//     };
//   }

//   final userId;
//   final name;
//   final email;
//   var paymentObject;

//   @override
//   pay() {
//     PayHere.startPayment(paymentObject, (paymentId) {
//       print("One Time Payment Success. Payment Id: $paymentId");
//     }, (error) {
//       print("One Time Payment Failed. Error: $error");
//     }, () {
//       print("One Time Payment Dismissed");
//     });
//   }
// }

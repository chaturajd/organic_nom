import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:organicnom/app/modules/locked_item/controllers/locked_item_controller.dart';
import 'package:payment_service/payment_service.dart';

class LockedItemView extends GetView<LockedItemController> {
  final appBar = AppBar(
    backgroundColor: Colors.white,
    leading: BackButton(
      color: Colors.black,
    ),
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    LockedStatus status = Get.arguments;
    if (status == LockedStatus.NotPaid) {
      return Scaffold(
        appBar: appBar,
        body: Center(
          child: Column(
            children: [
              FlatButton(
                onPressed: () async {
                  final user = Get.find<AuthController>().user.value;
                  final ph = PayHerePayment(
                      email: user.email, name: user.name, userId: user.id);
                  final result = await ph.pay();

                  switch (result) {
                    case PaymentStatus.Canceled:
                      Get.snackbar("Canceled", "Payment Canceled");
                      break;
                    case PaymentStatus.Failed:
                      Get.snackbar("Failed", "Payment failed");
                      break;
                    case PaymentStatus.Completed:
                      Get.snackbar("Thank you", "Succesfull");
                      break;
                    default:
                      print("payment status unknown");
                  }
                },
                child: Text("Buy"),
              )
            ],
          ),
        ),
      );
    } else if (status == LockedStatus.Incompleted) {
      return Scaffold(
        appBar: appBar,
        body: Center(
          child: FlatButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                  "You should complete previous exercises to unlock this")),
        ),
      );
    }
    return Scaffold(body: Center(child: Text("Something is wrong..."),),);
  }
}

import 'package:data_service/data_service.dart';
import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:payment_service/payment_service.dart';

class LockedItemController extends GetxController {
  Rx<PaymentStatus> status = PaymentStatus.Initial.obs;

  @override
  void onClose() {}

  void clearCachedPaymentDetails() async {
    DataService ds = DataService();
    await ds.clearCachedPurchaseDetails();
  }

  void _onSuccess(String paymentId) {
    Get.back();
    Get.snackbar("Thank you", "Thank you for purchasing",duration: Duration(seconds: 5));
    print("Locked Item Controller::: Payment Succes :: $paymentId");
    status = PaymentStatus.Success.obs;
  }

  void _onError(error) {
    print("Locked Item Controller :::And Error occurred  $error");
  }

  void _onDismiss() {
    print("User dismissed payment dialog");
    // Get.back();
  }

  void startPayment() async {
    clearCachedPaymentDetails();
    final user = Get.find<AuthController>().user.value;
    final ph = PayHerePayment(
      email: user.email,
      name: user.name,
      userId: user.id,
      onSuccess: _onSuccess,
      onDismissed: _onDismiss,
      onError: _onError,
    );
    status = ph.pay().obs;

    print("Payment status received ::  ${status.value.toString()}");
  }
}

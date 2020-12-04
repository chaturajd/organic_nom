import 'package:get/get.dart';
import 'package:organicnom/app/controllers/controllers/auth_controller.dart';
import 'package:payment_service/payment_service.dart';

class PaymentController extends GetxController {
  var payment;
  var paymentStatus = PaymentStatus.Pending.obs;

  @override
  void onInit() {
    final _authController = Get.find<AuthController>();
    payment = PayHerePayment(
      userId: _authController.user.value.id,
      name: _authController.user.value.name,
      email: _authController.user.value.email,
    );
    super.onInit();
  }

  void pay() async {
    PaymentStatus result = await payment.pay();
    switch (result) {
      case PaymentStatus.Canceled:
        paymentStatus = PaymentStatus.Canceled.obs;
        break;
      case PaymentStatus.Failed:
        paymentStatus = PaymentStatus.Canceled.obs;
        break;
      case PaymentStatus.Completed:
        paymentStatus = PaymentStatus.Completed.obs;
        break;

      default:
        paymentStatus = PaymentStatus.Pending.obs;
    }
  }
}

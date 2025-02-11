import 'package:data_service/data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organicnom/app/modules/locked_item/controllers/locked_item_controller.dart';

class LockedItemView extends GetView<LockedItemController> {
  LockedItemView() {
    Get.put(LockedItemController());
  }

  final appBar = AppBar(
    leading: BackButton(),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: Colors.white54,
              ),
              SizedBox(
                height: 48,
              ),
              FlatButton(
                onPressed: () {
                  controller.startPayment();
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.orange, boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      offset: Offset(2, 6),
                      color: Colors.black12,
                    )
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    child: Text(
                      "Unlock",
                      style: GoogleFonts.overpass(
                          fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        elevation: 0,
      ),
      body: Center(
        child: Text("Sorry this item is locked "),
      ),
    );
  }
}

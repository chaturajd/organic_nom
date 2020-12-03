import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItemView extends GetView {
  final int index;
  final String title;
  final String description;
  final String videoUrl;
  final bool isCompleted;
  final bool isActive;
  final Function onClick;

  ListItemView({
    this.index = 0,
    this.title,
    this.description,
    this.videoUrl = "",
    this.isCompleted,
    this.isActive = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isCompleted || isActive ? 1 : 0.4,
      child: InkWell(
        // onTap: isCompleted || isActive ? () => onClick() : null,
        onTap: () {
          Get.toNamed('/lessons/lesson',preventDuplicates: true,arguments: index);
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Container(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            (index + 1).toString(),
                            style: GoogleFonts.overpass(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.overpass(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    BoxShadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 20,
                                        color: Colors.black38)
                                  ],
                                ),
                              ),
                              Text(
                                description,
                                style: GoogleFonts.overpass(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: isActive
                          ? statusIcon(
                              iconData: Icons.arrow_right,
                              color: Colors.green,
                            )
                          : isCompleted
                              ? statusIcon(
                                  iconData: Icons.done,
                                  color: Colors.amber,
                                )
                              : statusIcon(
                                  iconData: Icons.lock,
                                  color: Colors.grey,
                                ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 25,
                endIndent: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack statusIcon({@required IconData iconData, @required Color color}) {
    return Stack(children: [
      Positioned(
        child: Icon(
          iconData,
          color: Colors.black12,
        ),
        left: 1,
        top: 2,
      ),
      Icon(
        iconData,
        color: color,
      )
    ]);
  }
}

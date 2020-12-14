import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'package:rupa_box/src/fullscreen_rupa_box.dart';

class RupaBox extends StatefulWidget {
  RupaBox(this.url,{Key key,this.controller,this.playPosition = 0 }) : super(key: key);

  final String url;
  final int playPosition;
  final VlcPlayerController controller;

  @override
  _RupaBoxState createState() => _RupaBoxState();
}

class _RupaBoxState extends State<RupaBox> {
  VlcPlayerController vlcPlayerController;
  bool isPlaying = false;
  double sliderValue = 0.0;
  double currentPlayerTime = 0;
  double volume = 50;
  String position = "";
  String duration = "";
  bool isBuffering = true;
  bool isOverlayShown = false;

  double volumeGestureStartPos;
  double volumeGesturePos;
  double volumeGestureSensitivity = 0.001;

  @override
  void initState() {
    vlcPlayerController = VlcPlayerController(onInit: () {
      vlcPlayerController.setTime(Duration(seconds: 60).inMilliseconds);
      vlcPlayerController.play();
      print("Rupa Box :: Initializing");
    },
    );

    vlcPlayerController.addListener(
      () {
        if (!this.mounted) return;
        if (vlcPlayerController.initialized) {
          var oPosition = vlcPlayerController.position;
          var oDuration = vlcPlayerController.duration;

          if (oDuration.inHours == 0) {
            var strPosition = oPosition.toString().split('.')[0];
            var strDuration = oDuration.toString().split('.')[0];

            position =
                "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
            duration =
                "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
          } else {
            position = oPosition.toString().split('.')[0];
            duration = oDuration.toString().split('.')[0];
          }

          // vlcPlayerController.setTime(widget.playPosition);
          sliderValue = vlcPlayerController.position.inSeconds.toDouble();

          switch (vlcPlayerController.playingState) {
            case PlayingState.PAUSED:
              setState(() {
                isBuffering = false;
              });
              break;
            case PlayingState.STOPPED:
              setState(() {
                isPlaying = false;
                isBuffering = false;
              });
              break;
            case PlayingState.BUFFERING:
              setState(() {
                isBuffering = true;
              });
              break;
            case PlayingState.ERROR:
              setState(() {});
              print("rupa box encountered an error");
              break;
            case PlayingState.PLAYING:
              setState(() {
                isPlaying = true;
                isBuffering = false;
              });
              break;
          }
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 300,
      child: Stack(
        children: [
          Center(
            child: VlcPlayer(

              aspectRatio: 16 / 9,
              url: widget.url,
              controller: vlcPlayerController,
              options: [
                '--quiet',
              ],
              hwAcc: HwAcc.DISABLED,
              placeholder: Container(
                   child: Center(child: Text("Loading ... "))
                  //  Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [CircularProgressIndicator()],
                  // ),
                  ),
            ),
          ),
          Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isOverlayShown =true;
                });
                Future.delayed(Duration(seconds: 5),(){
                  setState(() {
                    isOverlayShown=false;
                  });
                });
                if (vlcPlayerController.playingState == PlayingState.PLAYING) {
                  vlcPlayerController.pause();
                } else if (vlcPlayerController.playingState == PlayingState.PAUSED) {
                  vlcPlayerController.play();
                }
              },
              child:isOverlayShown ? Center(
                child: Icon(
                  Icons.play_arrow,
                ),
              ) : Container(),
            ),
          ),
          IconButton(icon: Icon(Icons.fullscreen), onPressed: ()async{
            setState(() {
              vlcPlayerController.stop();
            });
            var watchDetails = Navigator.push(context, MaterialPageRoute(builder: (context){
              return FullScreenRupaBox(widget.url,playPosition: vlcPlayerController.position.inMilliseconds,);
            }));
            vlcPlayerController.dispose();
            await watchDetails;
            // if(w)
            
          })
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Builder(builder: (context) {
  //     return Container(
  //       padding: EdgeInsets.all(8),
  //       child: Stack(
  //         children: [
  //           SizedBox(
  //             height: 300,
  //             child: VlcPlayer(
  //               aspectRatio: 16 / 9,
  //               url: widget.url,
  //               controller: vlcPlayerController,
  //               options: [
  //                 '--quiet',
  //               ],
  //               hwAcc: HwAcc.DISABLED,
  //               placeholder: Container(
  //                   height: 300,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [CircularProgressIndicator()],
  //                   )),
  //             ),
  //           ),
  //           Container(
  //             child: Column(
  //               children: [
  //                 Container(
  //                   color: Colors.red,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       GestureDetector(
  //                         // dragStartBehavior: ,
  //                         onTap: () {
  //                           setState(() {
  //                             isControllerShown = true;
  //                           });
  //                         },
  //                         onDoubleTap: () {
  //                           setState(() {
  //                             vlcPlayerController.pause();
  //                           });
  //                         },
  //                         onVerticalDragStart: (DragStartDetails details) {
  //                           setState(() {
  //                             volumeGestureStartPos = details.globalPosition.dy;
  //                           });
  //                         },
  //                         onVerticalDragUpdate:
  //                             (DragUpdateDetails details) async {
  //                           volumeGesturePos = details.globalPosition.dy;
  //                           double distance =
  //                               volumeGestureStartPos - volumeGesturePos;

  //                           double volumeChange =
  //                               distance * volumeGestureSensitivity;

  //                           int currentVol =
  //                               await vlcPlayerController.getVolume();

  //                           setState(() {
  //                             vlcPlayerController
  //                                 .setVolume(currentVol + volumeChange.toInt());
  //                           });
  //                           print("Volume changed ${await vlcPlayerController.getVolume()}");
  //                         },
  //                         onVerticalDragEnd: (DragEndDetails details) {
  //                           setState(() {
  //                             volumeGesturePos = 0;
  //                             volumeGestureStartPos = 0;
  //                           });
  //                         },
  //                       ),
  //                       // GestureDetector(),
  //                     ],
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Flexible(
  //                         flex: 1,
  //                         child: FlatButton(
  //                           onPressed: () {},
  //                           child: isPlaying
  //                               ? Icon(Icons.pause_circle_filled_outlined)
  //                               : Icon(Icons.play_circle_fill_outlined),
  //                         ),
  //                       ),
  //                       Flexible(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           mainAxisSize: MainAxisSize.max,
  //                           children: [
  //                             Text(position),
  //                             Expanded(
  //                               child: Slider(
  //                                 activeColor: Colors.red,
  //                                 value: sliderValue,
  //                                 min: 0.0,
  //                                 max: vlcPlayerController.duration == null
  //                                     ? 1.0
  //                                     : vlcPlayerController.duration.inSeconds
  //                                         .toDouble(),
  //                                 onChanged: (progress) {
  //                                   setState(() {
  //                                     sliderValue = progress.floor().toDouble();
  //                                   });
  //                                   vlcPlayerController
  //                                       .setTime(sliderValue.toInt() * 1000);
  //                                 },
  //                               ),
  //                             ),
  //                             Text(duration),
  //                           ],
  //                         ),
  //                         flex: 3,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'dart:typed_data';

// class RupaBox extends StatefulWidget {
//   RupaBox({Key key, this.url}) : super(key: key);

//   final String url;

//   @override
//   _RupaBoxState createState() => _RupaBoxState();
// }

// class _RupaBoxState extends State<RupaBox> {
//   VlcPlayerController vlcPlayerController;
//   bool isPlaying;
//   double sliderValue = 0.0;
//   double currentPlayerTime = 0;
//   double volume = 50;
//   String position = "";
//   String duration = "";
//   bool isBuffering = true;

//   @override
//   void initState() {
//     vlcPlayerController = VlcPlayerController(onInit: () {
//       vlcPlayerController.play();
//     });

//     vlcPlayerController.addListener(
//       () {
//         if (!this.mounted) return;
//         if (vlcPlayerController.initialized) {
//           var oPosition = vlcPlayerController.position;
//           var oDuration = vlcPlayerController.duration;

//           if (oDuration.inHours == 0) {
//             var strPosition = oPosition.toString().split('.')[0];
//             var strDuration = oDuration.toString().split('.')[0];

//             position =
//                 "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
//             duration =
//                 "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
//           } else {
//             position = oPosition.toString().split('.')[0];
//             duration = oDuration.toString().split('.')[0];
//           }

//           sliderValue = vlcPlayerController.position.inSeconds.toDouble();

//           switch (vlcPlayerController.playingState) {
//             case PlayingState.PAUSED:
//               setState(() {
//                 isBuffering = false;
//               });
//               break;
//             case PlayingState.STOPPED:
//               setState(() {
//                 isPlaying = false;
//                 isBuffering = false;
//               });
//               break;
//             case PlayingState.BUFFERING:
//               setState(() {
//                 isBuffering = true;
//               });
//               break;
//             case PlayingState.ERROR:
//               setState(() {});
//               print("rupa box encountered an error");
//               break;
//             case PlayingState.PLAYING:
//               setState(() {
//                 isPlaying = true;
//                 isBuffering = false;
//               });
//               break;
//           }
//         }
//       },
//     );

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       return Container(
//         padding: EdgeInsets.all(8),
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//             SizedBox(
//               height: 300,
//               child: VlcPlayer(
//                 aspectRatio: 16 / 9,
//                 url: widget.url,
//                 controller: vlcPlayerController,
//                 options: [
//                   '--quiet',
//                 ],
//                 hwAcc: HwAcc.DISABLED,
//                 placeholder: Container(
//                     height: 300,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [CircularProgressIndicator()],
//                     )),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Flexible(
//                   flex: 1,
//                   child: FlatButton(
//                     onPressed: () {},
//                     child: isPlaying
//                         ? Icon(Icons.pause_circle_filled_outlined)
//                         : Icon(Icons.play_circle_fill_outlined),
//                   ),
//                 ),
//                 Flexible(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Text(position),
//                         Expanded(
//                           child: Slider(
//                             activeColor: Colors.red,
//                             value: sliderValue,
//                             min: 0.0,
//                             max: vlcPlayerController.duration == null
//                                 ? 1.0
//                                 : vlcPlayerController.duration.inSeconds
//                                     .toDouble(),
//                             onChanged: (progress) {
//                               setState(() {
//                                 sliderValue = progress.floor().toDouble();
//                               });
//                               vlcPlayerController
//                                   .setTime(sliderValue.toInt() * 1000);
//                             },
//                           ),
//                         ),
//                         Text(duration),
//                       ],
//                     ),
//                     flex: 3)
//               ],
//             )
//           ],
//         ),
//       );
//     });
//   }
// }

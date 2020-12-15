import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'package:rupa_box/src/fullscreen_rupa_box.dart';

class RupaBox extends StatefulWidget {
  RupaBox(this.url,
      {Key key,
      this.controller,
      this.playPosition = 0,
      this.showFullscreenSwitch = true})
      : super(key: key);

  final VlcPlayerController controller;
  final double playPosition;
  final bool showFullscreenSwitch;
  final String url;

  @override
  _RupaBoxState createState() => _RupaBoxState();
}

class _RupaBoxState extends State<RupaBox> {
  double currentPlayerTime = 0;
  String duration = "";
  bool isBuffering = true;
  bool isOverlayShown = false;
  bool isPlaying = false;
  String position = "";
  double sliderValue = 0.0;
  VlcPlayerController vlcPlayerController;
  double volume = 50;
  double volumeGesturePos;
  double volumeGestureSensitivity = 0.001;
  double volumeGestureStartPos;

  @override
  void initState() {
    vlcPlayerController = VlcPlayerController(
      onInit: () {
        // vlcPlayerController.setTime(widget.playPosition);
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
          // sliderValue = vlcPlayerController.position.inSeconds.toDouble();
          sliderValue = widget.playPosition.toDouble();

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
              print("BUFFERRINGGGGGG");
              setState(() {
                isBuffering = true;
              });
              break;
            case PlayingState.ERROR:
              print("EROORRRRRRRRRRRRR");
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

  void playOrPauseVideo() {
    print("Play or pause video");
    if (vlcPlayerController.playingState == PlayingState.PLAYING) {
      vlcPlayerController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      vlcPlayerController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget seekBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          child: IconButton(
              icon: isPlaying
                  ? Icon(Icons.pause_circle_outline)
                  : Icon(Icons.play_circle_outline),
              onPressed: () {
                playOrPauseVideo();
              }),
        ),
        Flexible(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(position),
              Expanded(
                child: Slider(
                  activeColor: Colors.red,
                  value: sliderValue,
                  min: 0.0,
                  max: vlcPlayerController.duration == null
                      ? 1.0
                      : vlcPlayerController.duration.inSeconds.toDouble(),
                  onChanged: (progress) {
                    setState(() {
                      sliderValue = progress.floor().toDouble();
                    });
                    //convert to Milliseconds since VLC requires MS to set time
                    vlcPlayerController.setTime(sliderValue.toInt() * 1000);
                  },
                ),
              ),
              Text(duration),
            ],
          ),
        ),
      ],
    );

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
              placeholder: Container(child: Center(child: Text("Loading ... "))
                  //  Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [CircularProgressIndicator()],
                  // ),
                  ),
            ),
          ),
          
          isBuffering
              ? Center(
                  child: isBuffering
                      ? CircularProgressIndicator()
                      : Icon(
                          Icons.play_arrow,
                        ),
                )
              : Container(),

          Container(
            height: double.infinity,
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: seekBar,
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   color: Colors.transparent,
          //   height: double.infinity,
          //   width: double.infinity,
          //   child: GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         isOverlayShown = true;
          //       });
          //       Future.delayed(Duration(seconds: 5), () {
          //         setState(() {
          //           isOverlayShown = false;
          //         });
          //       });
          //       if (vlcPlayerController.playingState == PlayingState.PLAYING) {
          //         vlcPlayerController.pause();
          //       } else if (vlcPlayerController.playingState ==
          //           PlayingState.PAUSED) {
          //         vlcPlayerController.play();
          //       }
          //     },
          //     child: Center(
          //       child: isBuffering
          //           ? CircularProgressIndicator()
          //           : Icon(
          //               Icons.play_arrow,
          //             ),
          //     ),
          //   ),
          // ),
          widget.showFullscreenSwitch
              ? IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () async {
                    setState(() {
                      vlcPlayerController.stop();
                    });
                    var watchDetails = Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FullScreenRupaBox(
                        widget.url,
                        playPosition: vlcPlayerController
                            .position.inMilliseconds
                            .toDouble(),
                      );
                    }));
                    // vlcPlayerController.dispose();
                    await watchDetails;
                    // if(w)
                  })
              : Container(),
        ],
      ),
    );
  }
}

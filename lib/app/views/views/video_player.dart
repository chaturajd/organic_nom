import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer(this.url, {Key key}) : super(key: key);
  final url;
  @override
  _VideoPlayerState createState() => _VideoPlayerState(); 
}

class _VideoPlayerState extends State<VideoPlayer> {
  BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      widget.url,
    );
    _controller = BetterPlayerController(BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: _controller,
      ),
    );
  }
}

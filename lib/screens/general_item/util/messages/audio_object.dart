import 'dart:async';
import 'dart:math';
import 'dart:io' show Platform;

import 'package:audioplayers/audioplayers.dart';
import 'package:youplay/actions/run_actions.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/general_item/audio_object.dart';
import 'package:youplay/models/general_item/video_object.dart';
import 'package:youplay/screens/general_item/general_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../localizations.dart';
import 'components/button_text_style.dart';
import 'components/next_button.dart';
import 'generic_message.dart';
import 'dart:math';
class AudioObjectGeneralItemScreen extends StatefulWidget {
  AudioObjectGeneralItem item;
  GeneralItemViewModel giViewModel;

  AudioObjectGeneralItemScreen({this.item, this.giViewModel, Key key}) : super(key: key) {
    _AudioObjectGeneralItemScreenState().updateController();
  }

  @override
  _AudioObjectGeneralItemScreenState createState() => _AudioObjectGeneralItemScreenState();
}

class _AudioObjectGeneralItemScreenState extends State<AudioObjectGeneralItemScreen> {
  // VideoPlayerController _controller;
  double _position = 0;
  double _maxposition = 10;
  bool showControls = true;
  bool isFinished = false;
  bool completeActionSent = false;

  AudioPlayer audioPlayer;
  AudioPlayerState status = AudioPlayerState.STOPPED;

  _AudioObjectGeneralItemScreenState();

  void updateController() {}

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = true;
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        print ('state change $s');
        this.status = s;
        if (s == AudioPlayerState.COMPLETED) {
          this._position = this._maxposition;
          this.isFinished = true;
        }
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) async {
      int duration = await audioPlayer.getDuration();
      _maxposition = duration.toDouble();
      setState(() {

        _maxposition = duration.toDouble();
        _position = min(p.inMilliseconds.roundToDouble(), _maxposition);
      });
    });
    // this.play();
  }

  play() async {
    String unencPath = widget.item.fileReferences['audio'].replaceFirst('//', '/');
    print('https://storage.googleapis.com/${AppConfig().projectID}.appspot.com${unencPath}');
    int result = await audioPlayer
        .play('https://storage.googleapis.com/${AppConfig().projectID}.appspot.com${unencPath}');
    print("result is $result");
  }


  @override
  Widget build(BuildContext context) {

    return GeneralItemWidget(
        item: this.widget.item,
        giViewModel: this.widget.giViewModel,
        body: Container(
            constraints: const BoxConstraints.expand(), child: buildVideoPlayer(context)));
  }

  Widget buildVideoPlayer(BuildContext context) {
    Widget videoPlayer = GestureDetector(
      onTap: () {
        setState(() {
          print('tap');
          showControls = !showControls;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[],
      ),
    );
    if (isFinished) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 1080 * 1920,
//        width: 1080/3,
//        height: 1920/3,
          child: addContinueTo(videoPlayer, context),
        ),
      );

//      return showContinue(videoPlayer, context);
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 1080 * 1920,
//        width: 1080/3,
//        height: 1920/3,
        child: showControls ? addControlsTo(videoPlayer, context) : videoPlayer,
      ),
    );
//    return ;
  }

  Widget addControlsTo(Widget videoPlayer, BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 0.8),
      children: [
        addPlayButtonTo(videoPlayer, context),
        Opacity(
            opacity: 0.9,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Slider(
                        activeColor: widget.giViewModel.getPrimaryColor(),
                        value: _position,
                        max: _maxposition,
                        onChanged: (double val) {
                          // _controller
                          //     .seekTo(Duration(milliseconds: val.floor()));
                          audioPlayer.seek(Duration(milliseconds: val.floor()));
                        },
                        onChangeEnd: (val) {})
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget addContinueTo(Widget videoPlayer, BuildContext context) {
    // RaisedButton button = RaisedButton(
    //   color: widget.giViewModel.getPrimaryColor(),
    //   splashColor: Colors.red,
    //   child: Text(
    //     AppLocalizations.of(context).translate('screen.next'),
    //     style: buttonTextStyle,
    //   ),
    //   onPressed: () {
    //     if (!widget.giViewModel.continueToNextItem(context)) {
    //       new Future.delayed(const Duration(milliseconds: 200), () {
    //         widget.giViewModel.continueToNextItem(context);
    //       });
    //     }
    //   },
    // );

    print(widget.item.description);

    return Stack(
      alignment: const Alignment(0.8, 0.7),
      children: [
        videoPlayer,
        Positioned(
            left: 46,
            right: 46,
            bottom: 46,
            child: Opacity(
              opacity: 1.0,
              child: NextButton(
                  buttonText: widget.item.description != "" ? widget.item.description : AppLocalizations.of(context).translate('screen.proceed'),
                  overridePrimaryColor: widget.giViewModel.getPrimaryColor(),
                  giViewModel: widget.giViewModel),
            )),
      ],
    );
  }

//  Widget showContinue(Widget videoPlayer, BuildContext context) {
//    RaisedButton button = RaisedButton(
//      color: Theme
//          .of(context)
//          .accentColor,
//      splashColor: Colors.red,
//      child: Text(
//        'VERDER',
//        style: TextStyle(color: Colors.white.withOpacity(0.8)),
//      ),
//      onPressed: () {
//        widget.giViewModel.continueToNextItem();
//      },
//    );
//
//    return Stack(
//      alignment: const Alignment(0.8, 0.8),
//      children: [
//        videoPlayer,
//        Opacity(
//          opacity: 1.0,
//          child: button,
//        ),
//      ],
//    );
//  }

  Widget addPlayButtonTo(Widget videoPlayer, BuildContext context) {
    Icon icon = Icon(
      Icons.play_circle_filled,
      size: 75,
      color: widget.giViewModel.getPrimaryColor(),
    );
    if  (!(status == AudioPlayerState.PAUSED ||
        status == AudioPlayerState.STOPPED ||
        status == AudioPlayerState.COMPLETED))
      icon = Icon(Icons.pause_circle_filled,
          color: widget.giViewModel.getPrimaryColor(),
          size: 75);

    GestureDetector gestureDetector = GestureDetector(
      onTap: () {
        new Timer(Duration(milliseconds: 10), () {
          setState(() {
            if ((status == AudioPlayerState.STOPPED || status == AudioPlayerState.COMPLETED)) {
              play();
            } else if (status == AudioPlayerState.PLAYING) {
              audioPlayer.pause();
            } else if (status == AudioPlayerState.PAUSED) {
              audioPlayer.resume();
            }
            // if (_controller.value.isPlaying) {
            //   _controller.pause();
            // } else {
            //   _controller.play();
            //   showControls = false;
            // }
          });
        });
      },
      child: icon,
    );

    return Stack(
      alignment: const Alignment(0, 0),
      children: [
        videoPlayer,
        Opacity(
          opacity: 1.0,
          child: gestureDetector,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    this.audioPlayer.dispose();
    // _controller.dispose();
  }
}

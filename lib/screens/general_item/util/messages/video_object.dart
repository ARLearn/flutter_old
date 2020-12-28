import 'dart:async';
import 'dart:math';
import 'dart:io' show Platform;

import 'package:youplay/actions/run_actions.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/general_item/video_object.dart';
import 'package:youplay/screens/general_item/general_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../localizations.dart';
import 'components/button_text_style.dart';
import 'components/next_button.dart';
import 'generic_message.dart';

class VideoObjectGeneralItemScreen extends StatefulWidget {
  VideoObjectGeneralItem item;
  GeneralItemViewModel giViewModel;

  VideoObjectGeneralItemScreen({this.item, this.giViewModel, Key key}) : super(key: key) {
    _VideoObjectGeneralItemScreenState().updateController();
  }

  @override
  _VideoObjectGeneralItemScreenState createState() => _VideoObjectGeneralItemScreenState();
}

class _VideoObjectGeneralItemScreenState extends State<VideoObjectGeneralItemScreen> {
  VideoPlayerController _controller;
  double _position;
  double _maxposition;
  bool showControls = false;
  bool isFinished = false;
  bool completeActionSent = false;

  _VideoObjectGeneralItemScreenState();

  void updateController() {}

  @override
  void initState() {
    super.initState();
    String unencPath = widget.item.fileReferences['video'].replaceFirst('//', '/');
    int index = unencPath.lastIndexOf("/") + 1;
    String path;
    if (Platform.isIOS) {
      path = Uri.encodeComponent(unencPath);
      print(path);
    } else {
      path = unencPath.substring(0, index) + Uri.encodeComponent(unencPath.substring(index));
    }
    _controller = VideoPlayerController.network(
        'https://storage.googleapis.com/${AppConfig().projectID}.appspot.com${path}')
      ..addListener(() {
        setState(() {
          if (_controller.value.duration != null) {
            _position = _controller.value.position.inMilliseconds.roundToDouble();
            _maxposition =
                max(_position, _controller.value.duration.inMilliseconds.roundToDouble());

            if (((_controller.value.duration.inMilliseconds - 1000) <=
                    _controller.value.position.inMilliseconds) &&
                _controller.value.duration.inMilliseconds > 100) {
              isFinished = true;
              if (!completeActionSent) {
                widget.giViewModel.onDispatch(Complete(
                  generalItemId: widget.giViewModel.item.itemId,
                  runId: widget.giViewModel.run.runId,
                ));
                completeActionSent = true;
              }
            }
          }
        });
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GeneralItemWidget(
        item: this.widget.item,
        renderBackground: false,
        giViewModel: this.widget.giViewModel,
        body: Container(
            constraints: const BoxConstraints.expand(),
            child: _controller.value.initialized
                ? buildVideoPlayer(context)
                : Theme(
                    data: Theme.of(context)
                        .copyWith(accentColor: this.widget.giViewModel.getPrimaryColor()),
                    child: Center(child: CircularProgressIndicator()),
                  )));
  }

  Widget buildVideoPlayer(BuildContext context) {
    Widget videoPlayer = GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: VideoPlayer(_controller),
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
                          _controller.seekTo(Duration(milliseconds: val.floor()));
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

    return Stack(
      // alignment: const Alignment(0.8, 0.7),
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

  Widget addPlayButtonTo(Widget videoPlayer, BuildContext context) {
    Icon icon = Icon(
      Icons.play_circle_filled,
      size: 75,
      color: widget.giViewModel.getPrimaryColor(),
    );
    if (_controller.value.isPlaying)
      icon = Icon(Icons.pause_circle_filled, color: widget.giViewModel.getPrimaryColor(), size: 75);

    GestureDetector gestureDetector = GestureDetector(
      onTap: () {
        new Timer(Duration(milliseconds: 10), () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
              showControls = false;
            }
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

    _controller.dispose();
  }
}

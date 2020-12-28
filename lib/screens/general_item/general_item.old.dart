//import 'dart:io';
//
//import 'package:youplay/actions/runs.dart';
//import 'package:youplay/models/game.dart';
//import 'package:youplay/models/general_item.dart';
//import 'package:youplay/screens/general_item/dataCollection/outgoing_picture_response_list.dart';
//import 'package:youplay/screens/general_item/dataCollection/outgoing_responses_list.dart';
//import 'package:youplay/screens/util/ARLearnContainer.dart';
//import 'package:youplay/state/run_state.dart';
//import 'package:youplay/state/ui_state.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_redux/flutter_redux.dart';
//import 'package:redux/redux.dart';
//import 'package:youplay/actions/actions.dart';
//import 'package:youplay/state/app_state.dart';
//import 'package:youplay/models/response.dart';
//import 'package:youplay/screens/third.dart';

//import 'package:youplay/selectors/ui_selectors.dart';
//import 'package:youplay/selectors/selectors.dart';
//import 'package:youplay/screens/general_item/dataCollection/picture.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:flutter_html_widget/flutter_html_widget.dart';
//import 'package:video_player/video_player.dart';
//
//class GeneralItemViewModel {
//  Game game;
//  RunState runState;
//  GeneralItem item;
////  ARLearnTheme theme;
//  int theme;
//  GeneralItemViewModel({this.game, this.runState, this.item, this.theme});
//}
//
//class GeneralItemScreen extends StatelessWidget {
//  final Store<AppState> store;
//
//  GeneralItemScreen(this.store);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: new StoreConnector<AppState, GeneralItemViewModel>(
//          converter: (store) => new GeneralItemViewModel(
//              game:currentGameSelector(store.state),
//              runState: currentRunStateSelector(store.state),
//              item: currentGeneralItem(store.state),
//              theme: theme(store.state)
//          ) ,
//          builder: (context, GeneralItemViewModel state) {
//            return NestedScrollView(
//              headerSliverBuilder:
//                  (BuildContext context, bool innerBoxIsScrolled) {
//                return <Widget>[
//                  SliverAppBar(
//                    expandedHeight: 110.0,
//                    floating: true,
//                    pinned: true,
//                    flexibleSpace: FlexibleSpaceBar(
//                      centerTitle: true,
//                      title: Text("${state.game.title}",
//                          style: TextStyle(
//                            color: Colors.yellow,
//                            fontSize: 16.0,
//                          )),
//                      background: new DecoratedBox(
//                          decoration: new BoxDecoration(
//                            image: new DecorationImage(
//                              fit: BoxFit.fitWidth,
//                              image: new AssetImage(
//                                  'graphics/gameMessagesHeader.png'),
//                            ),
//                            shape: BoxShape.rectangle,
//                          )),
//                    ),
//                  ),
//                ];
//              },
//              body: Container(
////                  decoration: new BoxDecoration(
////                      color: state.theme.backgroundColorLight),
//                  child: Center(child: new GeneralItemView(store, state))
//
////          MapView()
//              ),
//            );
//          }),
//      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//        floatingActionButton: _buildFab(
//            context),
//      bottomNavigationBar: BottomAppBar(
//        child: new Row(
//          mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            IconButton(icon: Icon(Icons.cloud_upload), onPressed: () {},),
//            IconButton(icon: Icon(Icons.chat), onPressed: () {},),
//          ],
//        ),
//        shape: CircularNotchedRectangle(),
//      ),
//    );
//  }
//  void _selectedFab(int index) {
//
//  }
//  Widget _buildFab(BuildContext context) {
//    final icons = [ Icons.camera_alt, Icons.videocam, Icons.mode_edit, Icons.dialpad ];
//    return AnchoredOverlay(
//      showOverlay: true,
//      overlayBuilder: (context, offset) {
//        return CenterAbout(
//          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
//          child: FabWithIcons(
//            icons: icons,
//            onIconTapped: _selectedFab,
//          ),
//        );
//      },
//      child: FloatingActionButton(
//        onPressed: () { },
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//        elevation: 2.0,
//      ),
//    );
//  }
//}
//
//class GeneralItemView extends StatelessWidget {
//  final Store<AppState> store;
//  GeneralItemViewModel state;
//  GeneralItemView(this.store, this.state);
//  @override
//  Widget build(BuildContext context) {
//
//
//
//    final _itemExtent = 56.0;
//    final generatedList = List.generate(2, (index) => 'Item $index');
//    return new CustomScrollView(
//      slivers: <Widget>[
//        SliverList(
//          delegate: SliverChildListDelegate(
//            [
//              new Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: [
//                    /*3*/
//                    Icon(
//                      Icons.star,
//                      size: 70,
//                      color: Theme.of(context).primaryColor,
//                    ),
////                  new Image(
////                    image: new AssetImage(
////                        'graphics/generalItems/narratorType.png'),
////                    height: 30.0,
////                    width: 30.0,
////                  )
//                  ],
//                ),
//                decoration: new BoxDecoration(
//                    color: this.state.theme.backgroundColorLight),
//                padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
//              ),
//
//              new Container(
//                child: new Text("${state.item.title}",
//                    style: TextStyle(fontSize: 32.0)),
//                decoration: new BoxDecoration(
//                    color: this.state.theme.backgroundColorLight),
//                padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
//              ),
//
//              new Container(
//                child: VideoApp(),
//                decoration: new BoxDecoration(
//                    color: this.state.theme.backgroundColorLight),
//                padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
//              ),
////              Row(
////                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                children: [
////
////                  new Text("${state['item'].title}",  style: TextStyle(fontSize: 32.0)),
////                ],
////              ),
//              new Container(
//                child: new HtmlWidget(html: state.item.richText),
//                decoration: new BoxDecoration(
//                    color: this.state.theme.backgroundColorLight),
//              ),
//
//              new Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: [
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.mic, 'RECORD', context, () {
//                      print("tapped2");
//
//                      loadCameras().then((test) {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => CameraExampleHome(
//                                    takePictureCallBack: (path) => store
//                                        .dispatch(new PictureResponseAction(
//                                            pictureResponse:
//                                                new PictureResponse(
//                                                    userId: "stefaan",
//                                                    run: state.runState.run,
//                                                    path: path))),
//                                  )),
//                        );
//                      });
//                    }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.camera_alt, 'PICTURE', context, () {
//                      store.dispatch(new GenericResponseMetadataAction(
//                          response: new Response(
//                              userId: "stefaan", run: state.runState.run)));
//                    }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.videocam, 'VIDEO', context, () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => OutGoingResponses(store)),
//                      );
//                    }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.mode_edit, 'TEXT', context, () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) =>
//                                OutGoingPictureResponses(store)),
//                      );
//                    }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.dialpad, 'NUMBER', context, () {}),
//                  ],
//                ),
//                decoration:
//                    new BoxDecoration(color: this.state.theme.backgroundColor),
//                padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
//              ),
////              Row(
////
////                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                children: [
////                  _buildButtonColumn(Theme.of(context).primaryColor, Icons.mic, 'RECORD'),
////                  _buildButtonColumn(Theme.of(context).primaryColor, Icons.camera_alt, 'PICTURE'),
////                  _buildButtonColumn(Theme.of(context).primaryColor, Icons.videocam, 'VIDEO'),
////                  _buildButtonColumn(Theme.of(context).primaryColor, Icons.mode_edit, 'TEXT'),
////                  _buildButtonColumn(Theme.of(context).primaryColor, Icons.dialpad, 'NUMBER'),
////
////                ],
////              ),
//            ],
//          ),
//        ),
//        SliverFixedExtentList(
//          itemExtent: _itemExtent, // I'm forcing item heights
//          delegate: SliverChildBuilderDelegate(
//            (context, index) => new Container(
//                  child: ListTile(
//                    title: Row(
//                      children: [
//                        Icon(Icons.mic, color: this.state.theme.textLight),
//                        Expanded(
//                          /*1*/
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                              /*2*/
//                              Container(
//                                padding: const EdgeInsets.only(bottom: 8.0),
//                                child: Text(
//                                  'Auteur: Stefaan Ternier',
//                                  style: TextStyle(
//                                    color: this.state.theme.textLight,
//                                    fontWeight: FontWeight.bold,
//                                  ),
//                                ),
//                              ),
//                              Text(
//                                'tap to play',
//                                style: TextStyle(
//                                  color: this.state.theme.textLight,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                        /*3*/
//                        Icon(Icons.delete, color: this.state.theme.textLight),
//                      ],
//                    ),
//
////                    Text(
////                      "antwoord x",
////                      style: TextStyle(fontSize: 20.0),
////                    ),
//
//                    onTap: () {
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(builder: (context) => GameScreen(this.store)),
////                );
//                    },
//                  ),
//                  decoration: new BoxDecoration(
//                      color: this.state.theme.backgroundColorDark),
//                ),
//            childCount: generatedList.length,
//          ),
//        ),
//      ],
//    );
//  }
//}
//
//GestureDetector _buildButtonColumn(Color color, IconData icon, String label,
//    BuildContext context, GestureTapCallback gestureTapCb) {
//  //, GestureTapCallback tap
//  return GestureDetector(
//      onTap: gestureTapCb,
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          Icon(icon, color: color),
//          Container(
//            margin: const EdgeInsets.only(top: 8.0),
//            child: Text(
//              label,
//              style: TextStyle(
//                fontSize: 12.0,
//                fontWeight: FontWeight.w400,
//                color: color,
//              ),
//            ),
//          ),
//        ],
//      ));
//}
//
//
//
//class AnchoredOverlay extends StatelessWidget {
//  final bool showOverlay;
//  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
//  final Widget child;
//
//  AnchoredOverlay({
//    this.showOverlay,
//    this.overlayBuilder,
//    this.child,
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    return new Container(
//      child: new LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
//        return new OverlayBuilder(
//          showOverlay: showOverlay,
//          overlayBuilder: (BuildContext overlayContext) {
//            RenderBox box = context.findRenderObject() as RenderBox;
//            final center = box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
//
//            return overlayBuilder(overlayContext, center);
//          },
//          child: child,
//        );
//      }),
//    );
//  }
//}
//
//class OverlayBuilder extends StatefulWidget {
//  final bool showOverlay;
//  final Function(BuildContext) overlayBuilder;
//  final Widget child;
//
//  OverlayBuilder({
//    this.showOverlay = false,
//    this.overlayBuilder,
//    this.child,
//  });
//
//  @override
//  _OverlayBuilderState createState() => new _OverlayBuilderState();
//}
//
//class _OverlayBuilderState extends State<OverlayBuilder> {
//  OverlayEntry overlayEntry;
//
//  @override
//  void initState() {
//    super.initState();
//
//    if (widget.showOverlay) {
//      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
//    }
//  }
//
//  @override
//  void didUpdateWidget(OverlayBuilder oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
//  }
//
//  @override
//  void reassemble() {
//    super.reassemble();
//    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
//  }
//
//  @override
//  void dispose() {
//    if (isShowingOverlay()) {
//      hideOverlay();
//    }
//
//    super.dispose();
//  }
//
//  bool isShowingOverlay() => overlayEntry != null;
//
//  void showOverlay() {
//    overlayEntry = new OverlayEntry(
//      builder: widget.overlayBuilder,
//    );
//    addToOverlay(overlayEntry);
//  }
//
//  void addToOverlay(OverlayEntry entry) async {
//    print('addToOverlay');
//    Overlay.of(context).insert(entry);
//  }
//
//  void hideOverlay() {
//    print('hideOverlay');
//    overlayEntry.remove();
//    overlayEntry = null;
//  }
//
//  void syncWidgetAndOverlay() {
//    if (isShowingOverlay() && !widget.showOverlay) {
//      hideOverlay();
//    } else if (!isShowingOverlay() && widget.showOverlay) {
//      showOverlay();
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return widget.child;
//  }
//}
//
//class CenterAbout extends StatelessWidget {
//  final Offset position;
//  final Widget child;
//
//  CenterAbout({
//    this.position,
//    this.child,
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    return new Positioned(
//      top: position.dy,
//      left: position.dx,
//      child: new FractionalTranslation(
//        translation: const Offset(-0.5, -0.5),
//        child: child,
//      ),
//    );
//  }
//}
//
//
//// https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
//class FabWithIcons extends StatefulWidget {
//  FabWithIcons({this.icons, this.onIconTapped});
//  final List<IconData> icons;
//  ValueChanged<int> onIconTapped;
//  @override
//  State createState() => FabWithIconsState();
//}
//
//class FabWithIconsState extends State<FabWithIcons> with TickerProviderStateMixin {
//  AnimationController _controller;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = AnimationController(
//      vsync: this,
//      duration: const Duration(milliseconds: 250),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return
//      Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      mainAxisSize: MainAxisSize.min,
//      children: List.generate(widget.icons.length, (int index) {
//        return _buildChild(index);
//      }).toList()..add(
//        _buildFab(),
//      ),
//    );
//  }
//
//  Widget _buildChild(int index) {
//    Color backgroundColor = Theme.of(context).cardColor;
//    Color foregroundColor = Theme.of(context).accentColor;
//    return Container(
//      height: 70.0,
//      width: 56.0,
//      alignment: FractionalOffset.topCenter,
//      child: ScaleTransition(
//        scale: CurvedAnimation(
//          parent: _controller,
//          curve: Interval(
//              0.0,
//              1.0 - index / widget.icons.length / 2.0,
//              curve: Curves.easeOut
//          ),
//        ),
//        child: FloatingActionButton(
//          backgroundColor: backgroundColor,
//          mini: true,
//          child: Icon(widget.icons[index], color: foregroundColor),
//          onPressed: () => _onTapped(index),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildFab() {
//    return FloatingActionButton(
//      onPressed: () {
//        if (_controller.isDismissed) {
//          _controller.forward();
//        } else {
//          _controller.reverse();
//        }
//      },
//      tooltip: 'Increment',
//      child: Icon(Icons.add),
//      elevation: 2.0,
//    );
//  }
//
//  void _onTapped(int index) {
//    _controller.reverse();
//    widget.onIconTapped(index);
//  }
//}
//
//
//
//
//class VideoApp extends StatefulWidget {
//  @override
//  _VideoAppState createState() => _VideoAppState();
//}
//
//class _VideoAppState extends State<VideoApp> {
//  VideoPlayerController _controller;
//
//  @override
//  void initState() {
//    super.initState();
////    VideoPlayerController.file(file)
//    final Directory systemTempDir = Directory.systemTemp;
//
//    final File videoFile = File('${systemTempDir.path}/game/543009/generalItems/548009/video');
//
//    _controller = VideoPlayerController.file(videoFile)
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//      });
////    _controller = VideoPlayerController.network(
////        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
////      ..initialize().then((_) {
////        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
////        setState(() {});
////      });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _controller.play();
//    return Center(
//      child: _controller.value.initialized
//          ? AspectRatio(
//        aspectRatio: _controller.value.aspectRatio,
//        child: VideoPlayer(_controller),
//      )
//          : Container(),
//    );
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _controller.dispose();
//  }
//}

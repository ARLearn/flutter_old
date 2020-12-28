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
//
//class GeneralItemViewModel {
//  Game game;
//  RunState runState;
//  GeneralItem item;
//  ARLearnTheme theme;
//  GeneralItemViewModel({
//    this.game, this.runState, this.item, this.theme
//  });
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
//        body: new StoreConnector<AppState, GeneralItemViewModel>(
//            converter: (store) => new GeneralItemViewModel(
//                game:currentGameSelector(store.state),
//                runState: currentRunStateSelector(store.state),
//                item: currentGeneralItem(store.state),
//                theme: theme(store.state)
//            ) ,
//            builder: (context, GeneralItemViewModel state) {
//              return NestedScrollView(
//                headerSliverBuilder:
//                    (BuildContext context, bool innerBoxIsScrolled) {
//                  return <Widget>[
//                    SliverAppBar(
//                      expandedHeight: 110.0,
//                      floating: true,
//                      pinned: true,
//                      flexibleSpace: FlexibleSpaceBar(
//                        centerTitle: true,
//                        title: Text("${state.game.title}",
//                            style: TextStyle(
//                              color: Colors.yellow,
//                              fontSize: 16.0,
//                            )),
//                        background: new DecoratedBox(
//                            decoration: new BoxDecoration(
//                              image: new DecorationImage(
//                                fit: BoxFit.fitWidth,
//                                image: new AssetImage(
//                                    'graphics/gameMessagesHeader.png'),
//                              ),
//                              shape: BoxShape.rectangle,
//                            )),
//                      ),
//                    ),
//                  ];
//                },
//                body: Container(
//                    decoration: new BoxDecoration(
//                        color: state.theme.backgroundColorLight),
//                    child: Center(child: new GeneralItemView(store, state))
//
////          MapView()
//                ),
//              );
//            }));
//  }
//}
//
//class GeneralItemView extends StatelessWidget {
//  final Store<AppState> store;
//  GeneralItemViewModel state;
//  GeneralItemView(this.store, this.state);
//  @override
//  Widget build(BuildContext context) {
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
//
//              new Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: [
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.mic, 'RECORD', context, () {
//                          print("tapped2");
//
//                          loadCameras().then((test) {
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => CameraExampleHome(
//                                    takePictureCallBack: (path) =>
//                                        store.dispatch(new PictureResponseAction(
//                                            pictureResponse: new PictureResponse(
//                                                userId: "stefaan",
//                                                run: state.runState.run,
//                                                path: path)
//                                        )
//                                        ),
//                                  )),
//                            );
//                          });
//                        }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.camera_alt, 'PICTURE', context, () {
//                          store.dispatch(
//                              new GenericResponseMetadataAction(
//                                  response:new Response(
//                                      userId: "stefaan", run: state.runState.run)));
//                        }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.videocam, 'VIDEO', context, () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => OutGoingResponses(store)),
//                          );
//                        }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.mode_edit, 'TEXT', context, () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => OutGoingPictureResponses(store)),
//                          );
//
//                        }),
//                    _buildButtonColumn(Theme.of(context).primaryColor,
//                        Icons.dialpad, 'NUMBER', context, () {}),
//                  ],
//                ),
//                decoration: new BoxDecoration(
//                    color: this.state.theme.backgroundColor),
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
//                (context, index) => new Container(
//              child: ListTile(
//                title: Row(
//                  children: [
//                    Icon(Icons.mic, color: this.state.theme.textLight),
//                    Expanded(
//                      /*1*/
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          /*2*/
//                          Container(
//                            padding: const EdgeInsets.only(bottom: 8.0),
//                            child: Text(
//                              'Auteur: Stefaan Ternier',
//                              style: TextStyle(
//                                color: this.state.theme.textLight,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          ),
//                          Text(
//                            'tap to play',
//                            style: TextStyle(
//                              color: this.state.theme.textLight,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    /*3*/
//                    Icon(Icons.delete,
//                        color: this.state.theme.textLight),
//                  ],
//                ),
//
////                    Text(
////                      "antwoord x",
////                      style: TextStyle(fontSize: 20.0),
////                    ),
//
//                onTap: () {
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(builder: (context) => GameScreen(this.store)),
////                );
//                },
//              ),
//              decoration: new BoxDecoration(
//                  color: this.state.theme.backgroundColorDark),
//            ),
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

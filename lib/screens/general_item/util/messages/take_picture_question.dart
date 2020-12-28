import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youplay/actions/run_actions.dart';
import 'package:youplay/actions/runs.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/localizations.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/response.dart';
import 'package:youplay/screens/components/button/cust_flat_button.dart';
import 'package:youplay/screens/components/button/cust_raised_button.dart';
import 'package:youplay/screens/general_item/dataCollection/picture.dart';
import 'package:youplay/screens/general_item/dataCollection/take_picture.dart';
import 'package:youplay/screens/general_item/general_item.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:youplay/selectors/selectors.dart';
import 'package:youplay/store/actions/current_run.actions.dart';
import 'package:youplay/store/actions/current_run.picture.actions.dart';
import 'package:youplay/store/selectors/current_run.selectors.dart';

import 'components/content_card.text.dart';
import 'components/game_themes.viewmodel.dart';
import 'components/next_button.dart';
import 'generic_message.dart';

class _PicturesViewModel {
  List<String> keys;
  List<PictureResponse> pictureResponses;
  List<Response> fromServer;

  _PicturesViewModel({this.keys, this.pictureResponses, this.fromServer});

  static _PicturesViewModel fromStore(Store<AppState> store) {
    return new _PicturesViewModel(
        pictureResponses: currentRunPictureResponsesSelector(store.state),
        fromServer: currentItemResponsesFromServerAsList(store.state));
  }

  int amountOfItems() {
    return pictureResponses.length + fromServer.length;
  }

  bool isLocal(int index) {
    return index >= fromServer.length;
  }

  Response getItem(index) {
    if (index < fromServer.length) {
      return fromServer[index];
    }
    return pictureResponses[index - fromServer.length];
  }
}

class NarratorWithPicture extends StatefulWidget {
  GeneralItem item;
  GeneralItemViewModel giViewModel;

  NarratorWithPicture({this.item, this.giViewModel});

  @override
  _NarratorWithPictureState createState() => new _NarratorWithPictureState();
}

class _NarratorWithPictureState extends State<NarratorWithPicture> {
  bool _pictureOverviewMode = true;
  int _scale = 2;
  double _lastScale = 1;

  @override
  Widget build(BuildContext context) {
    return _pictureOverviewMode
        ? GeneralItemWidget(
            item: this.widget.item,
            giViewModel: this.widget.giViewModel,
        padding: false,
        elevation: false,
            // floatingActionButton: FloatingActionButton(
            //     onPressed: () {
            //       setState(() {
            //         _pictureOverviewMode = false;
            //       });
            //     },
            //     child: Icon(Icons.photo_camera)),
            body: Container(
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new StoreConnector<AppState, GameThemesViewModel>(
                      converter: (store) => GameThemesViewModel.fromStore(store),
                      builder: (context, GameThemesViewModel themeModel) {
                        return Container(
                          // color: this.widget.giViewModel.getPrimaryColor(),
                            color: this.widget.giViewModel.getPrimaryColor() != null
                                ? this.widget.giViewModel.getPrimaryColor()
                                : themeModel.getPrimaryColor(),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "${this.widget.item.richText}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ));
                      }),
                  Expanded(
                    child: GestureDetector(
                      onScaleUpdate: (ScaleUpdateDetails details) {
//                              print("scale ${details.scale}");
                        setState(() {
                          _lastScale = details.scale;
                        });
                      },
                      onScaleEnd: (ScaleEndDetails details) {
                        setState(() {
                          if (_lastScale < 1) {
                            if (_scale < 6) _scale++;
                          } else {
                            if (_scale > 1) _scale--;
                          }
                        });
                      },
                      child: new CustomScrollView(slivers: <Widget>[
                        // SliverList(
                        //   delegate: SliverChildListDelegate(
                        //     [
                        //       _buildTopInfoCard(context, widget.item),
                        //     ],
                        //   ),
                        // ),
                        buildImageList(context)
                      ]),
//                )
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(46, 8.0, 46, 8),
                      child: NextButton(
                          buttonText: AppLocalizations.of(context).translate('screen.proceed'),
                          overridePrimaryColor: widget.giViewModel.getPrimaryColor(),
                          customButton: CustomRaisedButton(
                            useThemeColor: true,
                            title: AppLocalizations.of(context).translate('screen.proceed'),
                            // icon: new Icon(Icons.play_circle_outline, color: Colors.white),
                            primaryColor: widget.giViewModel.getPrimaryColor(),
                            onPressed: () {
                              widget.giViewModel.continueToNextItem(context);                            },
                          ),
                          giViewModel: widget.giViewModel)
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(46, 8.0, 46, 28),
                    child: CustomFlatButton(
                      title: "Maak foto",
                      icon: FontAwesomeIcons.cameraRetro,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _pictureOverviewMode = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ))
        : TakePictureWidget(
            takePictureCallBack: (path) {
              widget.giViewModel.onDispatch(LocalAction(
                action: "answer_given",
                generalItemId: widget.giViewModel.item.itemId,
                runId: widget.giViewModel.run.runId,
              ));
              widget.giViewModel.onDispatch(PictureResponseAction(
                  pictureResponse:
                      PictureResponse(item: widget.item, path: path, run: widget.giViewModel.run)));
              widget.giViewModel.onDispatch(SyncFileResponse(runId: widget.giViewModel.run.runId));
              setState(() {
                _pictureOverviewMode = true;
              });
            },
            cancelCallBack: () {
              setState(() {
                _pictureOverviewMode = true;
              });
            },
          );
  }

  buildImageList(BuildContext context) {
    return new StoreConnector<AppState, _PicturesViewModel>(
        converter: (store) => _PicturesViewModel.fromStore(store),
        builder: (context, _PicturesViewModel map) {
          return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _scale,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        print("tap");
                      },
                      child: map.isLocal(index)
                          ? Card(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
                                child: new Image(
                                    fit: BoxFit.cover,
                                    image: new AssetImage(
                                        (map.getItem(index) as PictureResponse).path)),
                              ),
//                              elevation: 10,
                            )
                          : Card(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
                                  child: new CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "https://storage.googleapis.com/${AppConfig().projectID}.appspot.com/${map.getItem(index).value}"))));
                },
                childCount: map.amountOfItems(),
              ));
        });
  }

  Widget _buildTopInfoCard(BuildContext context, GeneralItem item) {
    return Container(
        padding: const EdgeInsets.all(0),
        child: ContentCardText(giViewModel: widget.giViewModel, button:
          NextButton(buttonText: widget.item.description,
              giViewModel: widget.giViewModel,
              overridePrimaryColor: widget.giViewModel.getPrimaryColor(),
          )
        , showOnlyButton: false));
  }
}

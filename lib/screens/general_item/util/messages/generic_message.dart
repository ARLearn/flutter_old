import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/store/state/app_state.dart';

import '../../general_item.dart';
import 'components/game_themes.viewmodel.dart';
import 'components/themed_app_bar.dart';

class GeneralItemWidget extends StatelessWidget {
  GeneralItem item;
  GeneralItemViewModel giViewModel;
  FloatingActionButton floatingActionButton;
  Widget body;
  bool renderBackground;
  bool padding;
  bool elevation;

  GeneralItemWidget(
      {this.item,
      this.giViewModel,
      this.body,
      this.floatingActionButton = null,
      this.renderBackground = true,
      this.padding = true,
      this.elevation = true});

  CachedNetworkImageProvider buildImage(BuildContext context, GameThemesViewModel themeModel) {
    print('backgroudn ${item.fileReferences}');
    if (item.fileReferences != null && item.fileReferences['background'] != null) {
      return new CachedNetworkImageProvider(
          "https://storage.googleapis.com/${AppConfig().projectID}.appspot.com${item.fileReferences['background'].replaceFirst('//', '/')}",
          errorListener: () {});
    }

    return   new CachedNetworkImageProvider(
              "https://storage.googleapis.com/${AppConfig().projectID}.appspot.com${themeModel.gameTheme.backgroundPath}",
              errorListener: () {
                print ('error retrieving');
              });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ThemedAppBar(title: item.title, elevation: this.elevation),
        floatingActionButton: floatingActionButton,
        body: new StoreConnector<AppState, GameThemesViewModel>(
            converter: (store) => GameThemesViewModel.fromStore(store),
            builder: (context, GameThemesViewModel themeModel) {
              return Container(
                padding: padding
                    ? (renderBackground ? const EdgeInsets.fromLTRB(0, 0, 0, 0) : null)
                    : null,
                decoration: renderBackground  //&& item.fileReferences != null
                    ? new BoxDecoration(
                        image: new DecorationImage(fit: BoxFit.cover, image: buildImage(context, themeModel)))
                    : null,
                child: body,
              );
            }));
  }
}

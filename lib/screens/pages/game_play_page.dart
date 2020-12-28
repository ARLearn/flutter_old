import 'dart:async';

import 'package:youplay/screens/components/game_play/game_app_bar.dart';
import 'package:youplay/screens/components/game_play/messages_list_view.dart';
import 'package:youplay/screens/components/game_play/messages_map_view.dart';
import 'package:youplay/screens/ui_models/current_game_view_model.dart';
import 'package:youplay/screens/util/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/state/ui_state.dart';

class GamePlayPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, CurrentGameViewModel>(
        converter: (store) => CurrentGameViewModel.fromStore(store),
        builder: (context, CurrentGameViewModel currentGameViewModel) {
          Scaffold scaffold = Scaffold(
              drawer: ARLearnNavigationDrawer(),
              appBar: AppBar(
                backgroundColor: currentGameViewModel.themedAppBarViewModel.getPrimaryColor(),
                title: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "${currentGameViewModel.game.title}",
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: new Icon(currentGameViewModel.messageView == MessageView.mapView ? Icons.list : Icons.map,
                        color: Colors.white),
                    tooltip: 'Navigate to map mode',
                    onPressed: () {
                      currentGameViewModel.dispatchToggleMessageView();
                    },
                  ),
                ],
              ),
              // body: NestedScrollView(
              //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              //     return <Widget>[
              //       GameAppBar(
              //           game: currentGameViewModel.game,
              //           mapView: currentGameViewModel.messageView,
              //           toggleMapView: currentGameViewModel.dispatchToggleMessageView
              //       ),
              //     ];
              //   },
                body: Center(
                    child: _buildMessages(currentGameViewModel)
//                    (currentGameViewModel.messageView == MessageView.listView)
//                        ? MessagesListView(
//                        primaryColor: currentGameViewModel.game.config.primaryColor)
//                        : //Text("todo")
//                    MessagesMapView(
//                            primaryColor: currentGameViewModel.game.config.primaryColor)
                    ),
              );
          return scaffold;
        });
  }
  
  Widget _buildMessages(CurrentGameViewModel currentGameViewModel) {
    if (currentGameViewModel.run == null) {
      return _buildWaitingRoom();
    }
    if (currentGameViewModel.messageView == MessageView.listView) {

      return MessagesListView();
    } else {
      return MessagesMapView(game: currentGameViewModel.game);
    }
  }

  Widget _buildWaitingRoom() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          Container(
              child: Text(
                "Even geduld, we laden de run",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFA0ABB5),
                  fontSize: 20.0,
                ),
              )),

        ],
      ),
    );
    return Text("even geduld, we laden de run...");
  }

}

import 'package:youplay/actions/games.dart';
import 'package:youplay/actions/run_actions.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/run.dart';
import 'package:youplay/screens/general_item/general_item.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:youplay/selectors/ui_selectors.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/models/game.dart';
import 'package:youplay/store/selectors/current_game.selectors.dart';
import 'package:youplay/store/selectors/current_run.selectors.dart';

class MessageListViewModel {
  List<ItemTimes> items = [];
  final Store<AppState> store;
  int runId;
  Color themePrimaryColor;
  MessageListViewModel({
    this.items,
    this.store,
    this.runId,
    this.themePrimaryColor
  });

  static MessageListViewModel fromStore(Store<AppState> store) {

    return new MessageListViewModel(
      items: listOnlyCurrentGeneralItems(store.state),
      store: store,
      runId: runIdSelector(store.state.currentRunState),
      themePrimaryColor: gameThemePrimaryColorSelector(store.state.currentGameState),
    );
  }
  Color getPrimaryColor() {

    return themePrimaryColor;
  }
  itemTapAction(int itemId, BuildContext context) {
    return () {
      store.dispatch(SetCurrentGeneralItemId(itemId));
      store.dispatch(new ReadItemAction(
          runId: runId,
          generalItemId: itemId));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GeneralItemScreen()),
      );
    };
  }
}

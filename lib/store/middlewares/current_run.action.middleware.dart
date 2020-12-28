import 'package:youplay/actions/run_actions.dart';
import 'package:youplay/actions/run_users.dart';
import 'package:youplay/api/actions.dart';
import 'package:youplay/api/response.dart';
import 'package:youplay/api/runs.dart';
import 'package:youplay/api/run_users.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:youplay/actions/runs.dart';
import 'package:youplay/models/response.dart';
import 'package:youplay/models/run.dart';
import 'package:youplay/store/state/app_state.dart';
import 'dart:convert';
import 'dart:io';

import 'package:youplay/store/actions/current_run.actions.dart';

final uploadActionEpic =
    new TypedEpic<AppState, LocalAction>(_postAction); //dispatched from take picture

Stream<dynamic> _postAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .where((action) =>
          action is LocalAction || (action is SyncActionComplete && action.action != null))
      .asyncMap(((action) async {
    if (!store.state.currentRunState.unsynchronisedActions.isEmpty) {
      ARLearnAction firstUnsyncedAction = store.state.currentRunState.unsynchronisedActions[0];
      ARLearnAction actionFromServer =
          await ActionsApi.submitAction(firstUnsyncedAction);
      return SyncActionComplete(action: actionFromServer);
    }
    return SyncActionComplete(action: null); // no more actions to post to server
  }));
}

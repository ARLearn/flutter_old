import 'package:youplay/actions/run_actions.dart';
import 'package:youplay/models/game.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/models.dart';
import 'package:youplay/models/response.dart';
import 'package:youplay/store/state/run_state.dart';
import 'package:redux/redux.dart';
import 'package:youplay/actions/games.dart';
import 'package:youplay/actions/runs.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:youplay/models/run.dart';

final runsReducer = combineReducers<HashMap<int, List<Run>>>([
  new TypedReducer<HashMap<int, List<Run>>, ApiResultRunsParticipateAction>(_addParticipateRun),
]);

HashMap<int, List<Run>> _addParticipateRun(
    HashMap<int, List<Run>> oldMap, ApiResultRunsParticipateAction action) {
  HashMap<int, List<Run>> map = HashMap<int, List<Run>>.from(oldMap);
  map[action.gameId] = action.runs.where((element) => (element.deleted == null || !element.deleted)).toList(growable: false);
  return map;
}

//final runsStateReducer = combineReducers<HashMap<int, RunState>>([
//  new TypedReducer<HashMap<int, RunState>, ApiResultRunsParticipateAction>(
//      _addRunToState),
//  new TypedReducer<HashMap<int, RunState>, ApiResultRunsVisibleItems>(
//      _visibleItems),
//  new TypedReducer<HashMap<int, RunState>, PictureResponseAction>(
//      _addPictureResponse),
//  new TypedReducer<HashMap<int, RunState>, GenericResponseMetadataAction>(
//      _addResponseMetadata),

//  new TypedReducer<HashMap<int, RunState>, SyncIncommingActions>(
//      _syncActionsFromServer),
//  new TypedReducer<HashMap<int, RunState>, AddMeToRun>(
//      _testAddMeToRun),
//]);
//HashMap<int, RunState> _testAddMeToRun(
//    HashMap<int, RunState> oldState, AddMeToRun action) {
//
//  return oldState;
//}
//AddMeToRun
//
//HashMap<int, RunState> _syncActionsFromServer(
//    HashMap<int, RunState> oldState, SyncIncommingActions toReduceAction) {
//  HashMap<int, RunState> state =
//      _cloneAndCreateRunState(oldState, toReduceAction.runId);
//
//  if (state[toReduceAction.runId] != null &&
//      toReduceAction.actionsFromServer != null) {
//    RunState runState = RunState.fromRunState(state[toReduceAction.runId]);
//    state[toReduceAction.runId] = runState;
//    toReduceAction.actionsFromServer.forEach((a) {
//      runState.actionsFromServer
//          .putIfAbsent(a.getKeyUniqueWithinRun(), () => a);
//    });
////    print(
////        "reducing actions from server ${toReduceAction.runId} ${state[toReduceAction.runId].actionsFromServer.length}");
//  }
////  .unsynchronisedActions = oldState[action.runId].unsynchronisedActions..add(action.getAction());
//
//  return state;
//}
//
//HashMap<int, RunState> _visibleItems(
//    HashMap<int, RunState> oldState, ApiResultRunsVisibleItems action) {
//  var generalItemsList = jsonDecode(action.visibleItems);
//  HashMap<int, RunState> newState = _cloneAndCreateRunState(oldState, action.runId);
//  if (generalItemsList['generalItemsVisibility'] != null) {
//    (generalItemsList['generalItemsVisibility'] as List).forEach((itemJson) {
//      GeneralItemsVisibility visibility = GeneralItemsVisibility.fromJson(itemJson);
//      if (visibility.status == 1)
//        newState[action.runId]
//            .itemVisibilityFromServer
//            .putIfAbsent(visibility.generalItemId, () => visibility);
//      if (visibility.status == 2)
//        newState[action.runId]
//            .itemInVisibilityFromServer
//            .putIfAbsent(visibility.generalItemId, () => visibility);
//    });
//  }
//
//  return newState;
//}

//HashMap<int, RunState> _addPictureResponse(
//    HashMap<int, RunState> oldState, PictureResponseAction action) {
//  HashMap<int, RunState> newState =
//      _cloneAndCreateRunState(oldState, action.pictureResponse.run.runId);
//  newState[action.pictureResponse.run.runId].outgoingPictureResponses
//    ..add(action.pictureResponse);
//  return newState;
//}

//HashMap<int, RunState> _addResponseMetadata(
//    HashMap<int, RunState> oldState, GenericResponseMetadataAction action) {
//  HashMap<int, RunState> newState =
//      _cloneAndCreateRunState(oldState, action.response.run.runId);
//  newState[action.response.run.runId].outgoingResponses..add(action.response);
//  return newState;
//}

//HashMap<int, RunState> _addRunToState(
//    HashMap<int, RunState> oldState, ApiResultRunsParticipateAction action) {
//  var runsList = jsonDecode(action.runs)['runs'];
//  if (runsList != null) {
//    (runsList as List).forEach((runJson) {
//      Run newRun = new Run.fromJson(runJson);
//      _createRunState(oldState, newRun);
//    });
//  }
//
//
//  return HashMap<int, RunState>.from(oldState);
//}

//HashMap<int, RunState> _cloneAndCreateRunState(HashMap<int, RunState> oldState, int runId) {
//  HashMap<int, RunState> newState = HashMap<int, RunState>.from(oldState);
//  if (newState[runId] == null) newState.putIfAbsent(runId, () => new RunState());
//  return newState;
//}
//
//void _createRunState(HashMap<int, RunState> oldState, Run run) {
//  if (oldState[run.runId] == null) oldState.putIfAbsent(run.runId, () => new RunState(run: run));
//}

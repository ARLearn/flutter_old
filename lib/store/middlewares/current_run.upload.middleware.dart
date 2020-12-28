import 'package:youplay/actions/run_users.dart';
import 'package:youplay/api/response.dart';
import 'package:youplay/api/runs.dart';
import 'package:youplay/api/run_users.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:youplay/actions/runs.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/response.dart';
import 'package:youplay/store/state/app_state.dart';
import 'dart:convert';
import 'dart:io';

import 'package:youplay/store/actions/current_run.actions.dart';
import 'package:youplay/store/actions/current_run.picture.actions.dart';

final uploadResponseFilesEpic = new TypedEpic<AppState, SyncFileResponse>(_uploadReponseFilesEpic); //dispatched from take picture

Stream<dynamic> _uploadReponseFilesEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .where((action) => action is SyncFileResponse)
      .where(
          (action) => store.state.currentRunState.outgoingResponses.isNotEmpty)
      .asyncMap(((action) async {
    Response firstResponse =
        store.state.currentRunState.outgoingResponses.removeLast();
    if (firstResponse is AudioResponse) {
      firstResponse = await _uploadFile(firstResponse, store, action, 'aac');
    } else if (firstResponse is VideoResponse) {
      firstResponse = await _uploadFile(firstResponse, store, action, 'mp4');
    } else if (firstResponse is PictureResponse) {
      firstResponse = await _uploadFile(firstResponse, store, action, 'jpg');
    }
    if (firstResponse != null) {
      Response responseFromServer = await _uploadResponse(firstResponse, store, action);
      return new SyncFileResponseComplete(runId: action.runId, responseFromServer: responseFromServer);
    }

  }));
//          .then((results) => new ApiResultLoadRunAction(action.runId, results))
//          .catchError((error) => new ApiResultRunsParticipateAction(error, action.runId)));
}

Future<Response> _uploadResponse(Response firstResponse, EpicStore<AppState> store, action) async {

  return await ResponseApi.postResponse( firstResponse);
}

Future<PictureResponse> _uploadFile(
    PictureResponse firstResponse, EpicStore<AppState> store,
    SyncFileResponse action,
    String extension
    ) async {
  try {
    final File file = await File(firstResponse.path).create();
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference ref = AppConfig().storage
        .ref()
        .child('run')
        .child("${firstResponse.run.runId}")
        .child("${store.state.authentication.userId}")
        .child(timeStamp + '.'+extension);
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'description': 'User picture'},
      ),
    );
    StorageTaskSnapshot snap = await uploadTask.onComplete;
    firstResponse.remotePath = snap.storageMetadata.path;
    print("remotePath is ${firstResponse}");
//    return uploadTask.onComplete.then((StorageTaskSnapshot snap) {
//      firstResponse.location = "gs://" +
//          snap.storageMetadata.bucket +
//          "/" +
//          snap.storageMetadata.path +
//          "/" +
//          snap.storageMetadata.name;
//      return new GenericResponseMetadataAction(response: firstResponse);
//    });
    return firstResponse;
  } catch (e) {
    store.state.currentRunState.outgoingResponses.add(firstResponse);
    return null;
  }
}

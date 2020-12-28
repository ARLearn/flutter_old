import 'dart:convert';

import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/run.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
class ActionsApi {
  static  String apiUrl = AppConfig().baseUrl;

  static Future<String> getIdToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken(refresh: true);
    return token.token;
  }

  static Future<ARLearnAction> submitAction(ARLearnAction action) async {
    final response = await http.post(apiUrl + 'api/action/create',
        headers: {"Authorization": "Bearer " + await getIdToken()},
        body:json.encode(action)
        );
//    print("json ${response.body}");
    return ARLearnAction.fromJson(jsonDecode(response.body));
  }


//  static Future<dynamic> getActions(int runId, int from, String idToken) async {
//    final response = await http.get(apiUrl + 'api/actions/run/${runId}/from/${from}/-',
//        headers: {"Authorization": "Bearer " + idToken}
//    );
//    print("body actions from server");
//
//    return jsonDecode(response.body);
//
//  }
  static Future<ARLearnActionsList> getActions(int runId, int from, String resumptionToken) async {
    final response = await http.get(apiUrl + 'api/actions/run/$runId/from/$from/$resumptionToken',
        headers: {"Authorization": "Bearer " + await getIdToken()}
    );
//    print("body actions from server ${response.body}");
//ARLearnActionsList actionsList = ARLearnActionsList.fromJson(jsonDecode(response.body));
//    print ("test ${actionsList}");
    return ARLearnActionsList.fromJson(jsonDecode(response.body));

  }
}

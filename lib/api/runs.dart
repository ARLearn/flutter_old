import 'dart:convert';

import 'package:youplay/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youplay/models/run.dart';

class RunsApi {
  static String apiUrl = AppConfig().baseUrl;
  static Future<String> getIdToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return '';
    IdTokenResult token = await user.getIdToken(refresh: true);
    return token.token;
  }
  static Future<List<Run>> participate(int gameId) async {
    final response = await http.get(apiUrl + 'api/runs/participate/$gameId',
        headers: {"Authorization": "Bearer " + await getIdToken()});
//    print("body participate ${response.body}");
    Map<String, dynamic> runMap = jsonDecode(response.body);
    if (runMap["runs"] == null) return [];
    return (runMap["runs"] as List).map((json) => Run.fromJson(json)).toList(growable: false);
//    return response.body;
  }

  static Future<dynamic> runWithGame(int runId) async {
    final response = await http.get(apiUrl + 'api/run/$runId',
        headers: {"Authorization": "Bearer " + await getIdToken()});
//    print("body runWithGame ${response.body}");
//     Map<String, dynamic> gameMap = jsonDecode(response.body);
    if (response.statusCode == 401) {
      final response = await http.get(apiUrl + 'api/run/$runId/unauth');
      if (response.statusCode == 401) {
        return null;
      }
      return jsonDecode(response.body);

    }
    return jsonDecode(response.body);
  }

  static Future<dynamic> addMeToRun(int runId) async {
    final response = await http.get(apiUrl + 'api/run/$runId/addMe',
        headers: {"Authorization": "Bearer " + await getIdToken()});
    return response.body;
  }

  static Future<dynamic> gameFromRun(int gameId) async {
    final response = await http.get(apiUrl + 'api/run/game/$gameId',
        headers: {"Authorization": "Bearer " + await getIdToken()});
//    print("body gameFromRun ${response.body}");
    return response.body;
  }

  static Future<Run> requestRun(gameId, String name) async {
    Run run = new Run(gameId: gameId, title: name);
    final httpResponse = await http.post(apiUrl + 'api/run/create/withSelf',
        headers: {"Authorization": "Bearer " + await getIdToken()},
        body: json.encode(run.toJson())
    );
//    print('response from server ${httpResponse.body}');
    return Run.fromJson(jsonDecode(httpResponse.body));

  }


  static Future<Run> registerToRun(runId) async {
    final httpResponse = await http.get(apiUrl + 'api/run/$runId/addMe',
        headers: {"Authorization": "Bearer " + await getIdToken()}
    );

    return Run.fromJson(jsonDecode(httpResponse.body));

  }
}

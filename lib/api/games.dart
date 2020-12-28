import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:youplay/actions/errors.dart';
import 'package:youplay/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:youplay/models/game.dart';
import 'package:youplay/models/game_theme.dart';

class GamesApi {

  static Future<String> getIdToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      return '';
    }
    IdTokenResult token = await user.getIdToken(refresh: true);
    // print(token.token);
    return token.token;
  }

  static Future<dynamic> participateGameIds() async {
//    print("in participate api ids");
    final response = await http.get(
        AppConfig().baseUrl + 'api/games/participateIds',
        headers: {"Authorization": "Bearer " + await getIdToken()});

//    print(AppConfig().baseUrl + 'api/games/participateIds');
//    print(response.body);
    return response.body;
  }



  static Future<dynamic> game(int gameId) async {

    final response = await http.get(AppConfig().baseUrl + 'api/game/$gameId',
        headers: {"Authorization": "Bearer " + await getIdToken()});
    Map<String, dynamic> gameMap = jsonDecode(response.body);
    if (gameMap.containsKey("error")) {
      return new ApiResultError(error: gameMap["error"]["code"]);
    }

    return Game.fromJson(gameMap);
  }


  static Future<GameTheme> getTheme(int themeId) async {

    final response = await http.get(AppConfig().baseUrl + 'api/game/theme/$themeId',
        headers: {"Authorization": "Bearer " + await getIdToken()});
    String idtoken = await getIdToken();
    // print("game response ${response.body} ${idtoken}");
    return GameTheme.fromJson(jsonDecode(response.body));
  }


}

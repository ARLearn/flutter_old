import 'dart:convert';

import 'package:youplay/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:youplay/models/game.dart';

class StoreApi {

  static Future<List<Game>> recentGames() async {
    final response = await http.get(
        AppConfig().baseUrl +'api/games/library/recent');
    // print(response.body);
    Map<String, dynamic> gamesMap = jsonDecode(response.body);
    if (gamesMap['games'] == null) return [];
    return (gamesMap['games'] as List).map((g)=> Game.fromJson(g)).toList();
  }


  static Future<List<Game>> featuredGames() async {
    final response = await http.get(
        AppConfig().baseUrl +'api/games/featured/nl');
    // print(response.body);
    Map<String, dynamic> gamesMap = jsonDecode(response.body);
    if (gamesMap['games'] == null) return [];
    return (gamesMap['games'] as List).map((g)=> Game.fromJson(g)).toList();
  }


  static Future<List<Game>> search(String query) async {
    final response = await http.get(
        AppConfig().baseUrl +'api/games/library/search/$query');
    // print(response.body);
    // print(query);
    Map<String, dynamic> gamesMap = jsonDecode(response.body);
    if (gamesMap['games'] == null) return [];
    return (gamesMap['games'] as List).map((g)=> Game.fromJson(g)).toList();
  }

  static Future<dynamic> game(int gameId) async {
    final response = await http.get(AppConfig().baseUrl + 'api/games/library/game/$gameId');
    Map<String, dynamic> gameMap = jsonDecode(response.body);
    if (gameMap['error'] != null) {
      return null;
    }
    // print(response.body);
    return Game.fromJson(gameMap);
  }
}

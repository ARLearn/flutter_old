import 'package:youplay/config/app_config.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';

class GeneralItemsApi {
  static   String apiUrl = AppConfig().baseUrl;
  static Future<String> getIdToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken(refresh: true);
    return token.token;
  }

  static Future<dynamic> visibleItems(int runId) async {
    final response = await http.get(
        apiUrl+'api/generalItems/visible/runId/$runId', headers:{"Authorization":"Bearer "+await getIdToken()});

    print ('visible items ${response.body}');
    return response.body;
  }

  static Future<dynamic> generalItems(int gameId) async {
    final response = await http.get(
        apiUrl+'api/generalItems/gameId/${gameId}', headers:{"Authorization":"Bearer "+await getIdToken()});
    return response.body;
  }

  static Future<dynamic> generalItemsWithCursor(int gameId, String cursor) async {
    if (cursor == null) {
      cursor = '*';
    }
    final response = await http.get(
        apiUrl+'api/generalItems/gameId/$gameId/cursor/$cursor', headers:{"Authorization":"Bearer "+await getIdToken()});
    return response.body;
  }
}

import 'dart:convert';
import 'package:youplay/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:youplay/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResponseApi {
  static   String apiUrl = AppConfig().baseUrl;
  static Future<String> getIdToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken(refresh: true);
    return token.token;
  }
  static Future<Response> postResponse(final Response response) async {
    if (response == null) {
      print("ERRRROOORRRR! reponse is null in post RESPONSE");
    }
    // print("response before to server ${json.encode(response.toJson())}");
    final httpResponse = await http.post(apiUrl + 'api/run/response',
        headers: {"Authorization": "Bearer " + await getIdToken()},
        body: json.encode(response.toJson())
    );
    // print('response from server ${httpResponse.body}');
    return Response.fromJson(jsonDecode(httpResponse.body));
  }

  static Future<ResponseList> getResponse( int runId, int from, int until, String cursor) async {
    if (cursor == null) {
      cursor = '*';
    }
    final httpResponse = await http.get(apiUrl + 'api/run/response/runId/$runId/from/$from/until/$until/cursor/$cursor/me',
        headers: {"Authorization": "Bearer " + await getIdToken()}
    );
    return ResponseList.fromJson(jsonDecode(httpResponse.body));
  }

  static Future<Response> deleteResponse( final int responseId) async {
    final httpResponse = await http.delete(apiUrl + 'api/run/response/$responseId',
        headers: {"Authorization": "Bearer " + await getIdToken()}
    );
    return Response.fromJson(jsonDecode(httpResponse.body));
  }
}

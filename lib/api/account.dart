import 'package:youplay/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youplay/models/account.dart';
import 'dart:convert';

class AccountApi {
  static String apiUrl = AppConfig().baseUrl;

  static Future<String> getIdToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken(refresh: true);
    return token.token;
  }

  static Future<dynamic> accountDetails() async {
    final response = await http.get(apiUrl + 'api/account/accountDetails',
        headers: {"Authorization": "Bearer " + await getIdToken()});
//    print(response.body);
    return response.body;
  }

  static Future<dynamic> eraseAnonAcount() async {
    final response = await http.delete(apiUrl + 'api/account/eraseAnonAccount',
        headers: {"Authorization": "Bearer " + await getIdToken()});
//    print(response.body);
    return response.body;
  }

  static Future<dynamic> initNewAccount(String email, String displayName) async {
    Account acc = new Account(name: displayName, email: email);
    final response = await http.post(apiUrl + 'api/account/update/displayName/asUser',
        headers: {"Authorization": "Bearer " + await getIdToken()},
        body: json.encode(acc.toJson()));

    return response.body;
  }
}

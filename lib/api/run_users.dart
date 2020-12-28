import 'package:youplay/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class UsersApi {
  static Future<String> getIdToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult token = await user.getIdToken(refresh: true);
    return token.token;
  }

  static   String apiUrl = AppConfig().baseUrl;
  static Future<dynamic> runUsers() async {
    final response = await http.get(
        apiUrl+'api/run/users', headers:{"Authorization":"Bearer "+await getIdToken()});
    return response.body;
  }
}

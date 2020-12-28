import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

class AuthenticationState {
  bool authenticated;
//  String idToken;
  String userId;
  String email;
  String name;
  String pictureUrl;
  bool anon;

  AuthenticationState({
    this.authenticated=false,
//    this.idToken,
    this.userId,
    this.email = '',
    this.name = "",
    this.anon = true
  }) : this.pictureUrl = "https://storage.googleapis.com/arlearn-eu.appspot.com/avatar.png";//"https://www.gravatar.com/avatar/"+generateMd5(email)+"?size=100";

  factory AuthenticationState.unauthenticated() =>
      new AuthenticationState(authenticated: false);

  static AuthenticationState fromJson(dynamic json) => AuthenticationState(
        authenticated: json["authenticated"] as bool,
        userId: json["userId"] as String,
      );

  dynamic toJson() => {
        'authenticated': authenticated,
//        'idToken': idToken,
        'userId': userId,
      };
}


generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

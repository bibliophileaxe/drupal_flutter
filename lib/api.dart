import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

const SERVER_IP = 'https://20c1869046e1.ngrok.io/drupal';

class Api {
  Future<LoginResponse> createLoginState(
      String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var body = {
      "user": username,
      "pass": password,
    };

    var request =
        http.Request('POST', Uri.parse(SERVER_IP + '/user/login?_format=json'));
    request.body = '''{"name":"$username", "pass":"$password"}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = (await response.stream.bytesToString());
      var returnResponse = LoginResponse.fromJson(json.decode(responseBody));
      saveInLocalMemory('token', returnResponse.token);
      saveInLocalMemory('name', returnResponse.userNicename);
      return returnResponse;
    } else {
      print(response.reasonPhrase);
    }
    // final http.Response response = await http
    //     .post(SERVER_IP + '/user/login?_format=json', headers: <String, String>{
    //   'Accept': 'application/json',
    //   'Content-Type': 'application/json',
    // }, body: {
    //   'name': username,
    //   'pass': password,
    // });

    // if (response.statusCode == 200) {
    //   print(response.body);
    //   return LoginResponse.fromJson(json.decode(response.body));
    // } else {
    //   throw Exception('Failed to create user.');
    // }
  }

/*
  * Saves to memory.
  * 
  */
  Future<void> saveInLocalMemory(String key, String value) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

/*
  * Retreives from memory.
  * 
  */
  Future<String> getFromLocalMemory(String key) async {
    var pref = await SharedPreferences.getInstance();
    var value = pref.getString(key) ?? '';
    return value;
  }
}

class LoginResponse {
  String token;
  String userNicename;

  LoginResponse({this.token, this.userNicename});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['access_token'];
    // userEmail = json['user_email'];
    userNicename = json['current_user']['name'];
    // userDisplayName = json['user_display_name'];
  }
}

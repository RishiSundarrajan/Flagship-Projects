import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Services {
  ///Live
  // static String baseURL = "http://49.204.232.254:64/";

  ///test
  static String baseURL = "http://49.204.232.254:90/";
  static String updateURL = "http://49.204.232.254:90/users/updatepassword";

  static Map<String, String> header = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  };
  Services._();

  static late SharedPreferences pref;

  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  static httpPost(String url, dynamic body) async {
    var res;
    if (body != null) {
      res = await Future.any([
        http.post(Uri.parse(url), headers: header, body: body),
        Future.delayed(const Duration(seconds: 5))
      ]);
    } else {
      res = await Future.any([
        http.post(Uri.parse(url), headers: header),
        Future.delayed(const Duration(seconds: 5))
      ]);
    }
    if (res == null) {
      return "{}";
    } else if (res.statusCode == 200) {
      return res.body;
    }
  }

  static httpGet(String url) async {
    var res = await Future.any([
      http.get(Uri.parse(url), headers: header),
      Future.delayed(const Duration(seconds: 5))
    ]);
    if (res == null) {
      return "{}";
    }
    if (res.statusCode == 200) {
      return res.body;
    }
  }
}
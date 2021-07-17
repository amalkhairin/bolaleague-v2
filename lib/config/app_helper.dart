import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bolalucuv2/config/api_route.dart';

class AppHelper {
  static Future<dynamic> isOpenPhase({int? phaseID}) async {
    try {
      var url = Uri.https(API.URL, API.PHASE_CHECK + "/$phaseID");
       
      var response = await http.get(url);
       
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonRes['success'] == true) {
          return {
            "success": true,
            "data": jsonRes['data'],
          };
        } else {
          return {
            "success": false,
            "message": jsonRes['message'],
          };
        }
      }
      return {
        "success": false,
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> getMessage() async {
    try {
      var url = Uri.https(API.URL, API.MESSAGE);
      var response = await http.get(url);
       
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonRes['success'] == true) {
          return {
            "success": true,
            "data": jsonRes['data'],
          };
        } else {
          return {
            "success": false,
            "message": jsonRes['message'],
          };
        }
      }
      return {
        "success": false,
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }  
}
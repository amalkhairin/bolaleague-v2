import 'dart:convert';
import 'package:bolalucuv2/config/api_route.dart';
import 'package:http/http.dart' as http;

class SemifinalHelper {
  static Future<dynamic> getSemifinalMatches({String? leg}) async {
    try {
      var url = Uri.https(API.URL, API.SEMIFINAL_MATCHES + "/$leg");
       ;
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
        "message": "ERR: INVALID PARAMETER!",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> updateSemifinalMatches(
      {String? matchID,
      String? leg,
      String? homeTeamId,
      String? awayTeamId,
      String? homeScore,
      String? awayScore}) async {
    try {
      var url = Uri.https(API.URL, API.UPDATE_SEMIFINAL);
       ;
      var response = await http.put(url, body: {
        "match_id": matchID,
        "leg": leg,
        "home_team_id": homeTeamId,
        "away_team_id": awayTeamId,
        "home_score": homeScore,
        "away_score": awayScore,
        "is_finished": "1",
      });
       
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonRes['success'] == true) {
          return {
            "success": true,
            "data": jsonRes['message'],
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

import 'dart:convert';
import 'package:bolalucuv2/config/api_route.dart';
import 'package:http/http.dart' as http;

class GroupHelper {
  static Future<dynamic> getGroupStanding({String? groupName}) async {
    try {
      var url = Uri.https(API.URL, API.STANDING + "/$groupName");
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
        "message": "ERR: INVALID PARAMETER",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> getGroupMatches({String? groupName}) async {
    try {
      var url = Uri.https(API.URL, API.GROUP_MATCH + "/$groupName");
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

  static Future<dynamic> updateGroupMatches({String? groupName, String? matchID, String? homeTeamId, String? awayTeamId, String? homeScore, String? awayScore}) async {
    try {
      int score1 = int.parse(homeScore!);
      int score2 = int.parse(awayScore!);
      String result = "draw";
      if (score1 > score2) {
        result = "home_win";
      } else if (score2 > score1) {
        result = "away_win";
      }
      var url = Uri.https(API.URL, API.UPDATE_GROUP + "/$groupName");
       ;
      var response = await http.put(url, body: {
        "match_id": matchID,
        "home_team_id": homeTeamId,
        "away_team_id": awayTeamId,
        "home_score": homeScore,
        "away_score": awayScore,
        "is_finished": "1",
        "match_result": result,
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
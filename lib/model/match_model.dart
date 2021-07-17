
class MatchModel {
  int? matchID;
  int? matchDay;
  String? groupName;
  int? homeTeamID;
  String? homeTeamName;
  int? awayTeamID;
  String? awayTeamName;
  String? homeScore;
  String? awayScore;
  int? isFinished;

  MatchModel({
    this.matchID,
    this.matchDay,
    this.groupName,
    this.homeTeamID,
    this.homeTeamName,
    this.awayTeamID,
    this.awayTeamName,
    this.homeScore,
    this.awayScore,
    this.isFinished
  });

  factory MatchModel.fromJson(Map<String, dynamic> data){
    return MatchModel(
      matchID: data['match_id'],
      matchDay: data['matchday'],
      groupName: data['group_name'],
      homeTeamID: data['home_team_id'],
      homeTeamName: data['home_team_name'],
      awayTeamID: data['away_team_id'],
      awayTeamName: data['away_team_name'],
      homeScore: data['home_score'],
      awayScore: data['away_score'],
      isFinished: data['is_finished']
    );
  }
}

class MatchModel2 {
  int? matchID;
  int? leg;
  int? homeTeamID;
  String? homeTeamName;
  int? awayTeamID;
  String? awayTeamName;
  String? homeScore;
  String? awayScore;
  int? isFinished;

  MatchModel2({
    this.matchID,
    this.leg,
    this.homeTeamID,
    this.homeTeamName,
    this.awayTeamID,
    this.awayTeamName,
    this.homeScore,
    this.awayScore,
    this.isFinished
  });

  factory MatchModel2.fromJson(Map<String, dynamic> data){
    return MatchModel2(
      matchID: data['match_id'],
      leg: data['leg'],
      homeTeamID: data['home_team_id'],
      homeTeamName: data['home_team_name'],
      awayTeamID: data['away_team_id'],
      awayTeamName: data['away_team_name'],
      homeScore: data['home_score'],
      awayScore: data['away_score'],
      isFinished: data['is_finished']
    );
  }
}
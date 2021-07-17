
class User {
  int? ownerId;
  String? teamName;
  String? noWA;

  static int? _ownerId;
  static String? _teamName;
  static String? _noWa;

  static final User instance = User._internal();

  factory User(Map<String, dynamic> jsonData) {
    var data = jsonData['data'][0];
    _ownerId = data['owner_id'];
    _teamName = data['team_name'];
    _noWa = data['no_wa'];
    return instance;
  }

  User._internal(){
    this.ownerId = _ownerId;
    this.teamName = _teamName;
    this.noWA = _noWa;
  }
}
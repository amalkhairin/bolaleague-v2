
class API {
  // users
  static const String URL = "bolalucu-league.herokuapp.com";
  static const String LOGIN = "/v1/user/login";
  static const String SIGN_UP = "/v1/user/signup";
  static const String USER = "/v1/user"; //+id to get user by id
  // static const String UPDATE_STATUS = "/v1/user/status";
  static const String NO_WA = "/v1/user/wa";  //+id
  // static const String DEL_USER = "/v1/user";  //delete all user
  static const String REGISTERED_TEAMS = "/v1/user/registered/all";

  // group
  // static const ADD_GROUP = "/v1/group";   //+group name
  // static const GROUP_QUALIFIED = "/v1/group/qualified";
  static const STANDING = "/v1/group/standing";   //+group name
  static const GROUP_MATCH = "/v1/matches";  //+group name
  static const UPDATE_GROUP = "/v1/matches/update"; //+group name

  // round of 16
  static const UPDATE_ROUND = "/v1/round16/update";
  static const ROUND_MATCHES = "/v1/round16/matches"; //+leg
  
  // quarter
  // static const DRAW_QUARTER = "/v1/quarter/draw";
  static const UPDATE_QUARTER = "/v1/quarter/update";
  static const QUARTER_MATCHES = "/v1/quarter/matches"; //+leg

  // semifinal
  // static const DRAW_SEMIFINAL = "/v1/semifinal/draw";
  static const UPDATE_SEMIFINAL = "/v1/semifinal/update";
  static const SEMIFINAL_MATCHES = "/v1/semifinal/matches"; //+leg

  // final
  // static const FINAL_DRAW = "/v1/final/draw";
  static const UPDATE_FINAL = "/v1/final/update";
  static const FINAL_MATCHES = "/v1/final/matches";

  // other
  static const PHASE_CHECK = "/v1/user/is_open";
  static const MESSAGE = "/v1/user/admin/message";
  
}
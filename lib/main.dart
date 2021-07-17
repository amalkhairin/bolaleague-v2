import 'package:bolalucuv2/model/user_model.dart';
import 'package:bolalucuv2/pages/home_page.dart';
import 'package:bolalucuv2/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = false;
  bool? isLogin = prefs.getBool("is_login");
  if (isLogin != null) {
    if (isLogin){
      isLoggedIn = true;
      int? ownerId = prefs.getInt("owner_id");
      String? teamName = prefs.getString("team_name");
      String? noWa = prefs.getString("no_wa");
      Map<String, dynamic> data = {
        "data": [
          {
            "owner_id": ownerId,
            "team_name": teamName,
            "no_wa": noWa
          }
        ]
      };
      print(data);
      User user = User(data);
    }
  }
  runApp(MyApp(isLogin: isLoggedIn,));
}

class MyApp extends StatelessWidget {
  final bool? isLogin;
  MyApp({Key? key, this.isLogin}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (isLogin!) {
      return MaterialApp(
        title: 'Bolalucu League',
        home: HomePage(),
      );
    } else {
      return MaterialApp(
        title: 'Bolalucu League',
        home: LoginPage(),
      );
    }
  }
}

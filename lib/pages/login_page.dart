import 'package:bolalucuv2/component/button/b_button.dart';
import 'package:bolalucuv2/component/dialog/b_dialog.dart';
import 'package:bolalucuv2/config/user_helper.dart';
import 'package:bolalucuv2/constant/colors.dart';
import 'package:bolalucuv2/model/user_model.dart';
import 'package:bolalucuv2/pages/home_page.dart';
import 'package:bolalucuv2/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSecure = true;
  bool _isLoading = false;
  TextEditingController _ownerIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 100,
                      child: Image.asset("assets/img/logo.png"),
                    ),
                    SizedBox(height: 24,),
                    Container(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: TextFormField(
                        controller: _ownerIdController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Masukkan ID Pemilik",
                          filled: true,
                          fillColor: whiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Container(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isSecure,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value){
                          setState(() {
                            
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Masukkan Password",
                          filled: true,
                          fillColor: whiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          suffixIcon: InkWell(
                            onTap: (){
                              setState(() {
                                _isSecure = !_isSecure;
                              });
                            },
                            child: _isSecure? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 64,),
                    Container(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: BButton(
                        onPressed: _isLoading? (){} : (_ownerIdController.text.isEmpty || _passwordController.text.isEmpty)? (){
                          setState(() {
                            
                          });
                        } : () async {
                          if (_ownerIdController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                            setState(() {
                              _isLoading = true;
                            });
                            var data = await UserHelper.logIn(
                              ownerId: _ownerIdController.text,
                              password: _passwordController.text
                            );
                            if(data['success']){
                              setState(() {
                                _isLoading = false;
                              });
                              if(data['data'][0]['status'] == 0){
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => BDialog(
                                    title: "LOGIN BERHASIL!",
                                    description: "Silahkan hubungi admin untuk melakukan verifikasi akun",
                                    dialogType: BDialogType.SUCCESS,
                                    action: [
                                      BButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        label: Text("Ok"),
                                      ),
                                    ],
                                  )
                                );
                              } else {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                User user = User(data);
                                int ownerID = int.parse(_ownerIdController.text);
                                await prefs.setInt("owner_id", ownerID);
                                await prefs.setString("team_name", data['data'][0]['team_name']);
                                await prefs.setString("no_wa", data['data'][0]['no_wa']);
                                await prefs.setBool("is_login", true);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => HomePage())
                                );
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => BDialog(
                                  title: "LOGIN GAGAL!",
                                  description: "${data['message']}",
                                  dialogType: BDialogType.FAILED,
                                  action: [
                                    BButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      label: Text("Ok"),
                                    ),
                                  ],
                                )
                              );
                            }
                          }
                        },
                        label: _isLoading? CircularProgressIndicator(color: whiteColor,) : Text("Login"),
                      ),
                    ),
                    SizedBox(height: 24,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Belum punya akun?"),
                        SizedBox(height: 14,),
                        Container(
                          constraints: BoxConstraints(maxWidth: 700),
                          child: BButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => RegisterPage())
                              );
                            },
                            label: Text("Register"),
                            style: BButtonStyle.SECONDARY,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
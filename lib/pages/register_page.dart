import 'package:bolalucuv2/component/button/b_button.dart';
import 'package:bolalucuv2/component/dialog/b_dialog.dart';
import 'package:bolalucuv2/config/user_helper.dart';
import 'package:bolalucuv2/constant/colors.dart';
import 'package:bolalucuv2/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isSecure = true;
  bool _isLoading = false;
  TextEditingController _ownerIdController = TextEditingController();
  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _waNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
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
                      controller: _teamNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Masukkan Nama Tim",
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
                      controller: _waNumberController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "No. Whatsapp (+62). Ex: 6285xxxxxx",
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
                      onFieldSubmitted: (value) {
                        setState(() {});
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
                      onPressed: _isLoading? (){} : (_ownerIdController.text.isEmpty || _passwordController.text.isEmpty || _teamNameController.text.isEmpty || _waNumberController.text.isEmpty)? (){
                        setState(() {
                          
                        });
                      } : () async {
                        if (_ownerIdController.text.isNotEmpty || _passwordController.text.isNotEmpty || _teamNameController.text.isNotEmpty || _waNumberController.text.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          String noPhone = "";
                          if (_waNumberController.text[0] == "0") {
                            noPhone = "62" + _waNumberController.text.substring(1, _waNumberController.text.length);
                          } else if (_waNumberController.text[0] == "+") {
                            noPhone = _waNumberController.text.substring(1, _waNumberController.text.length);
                          } else {
                            noPhone = _waNumberController.text;
                          }
                          var data = await UserHelper.signUp(
                            ownerId: _ownerIdController.text,
                            teamName: _teamNameController.text,
                            noWa: noPhone,
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
                                  title: "REGISTER BERHASIL!",
                                  description: "Silahkan hubungi admin untuk melakukan verifikasi akun",
                                  dialogType: BDialogType.SUCCESS,
                                  action: [
                                    BButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) => LoginPage())
                                        );
                                      },
                                      label: Text("Ok"),
                                    ),
                                  ],
                                )
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
                                title: "REGISTRASI GAGAL!",
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
                      label: _isLoading? CircularProgressIndicator(color: whiteColor,) : Text("Register"),
                    ),
                  ),
                  SizedBox(height: 14,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun?"),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginPage())
                          );
                        },
                        child: Text("Login disini"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
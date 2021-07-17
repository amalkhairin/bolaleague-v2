import 'dart:io';

import 'package:bolalucuv2/component/button/b_button.dart';
import 'package:bolalucuv2/component/dialog/b_dialog.dart';
import 'package:bolalucuv2/config/semifinal_helper.dart';
import 'package:bolalucuv2/constant/colors.dart';
import 'package:bolalucuv2/model/match_model.dart';
import 'package:bolalucuv2/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SemifinalLegDetailPage extends StatefulWidget {
  final String? title;
  const SemifinalLegDetailPage({ Key? key, this.title }) : super(key: key);

  @override
  _SemifinalLegDetailPageState createState() => _SemifinalLegDetailPageState();
}

class _SemifinalLegDetailPageState extends State<SemifinalLegDetailPage> {
  User _user = User.instance;
  bool _isLoading = false;
  bool _isError = false;
  String _errMessage = "";
  List<MatchModel2> _listMatch = [];
  TextEditingController _homeScoreController = TextEditingController();
  TextEditingController _awayScoreController = TextEditingController();

  isValidScore(String home, String away) {
    try {
      int skor1 = int.parse(home);
      int skor2 = int.parse(away);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  loadSemifinalData() async {
    setState(() {
      _isLoading = true;
    });
    List<MatchModel2> _temp = [];
    var data = await SemifinalHelper.getSemifinalMatches(leg: widget.title);
    if (data['success']) {
      for (Map<String, dynamic> match in data['data']) {
        _temp.add(MatchModel2.fromJson(match));
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _listMatch = _temp;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errMessage = data['message'];
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSemifinalData();
  }
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    if(_isLoading){
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(Icons.emoji_events, color: Colors.white, size: 64,),
                  ),
                  SizedBox(height: 14,),
                  CircularProgressIndicator(color: whiteColor,),
                ],
              )
            ),
          ),
        ),
      );
    } else {
      if (!_isError) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: backgroundColor,
            leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: blackColor,),
            ),
            title: Text("SemiFinal - Leg ${widget.title}", style: TextStyle(color: blackColor),),
            actions: [
              TextButton(
                onPressed: () async {
                  loadSemifinalData();
                },
                child: Text("Refresh"),
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: ListView.builder(
                itemCount: _listMatch.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 14, left: 24, right: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (_listMatch[index].homeTeamID == _user.ownerId || _listMatch[index].awayTeamID == _user.ownerId) && _listMatch[index].isFinished != 1
                        ? ExpansionTile(
                          collapsedBackgroundColor: Color(0xFFFBFBFB),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                child: Column(
                                  children: [
                                    CircleAvatar(backgroundColor: Colors.blue, child: Text("${_listMatch[index].homeTeamName!.substring(0,1)}"),),
                                    Text("${_listMatch[index].homeTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                              Text("${_listMatch[index].homeScore} - ${_listMatch[index].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                              Container(
                                width: 100,
                                child: Column(
                                  children: [
                                    CircleAvatar(backgroundColor: Colors.orange, child: Text("${_listMatch[index].awayTeamName!.substring(0,1)}"),),
                                    Text("${_listMatch[index].awayTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: screenSize.width/3.2,
                                        child: TextFormField(
                                          controller: _homeScoreController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "Skor",
                                            fillColor: Colors.blue[100],
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: screenSize.width/3.2,
                                        child: TextFormField(
                                          controller: _awayScoreController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "Skor",
                                            fillColor: Colors.orange[100],
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                  child: BButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BDialog(
                                          title: "INPUT HASIL PERTANDINGAN",
                                          description: "Apakah anda yakin?\nPastikan skor sudah benar. Jika terdapat KECURANGAN maka akan dikenakan sanksi BANNED.",
                                          dialogType: BDialogType.INFO,
                                          action: [
                                            BButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              label: Text("Cancel"),
                                              style: BButtonStyle.SECONDARY,
                                            ),
                                            BButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                if(isValidScore(_homeScoreController.text, _awayScoreController.text)) {
                                                  String homeScore = _homeScoreController.text;
                                                  String awayScore = _awayScoreController.text;
                                                  var data = await SemifinalHelper.updateSemifinalMatches(
                                                    matchID: "${_listMatch[index].matchID}",
                                                    leg: "${widget.title}",
                                                    homeTeamId: "${_listMatch[index].homeTeamID}",
                                                    awayTeamId: "${_listMatch[index].awayTeamID}",
                                                    homeScore: homeScore,
                                                    awayScore: awayScore,
                                                  );
                                                  if (data['success']) {
                                                    loadSemifinalData();
                                                  } else {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showDialog(
                                                      context: this.context,
                                                      builder: (context) => BDialog(
                                                        title: "ERROR",
                                                        description: "${data['message']}",
                                                        dialogType: BDialogType.ERROR,
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
                                                } else {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => BDialog(
                                                      title: "ERROR",
                                                      description: "Input tidak valid!",
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
                                              },
                                              label: Text("Ok"),
                                            ),
                                          ],
                                        )
                                      );
                                    },
                                    label: Text("Save"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              child: Column(
                                children: [
                                  CircleAvatar(backgroundColor: Colors.blue, child: Text("${_listMatch[index].homeTeamName!.substring(0,1)}"),),
                                  Text("${_listMatch[index].homeTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                            Text("${_listMatch[index].homeScore} - ${_listMatch[index].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            Container(
                              width: 100,
                              child: Column(
                                children: [
                                  CircleAvatar(backgroundColor: Colors.orange, child: Text("${_listMatch[index].awayTeamName!.substring(0,1)}"),),
                                  Text("${_listMatch[index].awayTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Container(
              child: Center(
                child: Text("ERR: $_errMessage"),
              ),
            ),
          ),
        );
      }
    }
  }
}
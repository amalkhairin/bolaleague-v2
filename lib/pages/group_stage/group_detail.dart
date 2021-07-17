import 'dart:io';

import 'package:bolalucuv2/component/button/b_button.dart';
import 'package:bolalucuv2/component/dialog/b_dialog.dart';
import 'package:bolalucuv2/config/group_helper.dart';
import 'package:bolalucuv2/config/user_helper.dart';
import 'package:bolalucuv2/constant/colors.dart';
import 'package:bolalucuv2/model/match_model.dart';
import 'package:bolalucuv2/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupStage extends StatefulWidget {
  final String? title;
  const GroupStage({ Key? key, this.title }) : super(key: key);

  @override
  _GroupStageState createState() => _GroupStageState();
}

class _GroupStageState extends State<GroupStage> {
  List<int> _matchDay = [1,2,3,4,5,6];
  int? _selectedMatchIndex;
  User _user = User.instance;
  bool _isLoading = false;
  bool _isError = false;
  String _errMessage = "";
  List _groupStandings = [];
  List<MatchModel> _listMatches = []; 
  List<TextEditingController> _listHomeScoreController = List.generate(6, (index) => TextEditingController());
  List<TextEditingController> _listAwayScoreController = List.generate(6, (index) => TextEditingController());

  isValidScore(String home, String away){
    try {
      int skor1 = int.parse(home);
      int skor2 = int.parse(away);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  isUserGroup(){
    bool isExist = false;
    for (Map<String,dynamic> data in _groupStandings) {
      if (data['owner_id'] == _user.ownerId){
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  isUserMatch(int matchday) {
    bool isExist = false;
    for (MatchModel data in _listMatches) {
      if(matchday == data.matchDay){
        if (data.homeTeamID == _user.ownerId || data.awayTeamID == _user.ownerId) {
          isExist = true;
          break;
        }
      }
    }
    return isExist;
  }

  getMatchOfDay(int matchday) {
    List<MatchModel> _temp = [];
    for (MatchModel data in _listMatches) {
      if(matchday == data.matchDay){
        _temp.add(data);
      }
    }
    return _temp;
  }

  loadGroupData() async {
    setState(() {
      _isLoading = true;
    });
    List<MatchModel> _temp = [];
    var data = await GroupHelper.getGroupStanding(groupName: widget.title);
    var data2 = await GroupHelper.getGroupMatches(groupName: widget.title);
    if (data['success'] && data2['success']) {
      for (Map<String, dynamic> match in data2['data']) {
        _temp.add(MatchModel.fromJson(match));
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _groupStandings = data['data'];
          _listMatches = _temp;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errMessage = data['message'] + "&" + data2['message'];
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGroupData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: CircularProgressIndicator(color: whiteColor,),
              )
            ),
          ),
        ),
      );
    } else {
      if(!_isError) {
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
            title: Text("Group Stage", style: TextStyle(color: blackColor),),
            actions: [
              TextButton(
                onPressed: () async {
                  loadGroupData();
                },
                child: Text("Refresh"),
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 14),
                    child: Text("Group ${widget.title!}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Container(
                      width: screenSize.width,
                      // height: 200,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dividerThickness: 1,
                          columns: [
                            DataColumn(label: Text("No")),
                            DataColumn(label: Text("Team")),
                            DataColumn(label: Text("P")),
                            DataColumn(label: Text("M")),
                            DataColumn(label: Text("M")),
                            DataColumn(label: Text("S")),
                            DataColumn(label: Text("K")),
                            DataColumn(label: Text("GM")),
                            DataColumn(label: Text("GK")),
                            DataColumn(label: Text("+/-")),
                          ],
                          rows: List.generate(4, (i) {
                            return DataRow(
                              cells: [
                                DataCell(Text("${i+1}")),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        String msg = "Halo bro, kita berdua masih punya jadwal pertandingan. jadi kita bisa main kapan? nama tim saya ${_user.teamName}";
                                        var url = "whatsapp://send?phone=${_groupStandings[i]['no_wa']}&text=$msg";
                                        launch(url);
                                      },
                                      icon: Icon(Icons.chat,color: blueColor,)
                                    ),
                                    Text("${_groupStandings[i]['team_name']}"),
                                  ],
                                )),
                                DataCell(Text("${_groupStandings[i]['poin']}")),
                                DataCell(Text("${_groupStandings[i]['main']}")),
                                DataCell(Text("${_groupStandings[i]['menang']}")),
                                DataCell(Text("${_groupStandings[i]['seri']}")),
                                DataCell(Text("${_groupStandings[i]['kalah']}")),
                                DataCell(Text("${_groupStandings[i]['gm']}")),
                                DataCell(Text("${_groupStandings[i]['gk']}")),
                                DataCell(Text("${_groupStandings[i]['jumlah']}")),
                              ]
                            );
                          })
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 14),
                    child: Text("Recent Match", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 14),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder:(context, matchIndex) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Matchday ${matchIndex+1}"),
                          SizedBox(height: 14,),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: (context, cardIndex){
                              List<MatchModel> _temp = getMatchOfDay(matchIndex+1);
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: (_temp[cardIndex].homeTeamID == _user.ownerId || _temp[cardIndex].awayTeamID == _user.ownerId) && _temp[cardIndex].isFinished != 1
                                    ? ExpansionTile(
                                      collapsedBackgroundColor: Color(0xFFFBFBFB),
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Column(
                                              children: [
                                                CircleAvatar(backgroundColor: Colors.blue, child: Text("${_temp[cardIndex].homeTeamName!.substring(0,1)}"),),
                                                Text("${_temp[cardIndex].homeTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                              ],
                                            ),
                                          ),
                                          Text("${_temp[cardIndex].homeScore} - ${_temp[cardIndex].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                          Container(
                                            width: 100,
                                            child: Column(
                                              children: [
                                                CircleAvatar(backgroundColor: Colors.orange, child: Text("${_temp[cardIndex].awayTeamName!.substring(0,1)}"),),
                                                Text("${_temp[cardIndex].awayTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                                                      controller: _listHomeScoreController[matchIndex],
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
                                                      controller: _listAwayScoreController[matchIndex],
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
                                                            if(isValidScore(_listHomeScoreController[matchIndex].text, _listAwayScoreController[matchIndex].text)) {
                                                              String homeScore = _listHomeScoreController[matchIndex].text;
                                                              String awayScore = _listAwayScoreController[matchIndex].text;
                                                              var data = await GroupHelper.updateGroupMatches(
                                                                groupName: widget.title,
                                                                matchID: "${_temp[cardIndex].matchID}",
                                                                homeTeamId: "${_temp[cardIndex].homeTeamID}",
                                                                awayTeamId: "${_temp[cardIndex].awayTeamID}",
                                                                homeScore: homeScore,
                                                                awayScore: awayScore,
                                                              );
                                                              if (data['success']) {
                                                                loadGroupData();
                                                              } else {
                                                                setState(() {
                                                                  _isLoading = false;
                                                                });
                                                                showDialog(
                                                                  context: context,
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
                                              CircleAvatar(backgroundColor: Colors.blue, child: Text("${_temp[cardIndex].homeTeamName!.substring(0,1)}"),),
                                              Text("${_temp[cardIndex].homeTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                        ),
                                        Text("${_temp[cardIndex].homeScore} - ${_temp[cardIndex].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                        Container(
                                          width: 100,
                                          child: Column(
                                            children: [
                                              CircleAvatar(backgroundColor: Colors.orange, child: Text("${_temp[cardIndex].awayTeamName!.substring(0,1)}"),),
                                              Text("${_temp[cardIndex].awayTeamName}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
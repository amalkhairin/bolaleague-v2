import 'dart:io';

import 'package:bolalucuv2/component/button/b_button.dart';
import 'package:bolalucuv2/component/dialog/b_dialog.dart';
import 'package:bolalucuv2/config/quarter_helper.dart';
import 'package:bolalucuv2/constant/colors.dart';
import 'package:bolalucuv2/model/match_model.dart';
import 'package:bolalucuv2/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QuarterLegDetailPage extends StatefulWidget {
  final String? title;
  const QuarterLegDetailPage({ Key? key, this.title}) : super(key: key);

  @override
  _QuarterLegDetailPageState createState() => _QuarterLegDetailPageState();
}

class _QuarterLegDetailPageState extends State<QuarterLegDetailPage> {
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

  loadQuarterData() async {
    setState(() {
      _isLoading = true;
    });
    List<MatchModel2> _temp = [];
    var data = await QuarterHelper.getQuarterMatches(leg: widget.title);
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
    loadQuarterData();
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
            title: Text("Quarter Final - Leg ${widget.title}", style: TextStyle(color: blackColor),),
            actions: [
              TextButton(
                onPressed: () async {
                  loadQuarterData();
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
                        child: Row(
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
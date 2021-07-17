import 'package:bolalucuv2/config/app_helper.dart';
import 'package:bolalucuv2/constant/colors.dart';
import 'package:bolalucuv2/pages/semifinal/semifinal_leg_detail.dart';
import 'package:flutter/material.dart';

class SemifinalListPage extends StatefulWidget {
  const SemifinalListPage({ Key? key }) : super(key: key);

  @override
  _SemifinalListPageState createState() => _SemifinalListPageState();
}

class _SemifinalListPageState extends State<SemifinalListPage> {
  bool _isLoading = false;
  bool _isError = false;
  bool? _isOpen;
  String _errMessage = "";

  Future<dynamic> checkPhase() async {
    setState(() {
      _isLoading = true;
    });
    var data = await AppHelper.isOpenPhase(phaseID: 4);
    if (data['success']) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _isOpen = data['data'];
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
    checkPhase();
  }
  
  @override
  Widget build(BuildContext context) {
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
        if (_isOpen!) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: backgroundColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
              ),
              title: Text("SemiFinal", style: TextStyle(color: blackColor),),
            ),
            body: SafeArea(
              child: Container(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SemifinalLegDetailPage(title: "${index+1}",))
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text("Leg ${index+1}"),
                          ),
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: backgroundColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
              ),
              title: Text("SemiFinal", style: TextStyle(color: blackColor),),
            ),
            body: SafeArea(
              child: Container(
                child: Center(
                  child: Text("Fase/babak ini belum dimulai"),
                ),
              ),
            ),
          );
        }
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
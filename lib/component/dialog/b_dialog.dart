import 'package:flutter/material.dart';

enum BDialogType {
  SUCCESS,
  FAILED,
  ERROR,
  INFO
}

class BDialog extends StatelessWidget {
  final String? title,description;
  final BDialogType? dialogType;
  final List<Widget>? action;
  const BDialog({ Key? key, @required this.title, @required this.description,this.dialogType,this.action }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // dialog icon container
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: dialogTypeIcon(dialogType!)
            ),
            SizedBox(height: 14,),

            // dialog title
            Text(title!, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 14,),

            // dialog description
            Text(description!, textAlign: TextAlign.center,),
            SizedBox(height: 14,),

            // dialog button
            Row(
              children: [
                action!.isNotEmpty? Flexible(child: action![0]) : Container(),
                action!.length > 1
                  ? SizedBox(width: 8,)
                  : Container(),
                action!.length > 1 ? Flexible(child: action![1]) : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
  
  dialogTypeIcon(BDialogType type) {
    switch (type) {
      case BDialogType.SUCCESS:
        return Icon(Icons.check_circle, size: 100, color: Colors.green,);
      case BDialogType.FAILED:
        return Icon(Icons.cancel_rounded, size: 100, color: Colors.red,);
      case BDialogType.ERROR:
        return Icon(Icons.wifi_tethering_error_rounded, size: 100, color: Colors.red,);
      default:
        return Icon(Icons.info_rounded, size: 100, color: Colors.blue,);
    }
  }
}
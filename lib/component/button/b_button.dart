import 'package:bolalucuv2/constant/colors.dart';
import 'package:flutter/material.dart';

enum BButtonStyle {
  PRIMARY,
  SECONDARY
}

class BButton extends StatelessWidget {
  final Key? key;
  final Widget? label;
  final Widget? icon;
  final BButtonStyle? style;
  final Function()? onPressed;
  const BButton({
    this.key,
    @required this.label,
    this.icon,
    this.style,
    @required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: 52,
      width: screenSize.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style == BButtonStyle.PRIMARY || style == null
          ? ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: blueColor,
            onPrimary: whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )
          : ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: whiteColor,
            onPrimary: blueColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: blueColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon?? Container(),
            icon != null? SizedBox(width: 8,) : Container(),
            label!
          ],
        ),
      )
    );
  }
}
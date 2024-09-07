import 'package:flutter/material.dart';
import 'package:loading_btn/loading_btn.dart';

class MyCustomSnackBar {
  final BuildContext context;
  final String message;
  final IconData? leadingIcon;
  final Duration duration;
  final Color bgColor;
  final Color leadingIconColor;

  MyCustomSnackBar(
      {required this.context,
      required this.message,
      this.leadingIcon,
      this.bgColor = Colors.red,
      this.duration = const Duration(seconds: 2),
      this.leadingIconColor = Colors.green});

  void show() {
    final snackBar = SnackBar(
      backgroundColor: bgColor,
      content: Row(
        children: [
          if (leadingIcon != null) Icon(leadingIcon, color: leadingIconColor),
          SizedBox(width: leadingIcon != null ? 8 : 0),
          Expanded(child: Text(message)),
        ],
      ),
      duration: duration,
    );
    ScaffoldMessenger.of(context).clearSnackBars(); //clear all other snackbars
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class MyCustomAsyncButton extends StatelessWidget {
  final Future<void> Function() btnOnTap;
  final Color backgroundColor;
  final Color txtColor;
  final double btnHeight;
  final double btnWidth;
  final String btnText;
  final double fontSize;
  final double btnElevation;
  final double borderRadius;

  MyCustomAsyncButton({
    required this.btnOnTap,
    this.backgroundColor = Colors.green,
    this.txtColor = Colors.white,
    this.btnHeight = 0,
    this.btnWidth = 0,
    this.btnText = "",
    this.fontSize = 0,
    this.btnElevation = 3,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    double scrH = MediaQuery.of(context).size.height;
    double scrW = MediaQuery.of(context).size.width;

    return LoadingBtn(
      elevation: btnElevation,
      height: btnHeight == 0 ? scrH * 0.07 : btnHeight,
      width: btnWidth == 0 ? scrW : btnWidth,
      borderRadius: borderRadius,
      animate: false,
      color: backgroundColor,
      loader: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          color: Colors.blue,
          child: const CircularProgressIndicator(),
        ),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          fontFamily: 'NotoSansEthiopic',
          fontSize: fontSize == 0 ? scrH * 0.025 : fontSize,
          fontWeight: FontWeight.bold,
          color: txtColor,
        ),
      ),
      onTap: (startLoading, stopLoading, btnState) async {
        if (btnState == ButtonState.idle) {
          startLoading();
          await btnOnTap();
          stopLoading();
        }
      },
    );
  }
}

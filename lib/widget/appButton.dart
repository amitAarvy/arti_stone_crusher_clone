import 'package:flutter/material.dart';

import '../utils/color.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double fontSize;
  final bool isLoading;
  final  double height;
  final Color colorText;

  const AppButton({
    Key? key,
    this.text = 'Button',
    this.colorText = Colors.white,
    this.onPressed,
     this.backgroundColor = const Color(0xffE8710F),
    this.fontSize = 16.0,  this.isLoading=false,  this.height =50.0,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
        child:Center(
          child: isLoading?SizedBox(height:20,width:20,child: CircularProgressIndicator(color: Colors.white,)):
          Text(
            text,
            style: TextStyle(fontSize: fontSize, color: colorText, fontWeight: FontWeight.bold),
          ),
        ),


        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: backgroundColor,
        //     padding: const EdgeInsets.symmetric(vertical: 13),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //   ),
        //   onPressed: onPressed,
        //
        // ),
      ),
    );
  }
}
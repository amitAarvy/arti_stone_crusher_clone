import 'package:arti_stone_crusher/utils/Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Background extends StatelessWidget {
  final Widget mainContent;
  final Widget topWidget;
  const Background({super.key, required this.mainContent, required this.topWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 1.sw,
      decoration: BoxDecoration(
        image: DecorationImage(image:  AssetImage(Images.bgHome),fit: BoxFit.cover )
      ),
      child: Stack(
        // alignment: Alignment.bottomCenter,
        children: [
          topWidget,
           Align(
             alignment: Alignment.bottomCenter,
             child: Container(
               height: 0.8.sh,
               width: 1.sw,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(40),
                   topRight: Radius.circular(40),
                 ),
               ),
               child: mainContent,
             ),
           )

          
          
        ],
      ),
    );
  }
}

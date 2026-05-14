import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'enum.dart';

class Utils{
  static void showFlushBar(String message, FlushBarType flushBarType, BuildContext context){
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      forwardAnimationCurve: Curves.decelerate,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      message: message,
      messageColor: flushBarType == FlushBarType.warn ? Colors.black : Colors.white,
      duration: const Duration(seconds: 2),
      backgroundColor: flushBarType == FlushBarType.success ? Colors.green : flushBarType == FlushBarType.error ? Colors.red : Colors.yellow,
      borderRadius: BorderRadius.circular(10),
      icon: Icon(
        flushBarType == FlushBarType.success ?
        Icons.check_circle :
        flushBarType == FlushBarType.error ?
        Icons.error :
        Icons.warning,
        color: flushBarType == FlushBarType.warn ? Colors.black : Colors.white,
      ),
    ).show(context);
  }

static Future datePickerCommon(BuildContext context)async{
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    return picked;
  }
}
static Future<TimeOfDay?> timePickerCommon(BuildContext context)async{
  TimeOfDay selectedTime = TimeOfDay.now();
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );
  if (picked != null && picked != selectedTime) {
   return picked;
  }
}

  // static Future<File?> pickImage()async{
  //   ImagePicker picker = ImagePicker();
  //   XFile? pickedXFile = await picker.pickImage(source: ImageSource.gallery);
  //   File? image = pickedXFile == null ? null : File(pickedXFile.path);
  //   return image;
  // }
  //
  // static Future<File?> pickVideo()async{
  //   ImagePicker picker = ImagePicker();
  //   XFile? pickedXFile = await picker.pickVideo(source: ImageSource.gallery);
  //   File? video = pickedXFile == null ? null : File(pickedXFile.path);
  //   return video;
  // }
  //
  // static String parseHtmlToPlainText(String htmlString) {
  //   final unescape = HtmlUnescape();
  //   String decodedHtml = unescape.convert(htmlString);
  //   decodedHtml = decodedHtml.replaceAll('Â', '');
  //   final document = parse(decodedHtml);
  //   final String parsedText = document.body?.text ?? '';
  //   return parsedText;
  // }
  //
  // static showUpgradeMembershipMsg(BuildContext context){
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: Container(
  //           width: double.infinity,
  //           margin: const EdgeInsets.all(50),
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10)
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Image.asset(ImageIcons.logo, scale: 3),
  //               const SizedBox(height: 20),
  //               const Text("Your membership is expired or you are not a paid member, please upgrade your membership now.", textAlign: TextAlign.center,),
  //               const SizedBox(height: 10),
  //               Align(
  //                 child: ElevatedButton(
  //                   style: ButtonStyle(
  //                       backgroundColor: MaterialStateProperty.resolveWith((states) => K.secondaryColor)
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                     Navigator.push(context, MaterialPageRoute(builder: (context) => const UpgradeMembershipScreen()));
  //                   },
  //                   child: const Text("Upgrade", style: TextStyle(color: Colors.white)),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // static showInterestOptions(BuildContext context, Function(String value) onTap){
  //   List<String> messages = [
  //     "I am interested in your profile. Please Accept if you are interested.",
  //     "You are the kind of person we have been looking for. Please respond to proceed further.",
  //     "We liked your profile and interested to take it forward. Please reply at the earliest.",
  //     "You seem to be the kind of person who suits our family. We would like to contact your parents to proceed further.",
  //     "You profile matches my sister's/brother's profile. Please 'Accept' if you are interested.",
  //     "Our children's profile seems to match. Please reply to proceed further.",
  //     "We find a good life partner in you for our friend. Please reply to proceed further.",
  //   ];
  //   ValueNotifier<String> selectedInterest = ValueNotifier(messages[0]);
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: Container(
  //           width: double.infinity,
  //           margin: const EdgeInsets.all(50),
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10)
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Image.asset(ImageIcons.logo, scale: 3),
  //               const SizedBox(height: 20),
  //               ValueListenableBuilder(
  //                 valueListenable: selectedInterest,
  //                 builder: (context, selected, child) {
  //                   return Column(
  //                     children: messages.map((e){
  //                       return Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 3.0),
  //                         child: Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Material(
  //                               child: Checkbox(
  //                                 value: e == selected,
  //                                 onChanged: (value) {
  //                                   selectedInterest.value = e;
  //                                 },
  //                               ),
  //                             ),
  //                             Expanded(child: Text(e)),
  //                           ],
  //                         ),
  //                       );
  //                     }).toList(),
  //                   );
  //                 },
  //               ),
  //               const SizedBox(height: 10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   ElevatedButton(
  //                     style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.resolveWith((states) => K.secondaryColor)
  //                     ),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text("Cancel", style: TextStyle(color: Colors.white)),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ElevatedButton(
  //                     style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.resolveWith((states) => K.secondaryColor)
  //                     ),
  //                     onPressed: () => onTap(selectedInterest.value),
  //                     child: const Text("Send", style: TextStyle(color: Colors.white)),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


}
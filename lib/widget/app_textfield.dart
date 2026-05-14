import 'package:arti_stone_crusher/utils/color.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? imageIcon;
  final String? hintText;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showTitle;
  final bool isRequired;
  final String? title;
  final int? maxLength;
  final int? maxLine;
 final ValueChanged<String>? onChanged;
  final IconButton? suffixIcon;
  final Widget? prefix;
  final bool isReadOnly ;
  final String? preffixIcon;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    this.maxLength,
    this.hintText,
    this.isReadOnly = false,
    this.prefix,
    this.onChanged,
    this.maxLine,
    this.icon,
    this.isRequired = false,
    this.keyboardType = TextInputType.text, // Default value
    this.obscureText = false, // Default: Not hidden
    this.suffixIcon, // Optional
    this.validator, this.preffixIcon, this.imageIcon,  this.showTitle = false, this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(showTitle)
          Row(
            children: [
              Text(title.toString(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),),
              if(isRequired)
                Text(' *',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.red),),

            ],
          ),
        if(showTitle)
          SizedBox(height: 5,),
        SizedBox(
          height: maxLine==null?40:null,
          child: TextFormField(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLine,
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: isReadOnly,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 5,left: 10),
              counterText: '',
              prefixIcon:prefix ,
              hintText: hintText ?? '',
              suffixIcon: suffixIcon,
              focusColor: K.darkOrange,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: K.darkOrange),
                ),
              focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: K.darkOrange),

                ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: K.darkOrange),

              ),

            ),
            validator: validator,
            onChanged: onChanged,

          ),
        ),
      ],
    );
  }
}
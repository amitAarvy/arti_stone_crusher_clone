import 'package:arti_stone_crusher/utils/color.dart';
import 'package:flutter/material.dart';




class AppDropdown extends StatefulWidget {
  AppDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.selectedItemBuilder,
    required this.value,
    required this.hintText,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.itemHeight,
    this.fillColor,
    this.focusColor,
    this.focusNode,
    this.dropdownColor =const Color(0xffE8710F),
    this.decoration,
    this.onSaved,
    this.validator,
    this.validate = false,
    this.borderColor = const Color(0xffE8710F), // Default border color
    this.loading,
    required this.showTitle,
    required this.title,
    this.isReadOnly =false
  }) : super(key: key);

  final ValueChanged onChanged;
  final List<DropdownMenuItem<String>>? items;
  final DropdownButtonBuilder? selectedItemBuilder;
  String? value;
  final String hintText;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final Color? borderColor;
  final double? itemHeight;
  final Color? focusColor;
  final bool validate;
  final Color? fillColor;
  final bool showTitle;
  final String title;
  final FocusNode? focusNode;
  final Color? dropdownColor;
  final InputDecoration? decoration;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final String? icon;
  final bool? loading;
  final bool isReadOnly;

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  final bool isDense = true;

  final bool isExpanded = false;

  final bool autofocus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(widget.showTitle) Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Row(
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.grey)),
              if(widget.validate==true)Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        if(widget.showTitle) const SizedBox(height: 5),
        Material(
          // elevation: 1.8,
          shadowColor:  widget.dropdownColor,
          borderRadius: BorderRadius.circular(8),
          child: DropdownButtonFormField<String>(

            isExpanded: true,
            hint: Text(widget.hintText),
            value: widget.value,
            validator: widget.validator,

            decoration: InputDecoration(
              focusColor: K.darkOrange,
              focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color:widget.borderColor!),
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 9.5,
              ),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color:widget.borderColor!),
              ),
              filled: true,
              fillColor: widget.fillColor ==null?Colors.white:widget.fillColor,
            ),
            icon: widget.loading == true
                ?SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2.0,))
                : const Icon(Icons.keyboard_arrow_down),
            onChanged:widget.isReadOnly?null: (value) {
              setState(() {
                widget.value = value;
              });
              if (widget.onChanged != null) widget.onChanged(value);
            },
            items: widget.items,

          ),
        ),
      ],
    );
  }
}

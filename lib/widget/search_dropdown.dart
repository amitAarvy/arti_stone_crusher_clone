import 'package:arti_stone_crusher/utils/color.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class PartyDropdown extends StatefulWidget {
  final List content;
   final String?value;
  final String title;
  final String valueId;
  final String valueText;
  final ValueChanged onChanged;
  final bool showTitle;
  // final String? title;
  const PartyDropdown({super.key, required this.content, this.value, required this.title, required this.valueId, required this.valueText, required this.onChanged,  this.showTitle=false});

  @override
  State<PartyDropdown> createState() => _PartyDropdownState();
}

class _PartyDropdownState extends State<PartyDropdown> {
  final TextEditingController searchParty = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // String? selectParty;

  // List<Map<String, dynamic>> partYList = [
  //   {'party_id': '1', 'company_name': 'Apple Pvt Ltd'},
  //   {'party_id': '2', 'company_name': 'Banana Corp'},
  //   {'party_id': '3', 'company_name': 'Mango Ltd'},
  //   {'party_id': '4', 'company_name': 'Grapes Enterprises'},
  // ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // rebuild to change border color on focus
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.showTitle) Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Row(
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.grey)),
              // if(widget.validate==true)Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        if(widget.showTitle) const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focusNode.hasFocus ? K.darkOrange : K.darkOrange, // Focus color change
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ),
              focusNode: _focusNode, // 👈 Needed to detect focus
              hint: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w500
                ),
              ),
              items: widget.content
                  .map((item) => DropdownMenuItem(
                value: item[widget.valueId].toString(),
                child: Text(
                  item[widget.valueText].toString(),
                  style:  TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                ),
              ))
                  .toList(),
              value: widget.value,
              onChanged: widget.onChanged,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 300,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: searchParty,
                searchInnerWidgetHeight: 60,
                searchInnerWidget: Container(
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: searchParty,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        // vertical: 10,
                      ),
                      hintText: 'Search ...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  final search = searchValue.toLowerCase();
                  if (item.child is Text) {
                    final itemText = (item.child as Text).data?.toLowerCase() ?? '';
                    return itemText.contains(search);
                  }
                  final itemValue = item.value?.toLowerCase() ?? '';
                  return itemValue.contains(search);
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  searchParty.clear();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

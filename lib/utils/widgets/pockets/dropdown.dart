import 'package:flutter/material.dart';

class IconDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final String? selectedValue;
  final Function(String?)? onChanged;

  const IconDropdown({
    Key? key,
    required this.items,
    this.selectedValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _IconDropdownState createState() => _IconDropdownState();
}

class _IconDropdownState extends State<IconDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
          isExpanded: true,
          items: widget.items.map<DropdownMenuItem<String>>((DropdownItem item) {
            return DropdownMenuItem<String>(
              value: item.title,
              child: Row(
                children: [
                 
                  
                  Text(item.title),
                ],
              ),
            );
          }).toList(),
          hint: Row(
            children: [
              Text('Select'),
         
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownItem {
  final String title;
  final IconData? icon;

  DropdownItem({required this.title,   this.icon});
}

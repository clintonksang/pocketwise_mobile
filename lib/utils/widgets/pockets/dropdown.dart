import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/dropdown_provider.dart';

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
        final dropdownProvider = Provider.of<DropdownProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
              
              });
                 dropdownProvider.setSelectedValue(newValue);
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
                    if (item.icon != null) // Check for icon presence
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(item.icon, size: 20),
                      ),
                    Expanded( // Use Expanded to prevent overflow
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedValue != null ? _trimText(selectedValue!) : 'Select',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_drop_down), // Always show dropdown icon
              ],
            ),
            icon: SizedBox.shrink(), // Hide default dropdown icon
          ),
        ),
      ),
    );
  }

  String _trimText(String text) {
   
    final words = text.split(' ');
    return words.length > 11 ? words.take(11).join(' ') + '...' : text;
  }
}

class DropdownItem {
  final String title;
  final IconData? icon;


  DropdownItem({required this.title, this.icon});
}

import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String selectedItem;
  final List<String> listItem;
  final ValueChanged<String> onChanged;

  const Dropdown({
    Key? key,
    required this.selectedItem,
    required this.listItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedItem = value;
          });
          widget.onChanged(value);
        }
      },
      items: widget.listItem.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Smooth rounded corners
          borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      isExpanded: true,
      menuMaxHeight: 250, // Clear scroll when there are many options
      icon: Icon(Icons.arrow_drop_down_rounded,
          size: 28, color: Colors.grey[700]), // Modern icon
      style: TextStyle(color: Colors.black, fontSize: 16),
    );
  }
}

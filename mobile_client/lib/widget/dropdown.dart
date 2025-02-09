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
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      dropdownColor: Colors.white,
      isExpanded: true,
      menuMaxHeight: 200,
    );
  }
}

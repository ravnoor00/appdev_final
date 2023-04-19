import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final String title;
  final ValueChanged<bool> onChanged;
  final bool isSelected;

  const CustomToggleButton({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButton();
}

class _CustomToggleButton extends State<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    Color lightBrown = Color(0xFFD2B48C);
    Color orange = Colors.orange;
    Color black = Colors.black;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: TextButton(
        onPressed: () {
          widget.onChanged(!widget.isSelected);
        },
        style: TextButton.styleFrom(
          backgroundColor: lightBrown,
          side: BorderSide(
            color: widget.isSelected ? orange : black,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          widget.title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


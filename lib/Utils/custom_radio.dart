import 'package:flutter/material.dart';
import '../../Utils/flutter_colour_theams.dart';

class CustomRadio extends StatelessWidget {
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  CustomRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      splashColor: Colors.transparent, // Set splash color
      highlightColor: Colors.transparent, // Set highlight color
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: groupValue == value
            ? Center(
          child: Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue1,
            ),
          ),
        )
            : null,
      ),
    );
  }
}

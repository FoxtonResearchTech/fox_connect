import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final VoidCallback? onTap; // Add onTap parameter
  final void Function(String?)? onSaved; // Add onSaved property

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onTap, // Initialize onTap
    this.onSaved, // Initialize onSaved
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      onTap: onTap, // Set the onTap callback here
      onSaved: onSaved, // Set the onSaved callback
      readOnly: onTap != null, // Make the field read-only if onTap is set
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black87,
          fontFamily: 'LeagueSpartan',
        ), // Updated color for label
        prefixIcon: icon != null
            ? Icon(icon, color: Color(0xffFF0000))
            : null, // Updated icon color
        filled: false,
        fillColor: Colors.blue, // Updated background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Color(0xffFF0000)), // Accent color for the outline border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Color(0xffFF0000), width: 2), // Focus color
        ),
      ),
    );
  }
}

class TaskRegTextFormField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final void Function(String?)? onSaved;

  const TaskRegTextFormField({
    Key? key,
    required this.labelText,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      onTap: onTap,
      onSaved: onSaved,
      readOnly: onTap != null,
      maxLines: null, // Allows unlimited lines while typing
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontFamily: 'LeagueSpartan',
        ),
        prefixIcon:
            icon != null ? Icon(icon, color: const Color(0xffFF0000)) : null,
        filled: false,
        fillColor: Colors.blue,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffFF0000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffFF0000), width: 2),
        ),
      ),
      style: const TextStyle(
        overflow:
            TextOverflow.visible, // Ensures text wraps when exceeding one line
      ),
    );
  }
}

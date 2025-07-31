import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



Widget buildDropdownField({
  required String label,
  required String? value,
  required List<String> items,
  required IconData icon,
  required Function(String?) onChanged,
  String? Function(String?)? validator,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          // decoration: BoxDecoration(
          //   color: Color(0xFF1E88E5).withOpacity(0.1),
          //   borderRadius: BorderRadius.circular(8),
          // ),
          child: Icon(
            icon,
            color: Color(0xFF1E88E5),
            size: 20,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF1E88E5), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      icon: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF1E88E5),
          size: 24,
        ),
      ),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
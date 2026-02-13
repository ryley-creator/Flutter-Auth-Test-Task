import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextfield extends StatelessWidget {
  const AuthTextfield({
    super.key,
    required this.textAlign,
    required this.hintText,
    required this.controller,
    required this.isLoading,
    required this.sendCode,
    required this.buttonText,
    required this.icon,
    required this.labelText,
    required this.textInputType,
    required this.fontSize,
    this.inputFormatters,
    this.letterSpacing,
  });
  final String hintText;
  final String labelText;
  final String buttonText;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback sendCode;
  final TextInputType textInputType;
  final IconData icon;
  final double? letterSpacing;
  final double fontSize;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          textAlign: textAlign,
          inputFormatters: inputFormatters,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, letterSpacing: letterSpacing),
          controller: controller,
          keyboardType: textInputType,
          enabled: !isLoading,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade700, width: 2),
            ),
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : sendCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(buttonText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

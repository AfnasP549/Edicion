import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final InputBorder? border;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,hintStyle: TextStyle(color: AppColors.border),
        border: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
    );
  }
}

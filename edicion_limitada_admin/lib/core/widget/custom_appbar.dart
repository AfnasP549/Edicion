import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? action;

  const CustomAppbar(
      {super.key,
      required this.title,
      this.leadingIcon,
      this.onLeadingPressed,
      this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      leading: leadingIcon != null
          ? IconButton(onPressed: onLeadingPressed, icon: Icon(leadingIcon))
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: action,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

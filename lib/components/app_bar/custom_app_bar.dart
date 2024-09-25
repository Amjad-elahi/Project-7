import 'package:flutter/material.dart';
import 'package:project_judge/components/text/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, required this.text, this.actions, this.backArrow});
  final String text;
  final List<Widget>? actions;
  final bool? backArrow;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: backArrow ?? true,
      backgroundColor: const Color(0xff4E2EB5),
      foregroundColor: Colors.white,
      title: CustomText(
        text: text,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

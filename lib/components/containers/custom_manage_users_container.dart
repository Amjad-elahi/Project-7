import 'package:flutter/material.dart';
import 'package:project_judge/components/text/custom_text.dart';

class CustomManageUsersContainer extends StatelessWidget {
  const CustomManageUsersContainer({
    super.key,
    required this.position,
    this.onChanged,
    required this.isSwitched,
  });
  final String position;
  final Function(bool)? onChanged;
  final bool isSwitched;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                blurRadius: 2, blurStyle: BlurStyle.outer, offset: Offset(0, 3))
          ]),
      child: ListTile(
        title: CustomText(
          text: position,
          size: 14,
          color: const Color(0xff262626),
        ),
        trailing: Switch(
          value: isSwitched,
          onChanged: onChanged,
          activeColor: const Color(0xff57E3D8),
          thumbColor: const WidgetStatePropertyAll(Colors.white),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.white),
          inactiveTrackColor: const Color(0xff848484),
        ),
      ),
    );
  }
}

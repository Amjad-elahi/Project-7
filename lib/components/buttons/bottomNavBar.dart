import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final VoidCallback onMiddleButtonTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onMiddleButtonTapped,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const bottomNavBarHeight = 110.0;
    const middleButtonSize = 80.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: bottomNavBarHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                buildBottomNavBarItem('assets/images/Call.png', 'Home', 0),
                buildBottomNavBarItem('assets/images/browse.png', 'Browse', 1),
                const BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: '',
                ),
                buildBottomNavBarItem(
                    'assets/images/projects.png', 'My Projects', 3),
                buildBottomNavBarItem(
                    'assets/images/profile.png', 'Profile', 4),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: bottomNavBarHeight / 1.7 - middleButtonSize / 70,
          left: (screenWidth / 2) - (middleButtonSize / 2),
          child: GestureDetector(
            onTap: onMiddleButtonTapped,
            child: Container(
              width: middleButtonSize,
              height: middleButtonSize,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  'assets/svg/bracode_icon.svg',
                  fit: BoxFit.cover,
                  width: 50,
                  height: 48,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem buildBottomNavBarItem(
      String assetPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Image.asset(
            assetPath,
            width: 20,
            height: 20,
            color: selectedIndex == index
                ? const Color(0xFF4E2EB5)
                : const Color(0xFF848484),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selectedIndex == index
                  ? const Color(0xFF4E2EB5)
                  : const Color(0xFF848484),
            ),
          ),
        ],
      ),
      label: '',
    );
  }
}

import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabController;

  const TabBarWidget({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      dividerColor: Colors.transparent,
      controller: tabController,
      indicator: const BoxDecoration(),
      unselectedLabelColor: const Color(0x99FFFFFF),
      labelColor: Colors.white,
      tabs: [
        buildFloatingTab('app', 0),
        buildFloatingTab('website', 1),
        buildFloatingTab('vr', 2),
        buildFloatingTab('ar', 3),
        buildFloatingTab('ai', 4),
        buildFloatingTab('ml', 5),
        buildFloatingTab('ui/ux', 6),
        buildFloatingTab('gaming', 7),
        buildFloatingTab('unity', 8),
        buildFloatingTab('cyber', 9),
        buildFloatingTab('software', 10),
        buildFloatingTab('automation', 11),
        buildFloatingTab('robotic', 12),
        buildFloatingTab('api', 13),
        buildFloatingTab('analytics', 14),
        buildFloatingTab('iot', 15),
        buildFloatingTab('cloud', 16),
      ],
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: EdgeInsets.zero,
    );
  }

  Widget buildFloatingTab(String text, int index) {
    return Tab(
      child: AnimatedBuilder(
        animation: tabController,
        builder: (context, child) {
          final isSelected = tabController.index == index;
          return Container(
            width: 102,
            height: 33,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF5CE3D9)
                  : const Color(0x99FFFFFF),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E2EB5),
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

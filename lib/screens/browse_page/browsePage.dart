import 'package:flutter/material.dart';
import 'package:project_judge/components/tab_bar/browse_projects_page.dart';

import 'package:project_judge/components/tab_bar/tab_bar_browse.dart';
import 'package:project_judge/data_layer/data_layer.dart';
import 'package:project_judge/screens/search_screen/search_screen.dart';
import 'package:project_judge/screens/view_project_detail_screen/view_project_detail_screen.dart';
import 'package:project_judge/setup/init_setup.dart';

import '../change_project_screen/change_project_state.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  BrowsePageState createState() => BrowsePageState();
}

class BrowsePageState extends State<BrowsePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 17, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTypes = [
      'app',
      'website',
      'vr',
      'ar',
      'ai',
      'ml',
      'ui/ux',
      'gaming',
      'unity',
      'cyber',
      'software',
      'automation',
      'robotic',
      'api',
      'analytics',
      'iot',
      'cloud'
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF4E2EB5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4E2EB5),
        title: const Text("Browse", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        //apears for superviser/admin only
        actions: [
          if (getIt.get<DataLayer>().userInfo!.role != 'user')
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangeProjectStatus()));
                },
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xffffffff),
                )),
          const SizedBox(
            width: 10,
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8)),
                    height: 48,
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.search,
                          size: 22,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: TabBarWidget(tabController: tabController),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: List.generate(17, (int index) {
          String type = allTypes[index];
          var appProjects = getIt
              .get<DataLayer>()
              .projectInfo!
              .where((e) => e.type == type)
              .toList();
          return ListView(
            children: appProjects
                .map((e) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewProjectDetailScreen(
                                  projectID: e.projectId!)));
                    },
                    child: BrowseProjectsPage(project: e)))
                .toList(),
          );
        }),
      ),
    );
  }
}

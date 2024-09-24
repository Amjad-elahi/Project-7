import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_judge/components/text/custom_text.dart';
import 'package:project_judge/data_layer/data_layer.dart';
import 'package:project_judge/models/user_model.dart';
import 'package:project_judge/screens/home_screen/cubit/home_cubit.dart';
import 'package:project_judge/screens/navigation/navigationPage.dart';
import 'package:project_judge/screens/view_project_detail_screen/view_project_detail_screen.dart';
import 'package:project_judge/setup/init_setup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Home_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:
                                        "Hello, ${getIt.get<DataLayer>().userInfo?.firstName ?? 'user'}!",
                                    size: 32,
                                    color: const Color(0xffffffff),
                                  ),
                                  const CustomText(
                                    text:
                                        "Share, browse, and rate bootcamp projects!",
                                    size: 16,
                                    color: Color(0xffC4C4C4),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                "assets/images/default_img.png",
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0xff57E3D8),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  text: "Showcase Your Work",
                                  weight: FontWeight.w500,
                                  size: 24,
                                  color: Color(0xff5030B6),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const CustomText(
                                  text: "Check Out and Update Your projects ",
                                  size: 16,
                                  color: Color(0xff5030B6),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        backgroundColor:
                                            const Color(0xffffffff),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width,
                                            63)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NavigationPage(
                                                      slectedPage: 3)));
                                    },
                                    child: const Center(
                                      child: Text(
                                        "See Your Projects",
                                        style: TextStyle(
                                            color: Color(0xff4F2AB8),
                                            fontSize: 20),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const CustomText(
                          text: "Explore Projects",
                          weight: FontWeight.w500,
                          size: 24,
                          color: Color(0xffffffff),
                        ),
                        const SizedBox(height: 10),
                      ]),
                ),
                const CustomProjectsList(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xffffffff),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 63)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NavigationPage(slectedPage: 1)));
                      },
                      child: const Center(
                        child: Text(
                          "Browse All Projects",
                          style:
                              TextStyle(color: Color(0xff4F2AB8), fontSize: 20),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomProjectsList extends StatelessWidget {
  const CustomProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Projects> allProjects = getIt.get<DataLayer>().projectInfo!;

    final List<Projects> firstFifeProjects = allProjects.take(5).toList();
    return SizedBox(
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: firstFifeProjects
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewProjectDetailScreen(
                                    projectID: e.projectId!)));
                      },
                      child: CustomProjectCard(
                          img: e.logoUrl,
                          projectName: e.projectName ?? "No Project name",
                          bootcampName: e.bootcampName ?? "No Bootcamp Name"),
                    ),
                  ))
              .toList()),
    );
  }
}

// ignore: must_be_immutable
class CustomProjectCard extends StatelessWidget {
  CustomProjectCard({
    super.key,
    required this.img,
    required this.projectName,
    required this.bootcampName,
    //required this.stars
  });
  String? img;
  final String projectName;
  final String bootcampName;
  // final stars; NEED THE CUSTOM WIDGET FOR THIS !!!!!!!!
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 150,
      decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xff4E2EB5),
                  borderRadius: BorderRadius.circular(20)),
              child: Image.network(
                img ?? "https://static.thenounproject.com/png/4595376-200.png",
                // fit: BoxFit.cover, // PUT A COND HERE TO VIEW DEAFULT IF NO IMAGE IS STORED !!!!!!!!
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              text: projectName,
              size: 16,
              color: const Color(0xff4D2EB4),
              allowOverflow: true,
            ),
            CustomText(
              text: bootcampName,
              size: 12,
              color: const Color(0xffC4C4C4),
            ),
          ],
        ),
      ),
    );
  }
}

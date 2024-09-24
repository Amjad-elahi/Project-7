import 'package:barcode_widget/barcode_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:project_judge/components/buttons/custom_elevated_button.dart';
import 'package:project_judge/components/dialog/error_dialog.dart';
import 'package:project_judge/components/list_tiles/custom_project_detail_list_tile.dart';
import 'package:project_judge/components/text/custom_text.dart';
import 'package:project_judge/screens/view_project_detail_screen/cubit/view_project_details_cubit.dart';
import 'package:project_judge/setup/init_setup.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/buttons/custom_icon_button.dart';
import '../../components/cards/custom_team_member_card.dart';
import '../../components/containers/custom_slider_containers.dart';
import '../../components/custom_paints/tuwaiq_logo_paint.dart';
import '../../components/icons/custom_rate_icon.dart';
import '../../data_layer/data_layer.dart';

class ViewProjectDetailScreen extends StatelessWidget {
  const ViewProjectDetailScreen({
    super.key,
    required this.projectID,
  });
  final String projectID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewProjectDetailsCubit()..loadProjectDetail(),
      child: Builder(builder: (context) {
        final currentProject = getIt
            .get<DataLayer>()
            .projectInfo
            ?.firstWhere((e) => e.projectId == projectID);
        return BlocListener<ViewProjectDetailsCubit, ViewProjectDetailsState>(
          listener: (context, state) {
            if (state is LoadingState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: Lottie.asset("assets/json/Loading animation.json"),
                ),
              );
            } else if (state is SuccessDeleteState) {
              Navigator.pop(context);
              Navigator.pop(context); //x2
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Success!',
                    style: TextStyle(color: Color(0xFF4E2EB5)),
                  ),
                  backgroundColor: Colors.white,
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(
              text: 'Project Details',
              actions: [
                IconButton(
                    onPressed: () {showDialog(context: context, builder: (context)=>AlertDialog(content: BarcodeWidget(data: projectID, barcode: Barcode.qrCode()),));},
                    icon: SvgPicture.asset("assets/svg/bracode_icon.svg"))
              ]
            ),
            body: BlocBuilder<ViewProjectDetailsCubit, ViewProjectDetailsState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return const CircularProgressIndicator();
                }
                if (state is ErrorState) {
                  return Center(
                    child: Text(state.msg),
                  );
                }
                if (state is SuccessState) {
                  if (currentProject == null) {
                    return const Center(
                        child: Text("Project details not found"));
                  }
                  return ListView(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: MediaQuery.of(context).size.width / 2 - 70,
                            top: -40,
                            child: CustomPaint(
                              size: const Size(295, 219),
                              painter: TuwaiqLogoCustomPaint(),
                            ),
                          ),
                          CustomProjectDetailListTile(
                            title: currentProject.projectName ??
                                "project's name not provided",
                            type: "${currentProject.type}" ,
                            bootcampName: currentProject.bootcampName ??
                                "bootcamp name not provided",
                            leading: Image.network(
                              currentProject.logoUrl ??
                                  "https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-260nw-1037719192.jpg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      if (currentProject.imagesProject!.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            enlargeCenterPage: true,
                            autoPlay: true,
                          ),
                          items: currentProject.imagesProject!.map((image) {
                            return CustomSliderContainers(
                              image: Image.network(
                                image['url'] ??
                                    "https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-260nw-1037719192.jpg",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                      fit: BoxFit.cover,
                                      "https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-260nw-1037719192.jpg");
                                },
                              ),
                            );
                          }).toList(),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Center(
                            child: CustomText(
                                text: "project images not uploaded yet",
                                size: 16),
                          ),
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: currentProject.linksProject!.map((link) {
                            Widget icon = const SizedBox.shrink();
                            switch (link['type']) {
                              case "github":
                                icon = const Icon(
                                  SimpleIcons.github,
                                  color: Colors.black,
                                );
                                break;
                              case "figma":
                                icon = SvgPicture.asset(
                                  "assets/svg/figma_icon.svg",
                                  width: 28,
                                  height: 28,
                                );
                                break;
                              case "video":
                                icon = const Icon(
                                  SimpleIcons.youtube,
                                  color: Colors.red,
                                );
                                break;
                              case "pinterest":
                                icon = const Icon(
                                  SimpleIcons.pinterest,
                                  color: Color.fromARGB(255, 193, 47, 37),
                                );
                                break;
                              case "playstore":
                                icon = SvgPicture.asset(
                                  "assets/svg/playstore_icon.svg",
                                  width: 22,
                                  height: 22,
                                );
                                break;
                              case "applestore":
                                icon = const Icon(
                                  SimpleIcons.appstore,
                                  color: Colors.blue,
                                );
                                break;
                              case "apk":
                                icon = const Icon(
                                  SimpleIcons.android,
                                  color: Colors.green,
                                );
                                break;
                              case "weblink":
                                icon =
                                    Image.asset("assets/images/web_icon.png");
                                break;
                            }
                            return CustomIconButton(
                              onPressed: () {
                                launchURL(link['url']);
                              },
                              icon: icon,
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text:
                                  "${currentProject.startDate}-${currentProject.endDate}",
                              size: 12,
                              color: const Color(0xff262626),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                CustomText(
                                    text: "${currentProject.rating}", size: 16),
                                const SizedBox(
                                  width: 14,
                                ),
                                starRating(currentProject.rating),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: const Color(0xff848484).withOpacity(0.5848484),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(text: "About", size: 20),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomText(
                              text: currentProject.projectDescription ??
                                  "project description not provided",
                              size: 12,
                              color: const Color(0xff848484),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: const Color(0xff848484).withOpacity(0.5848484),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(text: "Presentation", size: 20),
                            currentProject.presentationUrl != null
                                ? TextButton(
                                    onPressed: () {
                                      launchURL(
                                          currentProject.presentationUrl!);
                                    },
                                    child: const CustomText(
                                      text:
                                          "You can view the project presentation by clicking here",
                                      color: Color(0xff59E2DB),
                                      size: 12,
                                    ))
                                : CustomText(
                                    text: "preseentaion not uploaded yet",
                                    size: 12,
                                    color: const Color(0xff848484),
                                  ),
                          ],
                        ),
                      ),
                      Divider(
                        color: const Color(0xff848484).withOpacity(0.5848484),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(text: "Team members", size: 20),
                            const SizedBox(
                              height: 20,
                            ),
                            if (currentProject.membersProject!.isNotEmpty)
                              ...currentProject.membersProject!.map((member) {
                                return CustomTeamMemberCard(
                                  name: "${member.firstName}" ,
                                  position: "${member.position}",
                                  description:
                                      member.email ?? "email not provided",
                                  image: Image.network(errorBuilder:
                                          (BuildContext context, Object error,
                                              StackTrace? stackTrace) {
                                    return Container(
                                        color: Colors.grey,
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ));
                                  },
                                      member.imageUrl ??
                                          "https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-260nw-1037719192.jpg"),
                                  githubOnPressed: () {
                                    launchURL(member.link?.github ??
                                        "https://github.com");
                                  },
                                  linkedinOnPressed: () {
                                    launchURL(member.link?.linkedin ??
                                        "https://www.linkedin.com");
                                  },
                                  bindLinkOnPressed: () {
                                    launchURL(member.link?.bindlink ??
                                        "https://bind.link");
                                  },
                                  cvOnPressed: () {
                                    launchURL(member.link!.resume ??
                                        "https://flowcv.com");
                                  },
                                );
                              })
                            else ...[
                              const CustomText(
                                  text: "No team members found.", size: 16),
                            ],
                            SizedBox(
                              height: 40,
                            ),
                            if (getIt.get<DataLayer>().userInfo!.role != 'user')
                              CustomElevatedButton(
                                  backgroundColor: const Color(0xff4D2EB4),
                                  text: 'Delete This Project',
                                  textcolor: const Color(0xffffffff),
                                  onPressed: () {
                                    context
                                        .read<ViewProjectDetailsCubit>()
                                        .deleteProject(projectID);
                                  })
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        );
      }),
    );
  }
}

Future<void> launchURL(String url) async {
  try {
    Uri? uri = Uri.tryParse(url);
    if (uri != null && (uri.hasScheme || uri.hasAuthority)) {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        await launchUrlString('http://google.com');
      }
    } else {
      await launchUrlString('http://google.com');
    }
  } catch (e) {
    'Error launching URL: $e';
  }
}

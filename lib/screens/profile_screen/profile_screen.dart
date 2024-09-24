import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_judge/components/buttons/custom_elevated_button.dart';
import 'package:project_judge/data_layer/data_layer.dart';
import 'package:project_judge/models/user_model.dart';
import 'package:project_judge/screens/edit_profile.dart/edit_profile.dart';
import 'package:project_judge/screens/profile_screen/cubit/profile_cubit.dart';
import 'package:project_judge/screens/welcome_screen/welcome_screen.dart';
import 'package:project_judge/setup/init_setup.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../components/text/custom_text.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user = getIt.get<DataLayer>().userInfo!; // Get user info

    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Builder(builder: (context) {
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Scaffold(
                backgroundColor: const Color(0xff4E2EB5),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF4E2EB5),
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          getIt.get<DataLayer>().box.erase();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen()));
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Color(0xffffffff),
                        ))
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffffffff),
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: user.imageUrl == null
                              ? const AssetImage(
                                  "assets/images/default_img.png")
                              : NetworkImage(user.imageUrl!) as ImageProvider,
                        ),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: CustomText(
                        text: user.id!,
                        size: 12,
                        color: const Color.fromARGB(133, 255, 255, 255),
                        weight: FontWeight.w500,
                      )),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: user.firstName!,
                            size: 24,
                            color: Colors.white,
                            weight: FontWeight.w500,
                          ),
                          const CustomText(text: ' '),
                          CustomText(
                            text: user.lastName!,
                            size: 24,
                            color: Colors.white,
                            weight: FontWeight.w500,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: const Color(0xff848484).withOpacity(0.5848484),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(
                          SimpleIcons.github,
                          color: Color(0XFFFFFFFF),
                        ),
                        title: CustomText(
                            text: user.link!.github ?? 'Not added yet',
                            size: 14,
                            color: const Color(0xffffffff)),
                      ),
                      ListTile(
                        leading: const Icon(
                          SimpleIcons.linkedin,
                          color: Color(0XFFFFFFFF),
                        ),
                        title: CustomText(
                            text: user.link!.linkedin ?? 'Not added yet',
                            size: 14,
                            color: const Color(0xffffffff)),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.note,
                          color: Color(0XFFFFFFFF),
                        ),
                        title: CustomText(
                            text: user.link!.bindlink ?? 'Not added yet',
                            size: 14,
                            color: const Color(0xffffffff)),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Color(0XFFFFFFFF),
                        ),
                        title: CustomText(
                            text: user.email ?? 'Not added yet',
                            size: 14,
                            color: const Color(0xffffffff)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: const Color(0xff848484).withOpacity(0.5848484),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      user.link!.resume != null
                          ? TextButton(
                              onPressed: () {
                                launchURL(user.link!.resume!);
                              },
                              child: const CustomText(
                                text: "Tap To View Resume",
                                color: Color(0xff59E2DB),
                                size: 14,
                              ))
                          : const CustomText(
                              text: "CV not uploaded yet",
                              size: 14,
                              color: Color(0xffffffffff),
                            ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfile())).then((onValue) {
                              if (onValue != null) {
                                context.read<ProfileCubit>().refreshPage();
                              }
                            });
                          },
                          minimumSize: const Size(350, 63),
                          backgroundColor: const Color(0xff58E4D9),
                          text: "Edit Profile",
                          textcolor: const Color(0xff5030B6)),
                      const SizedBox(
                        height: 14,
                      ),
                      if (user.role == 'admin')
                        CustomElevatedButton(
                            onPressed: () {},
                            minimumSize: const Size(350, 63),
                            backgroundColor: Colors.white,
                            text: "Manage Users",
                            textcolor: const Color(0xff5030B6)),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ));
          },
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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:project_judge/components/app_bar/custom_app_bar.dart';
import 'package:project_judge/components/dialog/error_dialog.dart';
import 'package:project_judge/components/text_field/custom_text_form_field.dart';
import 'package:project_judge/screens/edit_profile.dart/bloc/updateprofile_bloc.dart';
import 'package:simple_icons/simple_icons.dart';
import '../../components/text/custom_text.dart';
import 'dart:io';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateprofileBloc(),
      child: Builder(builder: (context) {
        final bloc = context.read<UpdateprofileBloc>();
        final picker = ImagePicker();
        final formKey = GlobalKey<FormState>();
        bool isImagePickerActive = false;

        // Initialize controllers
        TextEditingController fNameController =
            TextEditingController(text: bloc.fName);
        TextEditingController lNameController =
            TextEditingController(text: bloc.lName);
        TextEditingController githubController =
            TextEditingController(text: bloc.github);
        TextEditingController linkedinController =
            TextEditingController(text: bloc.linkedin);
        TextEditingController bindlinkController =
            TextEditingController(text: bloc.bindlink);

        return BlocListener<UpdateprofileBloc, UpdateprofileState>(
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
            } else if (state is SuccessState) {
              Navigator.pop(context, true);
              Navigator.pop(context, true); //x2
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Profile updated successfully!',
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
            backgroundColor: const Color(0xffFBFBFB),
            appBar: CustomAppBar(
              text: 'Edit Profile',
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        if (bloc.file == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please import a resume file.'),
                              backgroundColor: Color(0xff4D2EB4),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          bloc.add(UpdateAllProfileEvent());
                        }
                      }
                    },
                    icon: const Icon(Icons.done, color: Color(0xffffffff)),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BlocBuilder<UpdateprofileBloc, UpdateprofileState>(
                            builder: (context, state) {
                          return FutureBuilder<File?>(
                            future: bloc.imgFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<File?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_img.png"),
                                );
                              } else if (snapshot.hasError) {
                                return const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_img.png"),
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(snapshot.data!),
                                );
                              } else {
                                return const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_img.png"),
                                );
                              }
                            },
                          );
                        }),
                        TextButton(
                          onPressed: () async {
                            if (!isImagePickerActive) {
                              isImagePickerActive =
                                  true; // Mark picker as active
                              try {
                                final image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  bloc.add(
                                      UploadImgEvent(img: File(image.path)));
                                }
                              } catch (e) {
                                // Handle the case where image picking fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Failed to pick an image. Please try again.'),
                                  ),
                                );
                              } finally {
                                // Reset the flag once the picker is done
                                isImagePickerActive = false;
                              }
                            }
                          },
                          child: const Text('Change Profile Icon'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.length <= 3) {
                          return 'Must be more than 3 characters';
                        }
                        return null;
                      },
                      label: "First Name",
                      controller: fNameController,
                      onChange: (value) {
                        bloc.fName = fNameController.text;
                      },
                      hintText: "First Name",
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.length <= 3) {
                          return 'Must be more than 3 characters';
                        }
                        return null;
                      },
                      label: "Last Name",
                      controller: lNameController,
                      onChange: (value) {
                        bloc.lName = lNameController.text;
                      },
                      hintText: "Last Name",
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 32),
                    Divider(
                        color: const Color(0xff848484).withOpacity(0.5848484)),
                    const SizedBox(height: 16),
                    const CustomText(
                        text: "My Accounts",
                        size: 24,
                        color: Color(0xff262626),
                        weight: FontWeight.w500),
                    const SizedBox(height: 25),
                    CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.length <= 3) {
                          return 'Must be more than 3 characters';
                        }
                        return null;
                      },
                      label: "Github",
                      controller: githubController,
                      onChange: (value) {
                        bloc.github = githubController.text;
                      },
                      hintText: "Example//example.com",
                      icon: SimpleIcons.github,
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.length <= 3) {
                          return 'Must be more than 3 characters';
                        }
                        return null;
                      },
                      label: "Linkedin",
                      controller: linkedinController,
                      onChange: (value) {
                        bloc.linkedin = linkedinController.text;
                      },
                      hintText: "Example//example.com",
                      icon: SimpleIcons.linkedin,
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.length <= 3) {
                          return 'Must be more than 3 characters';
                        }
                        return null;
                      },
                      label: "Bindlink",
                      controller: bindlinkController,
                      onChange: (value) {
                        bloc.bindlink = bindlinkController.text;
                      },
                      hintText: "Example//example.com",
                      icon: Icons.sticky_note_2_rounded,
                    ),
                    const SizedBox(height: 25),
                    Divider(
                        color: const Color(0xff848484).withOpacity(0.5848484)),
                    const SizedBox(height: 16),
                    const CustomText(
                        text: "Upload Resume",
                        size: 24,
                        color: Color(0xff262626),
                        weight: FontWeight.w500),
                    const SizedBox(height: 16),
                    BlocBuilder<UpdateprofileBloc, UpdateprofileState>(
                      builder: (context, state) {
                        return Text(
                          bloc.user.link!.resume == null
                              ? 'No file uploaded'
                              : 'File uploaded successfully',
                          style: const TextStyle(
                              color: Color.fromARGB(134, 0, 0, 0)),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          final file = File(result.files.single.path!);
                          bloc.add(UploadFileEvent(file: file));
                        }
                      },
                      child: const Text('Upload File'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

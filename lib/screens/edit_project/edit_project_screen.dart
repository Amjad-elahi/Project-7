import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_judge/components/app_bar/custom_app_bar.dart';
import 'package:project_judge/components/buttons/custom_elevated_button.dart';
import 'package:project_judge/components/dialog/error_dialog.dart';
import 'package:project_judge/components/text/custom_text.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:project_judge/components/text_field/custom_text_form_field.dart';
import 'package:project_judge/screens/edit_project/bloc/edit_project_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_judge/data_layer/data_layer.dart';
import 'package:project_judge/setup/init_setup.dart';

part 'edit_logo.dart';
part 'edit_base.dart';
part 'edit_images.dart';
part 'edit_links.dart';
part 'edit_presentation.dart';
part 'edit_members.dart';

class EditProjectScreen extends StatelessWidget {
  final String projectId;

  const EditProjectScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProjectBloc(),
      child: EditProjectForm(
        projectId: projectId,
      ),
    );
  }
}

class EditProjectForm extends StatelessWidget {
  final String projectId;
  const EditProjectForm({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final bloc = context.read<EditProjectBloc>();
    bloc.id = projectId;
    return BlocListener<EditProjectBloc, EditProjectState>(
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
        backgroundColor: const Color(0xffFBFBFB),
        appBar: CustomAppBar(
            text: "Modify Project",actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    //VALIDATE ALL REQUERED FEILDS BEFORE UPDATING
                    if (bloc.logoImg == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a logo image.'),
                          backgroundColor: Color(0xff4D2EB4),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (bloc.duration ==
                        DateTimeRange(
                            start: bloc.dateFormat.parse('0000-00-00'),
                            end: bloc.dateFormat.parse('0000-00-00'))) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Choose Project duration.'),
                          backgroundColor: Color(0xff4D2EB4),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (bloc.presentationDate ==
                        bloc.dateFormat.parse('0000-00-00')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Choose Presentation date.'),
                          backgroundColor: Color(0xff4D2EB4),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (bloc.imgList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Add Project Images'),
                          backgroundColor: Color(0xff4D2EB4),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (bloc.presention == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Add A Presention File'),
                          backgroundColor: Color(0xff4D2EB4),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      bloc.add(UpdateAllProjectEvent());
                    }
                  }
                },
                icon: const Icon(Icons.done, color: Color(0xffffffff)),
              ),
            ),
          ],
          ),
        body: SafeArea(
          child: EditProjectBody(formKey: formKey),
        ),
      ),
    );  
        
  }
}

class EditProjectBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const EditProjectBody({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProjectBloc>();
    return Form(
      key: formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const ProjectLogoSection(),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const BasicInformation(),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const ProjectImagesSection(),
              const Divider(),
              const SizedBox(height: 10),
              const ProjectLinksSection(),
              const Divider(),
              const SizedBox(height: 10),
              const ProjectPresentationSection(),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const ProjectMembersSection(),
              const SizedBox(height: 10),
              if (getIt.get<DataLayer>().userInfo!.role != 'user')
                CustomElevatedButton(
                  backgroundColor: const Color(0xff4D2EB4),
                  text: 'Delete This Project',
                  textcolor: const Color(0xffffffff),
                  onPressed: () {
                    bloc.add(DeleteProjectEvent());
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

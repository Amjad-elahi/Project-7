import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_judge/components/buttons/custom_icon_button.dart';
import 'package:project_judge/components/app_bar/custom_app_bar.dart';
import 'package:project_judge/components/dialog/error_dialog.dart';
import 'package:project_judge/components/text_field/custom_text_form_field.dart';
import 'cubit/project_status_cubit_cubit.dart';

class ChangeProjectStatus extends StatelessWidget {
  const ChangeProjectStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController projectIdController = TextEditingController();

    // Track the state of the radio buttons
    bool canEdit = false;
    bool canRate = false;
    bool isPublic = false;

    return BlocProvider(
        create: (context) => ProjectStatusCubitCubit(),
        child: Builder(
          builder: (context) {
            return BlocListener<ProjectStatusCubitCubit,
                ProjectStatusCubitState>(
              listener: (context, state) {
                if (state is LoadingState) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      content:
                          Lottie.asset("assets/json/Loading animation.json"),
                    ),
                  );
                } else if (state is SuccessState) {
                  Navigator.pop(context); // Close loading dialog
                  Navigator.pop(context); // Close current screen
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
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  text: 'Manage Project',
                  actions: [
                    CustomIconButton(
                      icon: const Icon(Icons.check_rounded),
                      onPressed: () {
                        final String projectID = projectIdController.text;

                        // Validate input fields
                        if (projectID.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a project ID.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        context.read<ProjectStatusCubitCubit>().changeStatus(
                              projectID: projectID,
                              canEdit: canEdit,
                              canRate: canRate,
                              isPublic: isPublic,
                            );
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: ListView(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            const Text("Project ID",
                                style: TextStyle(fontSize: 16)),
                            const Spacer(),
                            Expanded(
                              child: CustomTextFormField(
                                controller: projectIdController,
                                hintText: 'Enter ID',
                                // Validation logic can be handled in the onPressed
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildRadioButtons("Can Edit?", canEdit, (value) {
                          canEdit = value; // Update local variable directly
                        }),
                        const SizedBox(height: 20),
                        buildRadioButtons("Can Rate?", canRate, (value) {
                          canRate = value; // Update local variable directly
                        }),
                        const SizedBox(height: 20),
                        buildRadioButtons("Is Public?", isPublic, (value) {
                          isPublic = value; // Update local variable directly
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget buildRadioButtons(
      String title, bool groupValue, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        Row(
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: groupValue,
                  onChanged: (value) {
                    if (value != null) onChanged(value);
                  },
                ),
                const Text('Yes'),
              ],
            ),
            Row(
              children: [
                Radio<bool>(
                  value: false,
                  groupValue: groupValue,
                  onChanged: (value) {
                    if (value != null) onChanged(value);
                  },
                ),
                const Text('No'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}


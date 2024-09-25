import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_judge/components/containers/custom_manage_users_container.dart';
import 'package:project_judge/components/text/custom_text.dart';
import 'package:project_judge/components/text_field/custom_text_form_field.dart';
import 'package:project_judge/screens/manage_user_screen/cubit/mange_user_cubit.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/buttons/custom_icon_button.dart';
import '../../components/dialog/error_dialog.dart';

class ManageUserScreen extends StatelessWidget {
  const ManageUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MangeUserCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<MangeUserCubit>();
        return BlocListener<MangeUserCubit, MangeUserState>(
          listener: (context, state) {
            if (state is LoadingState) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content:
                            Lottie.asset("assets/json/Loading animation.json"),
                      ));
            }
            if (state is SuccessState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Color(0xff4D2EB4),
                  content: CustomText(
                    text: "User role changed succesfully",
                    size: 16,
                  )));
            }
            if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              text: 'Manage Users',
              actions: [
                CustomIconButton(
                  icon: const Icon(Icons.check_rounded),
                  onPressed: () {
                    cubit.changeRole();
                  },
                ),
              ],
            ),
            body: BlocBuilder<MangeUserCubit, MangeUserState>(
              builder: (context, state) {
                return ListView(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: CustomText(
                        text:
                            "Switch to convert users from basic users to supervisors, and vice versa.",
                        size: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextFormField(
                        controller: cubit.userIDController,
                        hintText: "Enter user id",
                      ),
                    ),
                    const SizedBox(height: 26),
                    CustomManageUsersContainer(
                      position: cubit.isSwitched ? "Upgrade to supervisor" : "Upgrade to user",
                      isSwitched: cubit.isSwitched,
                      onChanged: (value) {
                        cubit.switchButton();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_judge/components/buttons/custom_elevated_button.dart';
import 'package:project_judge/components/dialog/error_dialog.dart';
import 'package:project_judge/components/text_field/custom_text_form_field.dart';
import 'package:project_judge/screens/auth/create_account_screen.dart';
import 'package:project_judge/screens/auth/cubit/auth_cubit.dart';
import 'package:project_judge/screens/auth/verify_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<AuthCubit>();
        return BlocListener<AuthCubit, AuthState>(
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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyScreen(
                          email: cubit.emailLoginController.text)));
            }

            if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/loginImage.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height - 136),
                        decoration: const BoxDecoration(
                            color: Color(0x65000000),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40))),
                      ),
                      Positioned(
                          top: -50,
                          left: MediaQuery.of(context).size.width / 2 - 50,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: Image.asset("assets/images/logo-h 2.png"),
                            ),
                          )),
                    ],
                  ),
                ),
                ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 150,
                            ),
                            const Text(
                              "Log in",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                            const SizedBox(
                              height: 130,
                            ),
                            CustomTextFormField(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              controller: cubit.emailLoginController,
                              hintText: "Example@example.com",
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 111,
                            ),
                            CustomElevatedButton(
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 63),
                              backgroundColor: const Color(0xff4D2EB4),
                              text: "Get OTP",
                              textcolor: Colors.white,
                              onPressed: () {
                                cubit.checkLogin(
                                    email: cubit.emailLoginController.text);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don’t have an account?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CreateAccountScreen()));
                                    },
                                    child: const Text(
                                      "Create an account",
                                      style:
                                          TextStyle(color: Color(0xff57E3D8)),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

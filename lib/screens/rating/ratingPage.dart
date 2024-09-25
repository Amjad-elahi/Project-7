import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project_judge/components/app_bar/custom_app_bar.dart';
import 'package:project_judge/components/dialog/error_dialog.dart';
import 'package:project_judge/components/slider_section/sliderSection.dart';
import 'package:project_judge/screens/navigation/navigationPage.dart';
import 'package:project_judge/screens/rating/cubit/rating_cubit.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key, required this.projectID});
  final String projectID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<RatingCubit>();
        return BlocListener<RatingCubit, RatingState>(
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const NavigationPage(slectedPage: 4)));
            }
            if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(
              text: 'Rate',
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        cubit.submitRating(pID: projectID);
                      },
                      child: Image.asset("assets/images/send.png")),
                ),
              ],
            ),
            body: BlocBuilder<RatingCubit, RatingState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ProjectName',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                        const Text(
                            'Rate this project on a scale from 1 (poor) to 10 (excellent).',
                            style: TextStyle(color: Colors.grey, fontSize: 22)),
                        const SizedBox(height: 10),
                        SliderSection(
                          label: 'Idea',
                          value: cubit.ideaRating,
                          imagePath: 'assets/images/idea.png',
                          onChanged: (newValue) {
                            cubit.ideaRating = newValue;
                          },
                        ),
                        SliderSection(
                          label: 'Design',
                          value: cubit.designRating,
                          imagePath: 'assets/images/design.png',
                          onChanged: (newValue) {
                            cubit.designRating = newValue;
                          },
                        ),
                        SliderSection(
                          label: 'Tools',
                          value: cubit.toolsRating,
                          imagePath: 'assets/images/tools.png',
                          onChanged: (newValue) {
                            cubit.toolsRating = newValue;
                          },
                        ),
                        SliderSection(
                          label: 'Practices',
                          value: cubit.practicesRating,
                          imagePath: 'assets/images/medal.png',
                          onChanged: (newValue) {
                            cubit.practicesRating = newValue;
                          },
                        ),
                        SliderSection(
                          label: 'Presentation',
                          value: cubit.presentationRating,
                          imagePath: 'assets/images/presentation.png',
                          onChanged: (newValue) {
                            cubit.presentationRating = newValue;
                          },
                        ),
                        SliderSection(
                          label: 'Investment',
                          value: cubit.investmentRating,
                          imagePath: 'assets/images/invest.png',
                          onChanged: (newValue) {
                            cubit.investmentRating = newValue;
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/images/note.png'),
                                  const SizedBox(width: 12),
                                  const Text("Note",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: cubit.notesController,
                                decoration: const InputDecoration(
                                  hintText: 'Add any additional notes',
                                  border: InputBorder.none,
                                ),
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

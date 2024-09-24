import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_judge/network/api_netowrok.dart';

part 'mange_user_state.dart';

class MangeUserCubit extends Cubit<MangeUserState> {
  MangeUserCubit() : super(MangeUserInitial());
  TextEditingController userIDController = TextEditingController();
  ApiNetowrok api = ApiNetowrok();
  bool isSwitched = false;

  void switchButton() {
    isSwitched = !isSwitched;
    print('Switch toggled: $isSwitched');
    emit(SwitchButtonState(isSwitched: isSwitched));
  }

  Future<void> changeRole() async {
    final newRole = isSwitched ? "supervisor" : "user";
    emit(LoadingState());
    try {
      print('Changing role to: $newRole for user ID: ${userIDController.text}');
      await api.updateUserRole(userIDController.text, newRole);
      emit(SuccessState());
    } on FormatException catch (e) {
      emit(ErrorState(msg: e.message));
    } catch (e) {
      emit(ErrorState(msg: e.toString()));
    }
  }
}

part of 'project_status_cubit_cubit.dart';

@immutable
sealed class ProjectStatusCubitState {}

final class ProjectStatusCubitInitial extends ProjectStatusCubitState {}

final class LoadingState extends ProjectStatusCubitState {}

final class SwitchButtonState extends ProjectStatusCubitState {
  final bool isSwitched;

  SwitchButtonState({required this.isSwitched});
}

final class SuccessState extends ProjectStatusCubitState {}

final class ErrorState extends ProjectStatusCubitState {
  final String msg;
  ErrorState({required this.msg});
}

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:project_judge/data_layer/data_layer.dart';
import 'package:project_judge/setup/init_setup.dart';

part 'project_status_cubit_state.dart';

class ProjectStatusCubitCubit extends Cubit<ProjectStatusCubitState> {
  ProjectStatusCubitCubit() : super(ProjectStatusCubitInitial());

  Future<void> changeStatus({
    required String projectID,
    required bool canEdit,
    required bool canRate,
    required bool isPublic,
  }) async {
    emit(LoadingState());

    final dio = Dio(); 

    try {
      final response = await dio.put(
        "https://tuwaiq-gallery.onrender.com/v1/supervisor/change/status/$projectID",
        data: {
          "time_end_edit": "11/12/2024",
          "edit": canEdit,
          "rating": canRate,
          "public": isPublic,
        },
        options: Options(
          headers: {
            "Authorization": getIt.get<DataLayer>().authUser!.token
          },
        ),
      );
      print('Response: ${response.data}');
      emit(SuccessState()); // Emit success state
    } on DioException catch (e) {
      emit(ErrorState(
          msg: e.response?.data['data'].toString() ?? 'Unknown error'));
    } catch (e) {
      emit(ErrorState(msg: e.toString()));
      print('Error: $e');
    }
  }
}

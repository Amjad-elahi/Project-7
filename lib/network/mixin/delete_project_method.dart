import 'package:dio/dio.dart';
import 'package:project_judge/network/constant_network.dart';

mixin DeleteProjectMethod on ConstantNetwork {
  deleteProject({required String projectID, required String token}) async {
    try {
      await dio.delete("$baseurl$delete/$projectID",
          data: {},
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } on DioException catch (e) {
      throw FormatException(e.response!.data['data'].toString());
    } catch (e) {
      throw FormatException(e.toString());
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:project_judge/models/user_model.dart';
import 'package:project_judge/network/constant_network.dart';

mixin UpdateProjectMethods on ConstantNetwork {
  Future updateProject(
      {required String projectID,
      required String token,
      required String name,
      required String bootcamp,
      required String type,
      required String start,
      required String end,
      required String presentationDate,
      required String desc,
      required List link,
      required File pres,
      required String logo,
      required List<MembersProject> members,
      required List imagesList}) async {
    // // update logo
    try {
      Uint8List data = await File(logo).readAsBytes();
      final response =
          await dio.put("$baseurl$updateProjectLogoEndPoint/$projectID",
              data: {
                "logo": data.toList(),
              },
              options: Options(headers: {"Authorization": "Bearer $token"}));
      print('logo $response');
    } on DioException catch (e) {
      throw FormatException(e.response?.data['data']);
    } catch (e) {
      throw FormatException(e.toString());
    }

    //update base
    try {
      final response =
          await dio.put("$baseurl$updateProjectBaseEndPoint/$projectID",
              data: {
                "project_name": name,
                "bootcamp_name": bootcamp,
                "type": type,
                "start_date": start,
                "end_date": end,
                "presentation_date": presentationDate,
                "project_description": desc
              },
              options: Options(headers: {"Authorization": "Bearer $token"}));
      print('input info: $response');
    } on DioException catch (e) {
      throw FormatException(e.response?.data['data']);
    } catch (e) {
      throw FormatException(e.toString());
    }

    //update presentation
    try {
      Uint8List presentation = await File(pres.path).readAsBytes();
      await dio.put("$baseurl$updateProjectPresentationEndPoint/$projectID",
          data: {
            "presentation_file": presentation,
          },
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } on DioException catch (e) {
      throw FormatException(e.response?.data['data']);
    } catch (e) {
      throw FormatException(e.toString());
    }

    //   update images
    try {
      List<Uint8List> convertedImages = [];

      for (var file in imagesList) {
        try {
          // Read the file as bytes
          Uint8List imgBytes = await file.readAsBytes();
          convertedImages.add(imgBytes);
        } catch (e) {
          print('Error reading file ${file.path}: $e');
        }
      }
      final response =
          await dio.put("$baseurl$updateProjectImagesEndPoint/$projectID",
              data: {
                "images": convertedImages,
              },
              options: Options(headers: {"Authorization": "Bearer $token"}));
      print('imgs $response');
    } on DioException catch (e) {
      throw FormatException(e.response?.data['data']);
    } catch (e) {
      throw FormatException(e.toString());
    }

    //  update link
    try {
      final response =
          await dio.put("$baseurl$updateProjectLinksEndPoint/$projectID",
              data: {
                "link": link,
              },
              options: Options(headers: {"Authorization": "Bearer $token"}));
      print('links: $response');
    } on DioException catch (e) {
      throw FormatException(e.response?.data['data']);
    } catch (e) {
      throw FormatException(e.toString());
    }

    // update members
    try {
      List membersList = members.map((member) => member.toJsonM()).toList();
      print({"members": membersList});

      final response = await dio.put(
          "$baseurl$updateProjectMembersEndPoint/$projectID",
          data: {"members": membersList},
          options: Options(headers: {"Authorization": "Bearer $token"}));
      print('members $response');
    } on DioException catch (e) {
      print('dio ${e.response?.data}');
      print('dio ${e.response?.statusCode}');
      print('dio ${e.response?.extra}');
      print('dio ${e.response?.statusMessage}');

      throw FormatException(e.response?.data['data']);
    } catch (e) {
      print('error $e');
      throw FormatException(e.toString());
    }
  }
}

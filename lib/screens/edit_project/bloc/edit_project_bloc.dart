import 'dart:io';
import 'package:project_judge/data_layer/data_layer.dart';
import 'package:project_judge/models/user_model.dart';
import 'package:project_judge/network/api_netowrok.dart';
import 'package:project_judge/setup/init_setup.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'edit_project_event.dart';
part 'edit_project_state.dart';

class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  String? id;

  late Projects project = getIt.get<DataLayer>().userInfo!.projects!.firstWhere(
        (project) => project.projectId == id,
      );
  ApiNetowrok api = ApiNetowrok();
  //save logo
  File? logoImg;
  late Future<File?> imgFuture;
  //save base info
  late String name = project.projectName ?? '';
  late String bootcampName = project.bootcampName ?? '';
  late String type = project.type ?? '';
  late String description = project.projectDescription ?? '';
//dates
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  late String? presentationDateFromDB = project.presentationDate;
  late String? startDateFromDB = project.startDate;
  late String? endDateFromDB = project.endDate;
  late DateTime? presentationDate =
      dateFormat.parse(presentationDateFromDB ?? '0000-00-00');
  late DateTimeRange? duration = DateTimeRange(
      start: dateFormat.parse(startDateFromDB ?? '0000-00-00'),
      end: dateFormat.parse(endDateFromDB ?? '0000-00-00'));

  //save imgs list
  List imgList = [];

  //save links
  late List<Map<String, dynamic>>? links = project.linksProject;

  //save members
  late List<MembersProject>? members = project.membersProject;

  //
  File? presention;

  EditProjectBloc() : super(EditProjectInitial()) {
    on<UpdateLogoEvent>((event, emit) {
      logoImg = event.logo;
      emit(UpdateProjectEntryState());
    });

    on<UpdatePresentationDateEvent>((event, emit) {
      presentationDate = event.date;
      emit(UpdateProjectEntryState());
    });

    on<UpdateProjectDurationEvent>((event, emit) {
      duration = event.date;
      emit(UpdateProjectEntryState());
    });
    on<UpdateLinksEvent>((event, emit) {
      Map<String, String?> currentLinksMap = {
        for (var link in links!) link['type']: link['url']
      };

      // Update the links list based on the event
      links = [
        {
          "type": "github",
          "url": event.github ?? currentLinksMap['github'] ?? ''
        },
        {"type": "figma", "url": event.figma ?? currentLinksMap['figma'] ?? ''},
        {"type": "video", "url": event.video ?? currentLinksMap['video'] ?? ''},
        {
          "type": "pinterest",
          "url": event.pinterest ?? currentLinksMap['pinterest'] ?? ''
        },
        {
          "type": "playstore",
          "url": event.playstore ?? currentLinksMap['playstore'] ?? ''
        },
        {
          "type": "applestore",
          "url": event.applestore ?? currentLinksMap['applestore'] ?? ''
        },
        {"type": "apk", "url": event.apk ?? currentLinksMap['apk'] ?? ''},
        {
          "type": "weblink",
          "url": event.web ?? currentLinksMap['weblink'] ?? ''
        },
      ];

      // Emit the updated state
      emit(UpdateProjectEntryState());
    });
    on<EditProjectEvent>((event, emit) {});

    on<EditImagesEvent>((event, emit) {
      imgList = event.imgs;

      emit(UpdateProjectEntryState());
    });

    on<DeleteImagesEvent>((event, emit) {
      imgList.removeAt(event.imgsInt);

      emit(UpdateProjectEntryState());
    });

    on<AddMembersEvent>((event, emit) {
      members?.add(MembersProject(
        id: '',
        position: '',
      ));
      emit(UpdateProjectEntryState());
    });

    on<UpdateMembersEvent>((event, emit) {
      members?[event.index] = MembersProject(
        id: event.id, // Update id
        firstName: members?[event.index].firstName, // Keep
        lastName: members?[event.index].lastName, // Keep
        email: members?[event.index].email,
        position: event.role, // Update position
        imageUrl: members?[event.index].imageUrl, // Keep
        link: members?[event.index].link, // Keep
      );
      emit(UpdateProjectEntryState());
    });

    on<DeleteMembersEvent>((event, emit) {
      members?.removeAt(event.index); // Remove member
      emit(UpdateProjectEntryState());
    });
    on<UpdateFileEvent>((event, emit) {
      presention = event.presentation;
      emit(UpdateProjectEntryState());
    });

    on<UpdateAllProjectEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await api.updateProject(
            projectID: id!,
            token: getIt.get<DataLayer>().authUser!.token,
            name: name,
            bootcamp: bootcampName,
            type: type,
            start: DateFormat('dd/MM/yyyy').format(duration!.start),
            end: DateFormat('dd/MM/yyyy').format(duration!.end),
            presentationDate:
                DateFormat('dd/MM/yyyy').format(presentationDate!),
            desc: description,
            link: links!,
            logo: logoImg!.path,
            members: members!,
            pres: presention!,
            imagesList: imgList);
        emit(SuccessState());
      } on FormatException catch (e) {
        emit(ErrorState(msg: e.message));
      } catch (e) {
        emit(ErrorState(msg: e.toString()));
      }
    });

    on<DeleteProjectEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await api.deleteProject(
          projectID: id!,
           token: getIt.get<DataLayer>().authUser!.token,
        );
        emit(SuccessState());
      } on FormatException catch (e) {
        emit(ErrorState(msg: e.message));
      } catch (e) {
        emit(ErrorState(msg: e.toString()));
      }
    });
  }
}

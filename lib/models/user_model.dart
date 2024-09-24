class UserModel {
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.imageUrl,
    required this.link,
    required this.projects,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String? id;
  late final String? firstName;
  late final String? lastName;
  late final String? email;
  late final String? role;
  late final String? imageUrl;
  late final Link? link;
  late final List<Projects>? projects;
  late final String? createdAt;
  late final String? updatedAt;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    role = json['role'];
    imageUrl = json['image_url'];
    link = Link.fromJson(json['link']);
    projects =
        List.from(json['projects']).map((e) => Projects.fromJson(e)).toList();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['role'] = role;
    data['image_url'] = imageUrl;
    data['link'] = link?.toJson();
    data['projects'] = projects?.map((e) => e.toJson()).toList();
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Link {
  Link({
    required this.github,
    required this.linkedin,
    required this.bindlink,
    required this.resume,
  });
  late final String? github;
  late final String? linkedin;
  late final String? bindlink;
  late final String? resume;

  Link.fromJson(Map<String, dynamic> json) {
    github = json['github'];
    linkedin = json['linkedin'];
    bindlink = json['bindlink'];
    resume = json['resume'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['github'] = github;
    data['linkedin'] = linkedin;
    data['bindlink'] = bindlink;
    data['resume'] = resume;
    return data;
  }
}

class Projects {
  Projects({
    required this.projectId,
    required this.type,
    this.projectName,
    this.bootcampName,
    this.startDate,
    this.endDate,
    this.presentationDate,
    this.projectDescription,
    this.logoUrl,
    this.presentationUrl,
    required this.userId,
    required this.adminId,
    required this.timeEndEdit,
    required this.allowEdit,
    required this.allowRating,
    required this.isPublic,
    required this.rating,
    required this.createAt,
    required this.updateAt,
    required List<dynamic>? imagesProject,
    required List<Map<String, dynamic>>? linksProject,
    required List<MembersProject>? membersProject,
  })  : imagesProject = imagesProject ?? [],
        linksProject = linksProject ?? [],
        membersProject = membersProject ?? [];

  late final String? projectId;
  late final String? type;
  late final String? projectName;
  late final String? bootcampName;
  late final String? startDate;
  late final String? endDate;
  late final String? presentationDate;
  late final String? projectDescription;
  late final String? logoUrl;
  late final String? presentationUrl;
  late final String? userId;
  late final String? adminId;
  late final String? timeEndEdit;
  late final bool allowEdit; // Changed to non-nullable
  late final bool allowRating; // Changed to non-nullable
  late final bool isPublic; // Changed to non-nullable
  late final double rating; // Changed to non-nullable
  late final String createAt;
  late final String updateAt;
  late final List<dynamic>? imagesProject; // Removed nullable
  late final List<Map<String, dynamic>>? linksProject; // Removed nullable
  late final List<MembersProject>? membersProject; // Removed nullable

  Projects.fromJson(Map<String, dynamic> json)
      : projectId = json['project_id'],
        type = json['type'],
        projectName = json['project_name'],
        bootcampName = json['bootcamp_name'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        presentationDate = json['presentation_date'],
        projectDescription = json['project_description'],
        logoUrl = json['logo_url'],
        presentationUrl = json['presentation_url'],
        userId = json['user_id'],
        adminId = json['admin_id'],
        timeEndEdit = json['time_end_edit'],
        allowEdit = json['allow_edit'],
        allowRating = json['allow_rating'],
        isPublic = json['is_public'],
        rating = (json['rating'] is int)
            ? (json['rating'] as int).toDouble()
            : (json['rating'] as double),
        createAt = json['create_at'],
        updateAt = json['update_at'],
        imagesProject = List<dynamic>.from(json['images_project']),
        linksProject = List<Map<String, dynamic>>.from(json['links_project']),
        membersProject = List<MembersProject>.from(
            json['members_project'].map((e) => MembersProject.fromJson(e)));

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'type': type,
      'project_name': projectName,
      'bootcamp_name': bootcampName,
      'start_date': startDate,
      'end_date': endDate,
      'presentation_date': presentationDate,
      'project_description': projectDescription,
      'logo_url': logoUrl,
      'presentation_url': presentationUrl,
      'user_id': userId,
      'admin_id': adminId,
      'time_end_edit': timeEndEdit,
      'allow_edit': allowEdit,
      'allow_rating': allowRating,
      'is_public': isPublic,
      'rating': rating,
      'create_at': createAt,
      'update_at': updateAt,
      'images_project': imagesProject,
      'links_project': linksProject,
      'members_project': membersProject?.map((e) => e.toJson()).toList(),
    };
  }
}

class MembersProject {
  MembersProject({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    required this.position,
    this.imageUrl,
    this.link,
  });

  late final String? id;
  late final String? firstName;
  late final String? lastName;
  late final String? email;
  late final String? position;
  late final String? imageUrl;
  late final Link? link;

  MembersProject.fromJson(Map<String, dynamic> json) {
    id = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    position = json['position'];
    imageUrl = json['image_url'];
    link = Link.fromJson(json['link']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['position'] = position;
    data['image_url'] = imageUrl;
    data['link'] = link?.toJson();
    return data;
  }

  Map<String, dynamic> toJsonM() {
    final data = <String, dynamic>{};
    data['user_id'] = id;
    data['position'] = position;

    return data;
  }

  @override
  String toString() {
    return '{"user_id" : "$id", "position": "$position"}';
  }
}

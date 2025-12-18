class TeacherModel {
  int? id;
  String? createdAt;
  String? userId;
  String? jobTitle;
  String? permissionLevel;
  int? classes;
  bool? active;
  bool? notification;

  TeacherModel({
    this.id,
    this.createdAt,
    this.userId,
    this.jobTitle,
    this.permissionLevel,
    this.classes,
    this.notification,
    this.active,
  });

  TeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    jobTitle = json['job_title'];
    permissionLevel = json['permission_level'];
    classes = json['classes'];
    active = json['active'];
    notification = json['notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['user_id'] = userId;
    data['job_title'] = jobTitle;
    data['permission_level'] = permissionLevel;
    data['classes'] = classes;
    data['active'] = active;
    data['notification'] = notification;
    return data;
  }
}

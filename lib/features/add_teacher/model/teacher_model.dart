class TeacherModel {
  int? id;
  String? createdAt;
  String? userId;
  String? jobTitle;
  String? permissionLevel;
  int? classes;
  bool? active;

  TeacherModel(
      {this.id,
      this.createdAt,
      this.userId,
      this.jobTitle,
      this.permissionLevel,
      this.classes,
      this.active});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    jobTitle = json['job_title'];
    permissionLevel = json['permission_level'];
    classes = json['classes'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['user_id'] = this.userId;
    data['job_title'] = this.jobTitle;
    data['permission_level'] = this.permissionLevel;
    data['classes'] = this.classes;
    data['active'] = this.active;
    return data;
  }
}

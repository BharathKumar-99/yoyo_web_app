class NotificationModel {
  int? id;
  String? requestedAt;
  String? username;
  bool? isActivated;
  int? classes;
  String? code;
  String? content;
  int? classId;
  String? createdAt;

  NotificationModel({
    this.id,
    this.requestedAt,
    this.username,
    this.isActivated,
    this.classes,
    this.code,
    this.content,
    this.classId,
    this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestedAt = json['requested_at'];
    username = json['username'];
    isActivated = json['is_activated'];
    classes = json['class'];
    createdAt = json['created_at'];
    content = json['content'];
    classId = json['class_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['requested_at'] = requestedAt;
    data['username'] = username;
    data['is_activated'] = isActivated;
    data['class'] = classes;
    return data;
  }
}

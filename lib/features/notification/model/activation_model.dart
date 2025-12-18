class ActivationRequestModel {
  int? id;
  String? requestedAt;
  String? username;
  bool? isActivated;
  int? classes;
  String? code;

  ActivationRequestModel({
    this.id,
    this.requestedAt,
    this.username,
    this.isActivated,
    this.classes,
    this.code,
  });

  ActivationRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestedAt = json['requested_at'];
    username = json['username'];
    isActivated = json['is_activated'];
    classes = json['class'];
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

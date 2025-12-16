import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';

class ClassLevel {
  int? id;
  String? createdAt;
  int? classs;
  int? level;
  Level? levelModel;

  ClassLevel({this.id, this.createdAt, this.classs, this.levelModel});

  ClassLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    classs = json['class'];
    level = json['level'] is int ? json['level'] : null;
    levelModel = json[DbTable.level] is Map
        ? Level.fromJson(json[DbTable.level])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['class'] = classs;
    data['level'] = level;
    return data;
  }
}

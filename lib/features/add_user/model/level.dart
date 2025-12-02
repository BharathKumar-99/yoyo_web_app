class Level {
  int? id;
  String? createdAt;
  String? level;

  Level({this.id, this.createdAt, this.level});

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['level'] = level;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Level && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => level!;
}

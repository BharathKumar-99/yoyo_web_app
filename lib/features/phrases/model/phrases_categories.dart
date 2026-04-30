class PhraseCategories {
  int? id;
  String? createdAt;
  String? name;
  int? language;
  int? itemIndex;
  String? image;
  int? schoolId;
  bool? active;

  PhraseCategories({
    this.id,
    this.createdAt,
    this.name,
    this.language,
    this.itemIndex,
    this.image,
    this.schoolId,
    this.active,
  });

  PhraseCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    language = json['language'];
    itemIndex = json['item_index'];
    image = json['image'];
    schoolId = json['school_id'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['language'] = language;
    data['item_index'] = itemIndex;
    data['image'] = image;
    data['school_id'] = schoolId;
    data['Active'] = active;
    return data;
  }
}

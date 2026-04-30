class UserViewDataModel {
  int? idx;
  String? userId;
  String? username;
  String? email;
  String? activationCode;
  String? firstName;
  String? surName;
  int? classId;
  String? className;
  int? schoolId;
  int? languageId;
  String? languageName;

  int? effort;
  int? vocab;
  int? score;

  int? attempts;
  int? completedAttempts;

  DateTime? started;

  String? badgeName;
  String? badgeImage;
  String? badgeLevel;

  int? schoolRank;
  int? classRank;
  int? rankClass;
  int? homeWorkRank;

  UserViewDataModel({
    this.idx,
    this.userId,
    this.username,
    this.email,
    this.activationCode,
    this.firstName,
    this.surName,
    this.classId,
    this.className,
    this.schoolId,
    this.languageId,
    this.languageName,
    this.effort,
    this.vocab,
    this.score,
    this.attempts,
    this.completedAttempts,
    this.started,
    this.badgeName,
    this.badgeImage,
    this.badgeLevel,
    this.schoolRank,
    this.classRank,
    this.rankClass,
    this.homeWorkRank,
  });

  UserViewDataModel.fromJson(Map<String, dynamic> json) {
    idx = json['idx'];
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    activationCode = json['activation_code'];
    firstName = json['first_name'];
    surName = json['sur_name'];
    classId = json['class_id'];
    className = json['class_name'];
    schoolId = json['school_id'];
    languageId = json['language_id'];
    languageName = json['language_name'];

    effort = json['effort'];
    vocab = json['vocab'];
    score = json['score'];

    attempts = json['attempts'];
    completedAttempts = json['completed_attempts'];

    started = json['started'] != null ? DateTime.parse(json['started']) : null;

    badgeName = json['badge_name'];
    badgeImage = json['badge_image'];
    badgeLevel = json['badge_level'];

    schoolRank = json['school_rank'];
    classRank = json['class_rank'];
    rankClass = json['rank_class'];
    homeWorkRank = json['home_work_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['idx'] = idx;
    data['user_id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['activation_code'] = activationCode;
    data['first_name'] = firstName;
    data['sur_name'] = surName;
    data['class_id'] = classId;
    data['class_name'] = className;
    data['school_id'] = schoolId;
    data['language_id'] = languageId;
    data['language_name'] = languageName;

    data['effort'] = effort;
    data['vocab'] = vocab;
    data['score'] = score;

    data['attempts'] = attempts;
    data['completed_attempts'] = completedAttempts;

    data['started'] = started?.toIso8601String();

    data['badge_name'] = badgeName;
    data['badge_image'] = badgeImage;
    data['badge_level'] = badgeLevel;

    data['school_rank'] = schoolRank;
    data['class_rank'] = classRank;
    data['rank_class'] = rankClass;
    data['home_work_rank'] = homeWorkRank;

    return data;
  }
}

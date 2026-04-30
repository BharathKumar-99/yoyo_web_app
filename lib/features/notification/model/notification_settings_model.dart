import 'dart:convert';

class NotificationSettingsModel {
  int? id;
  String? createdAt;
  int? classId;
  NotificationSettingsData? settings;

  NotificationSettingsModel({
    this.id,
    this.createdAt,
    this.classId,
    this.settings,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    NotificationSettingsData? parsedSettings;
    if (json['settings'] != null) {
      if (json['settings'] is String) {
        parsedSettings = NotificationSettingsData.fromJson(
          jsonDecode(json['settings']),
        );
      } else if (json['settings'] is Map<String, dynamic>) {
        parsedSettings = NotificationSettingsData.fromJson(json['settings']);
      }
    }

    return NotificationSettingsModel(
      id: json['id'] as int?,
      createdAt: json['created_at'] as String?,
      classId: json['class'] as int?,
      settings: parsedSettings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'class': classId,
      'settings': settings != null ? jsonEncode(settings!.toJson()) : null,
    };
  }
}

class NotificationSettingsData {
  NotificationTriggerSetting? hwChampion;
  NotificationTriggerSetting? reviseExam;
  NotificationTriggerSetting? homeWorkDue;
  NotificationTriggerSetting? homeWorkSet;
  NotificationTriggerSetting? topClassLeague;
  NotificationTriggerSetting? topSchoolLeague;

  NotificationSettingsData({
    this.hwChampion,
    this.reviseExam,
    this.homeWorkDue,
    this.homeWorkSet,
    this.topClassLeague,
    this.topSchoolLeague,
  });

  factory NotificationSettingsData.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsData(
      hwChampion: json['hw_champion'] != null
          ? NotificationTriggerSetting.fromJson(json['hw_champion'])
          : null,
      reviseExam: json['revise_exam'] != null
          ? NotificationTriggerSetting.fromJson(json['revise_exam'])
          : null,
      homeWorkDue: json['home_work_due'] != null
          ? NotificationTriggerSetting.fromJson(json['home_work_due'])
          : null,
      homeWorkSet: json['home_work_set'] != null
          ? NotificationTriggerSetting.fromJson(json['home_work_set'])
          : null,
      topClassLeague: json['top_class_league'] != null
          ? NotificationTriggerSetting.fromJson(json['top_class_league'])
          : null,
      topSchoolLeague: json['top_school_league'] != null
          ? NotificationTriggerSetting.fromJson(json['top_school_league'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hw_champion': hwChampion?.toJson(),
      'revise_exam': reviseExam?.toJson(),
      'home_work_due': homeWorkDue?.toJson(),
      'home_work_set': homeWorkSet?.toJson(),
      'top_class_league': topClassLeague?.toJson(),
      'top_school_league': topSchoolLeague?.toJson(),
    };
  }
}

class NotificationTriggerSetting {
  String? title;
  String? body;
  String? deliveryMode;
  String? selectedDeliveryDate;
  bool? active;

  NotificationTriggerSetting({
    this.title,
    this.body,
    this.deliveryMode,
    this.selectedDeliveryDate,
    this.active,
  });

  factory NotificationTriggerSetting.fromJson(Map<String, dynamic> json) {
    return NotificationTriggerSetting(
      title: json['title'] as String?,
      body: json['body'] as String?,
      deliveryMode: json['delivery_mode'] as String?,
      selectedDeliveryDate: json['selected_delivery_date'] as String?,
      active: json['active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'delivery_mode': deliveryMode,
      'selected_delivery_date': selectedDeliveryDate,
      'active': active,
    };
  }
}

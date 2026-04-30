class HomeworkConfigModel {
  int? id;
  String? createdAt;
  int? classId;
  String? manualCadence;
  String? autoCadence;
  String? autoCadenceTime;
  String? notification;
  String? homeworkPrompt;
  String? homeworkDocument;
  bool? isAutoEnabled;
  String? lastRunAt;
  String? nextRunAt;
  int? schoolId;

  HomeworkConfigModel({
    this.id,
    this.createdAt,
    this.classId,
    this.manualCadence,
    this.autoCadence,
    this.autoCadenceTime,
    this.notification,
    this.homeworkPrompt,
    this.homeworkDocument,
    this.isAutoEnabled,
    this.lastRunAt,
    this.nextRunAt,
    this.schoolId,
  });

  factory HomeworkConfigModel.fromJson(Map<String, dynamic> json) {
    return HomeworkConfigModel(
      id: json['id'] as int?,
      createdAt: json['created_at'] as String?,
      classId: json['class_id'] as int?,
      manualCadence: json['manual_cadence'] as String?,
      autoCadence: json['auto_cadence'] as String?,
      autoCadenceTime: json['auto_cadence_time'] as String?,
      notification: json['notification'] as String?,
      homeworkPrompt: json['homework_prompt'] as String?,
      homeworkDocument: json['homework_document'] as String?,
      isAutoEnabled: json['is_auto_enabled'] as bool?,
      lastRunAt: json['last_run_at'] as String?,
      nextRunAt: json['next_run_at'] as String?,
      schoolId: json['school_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'class_id': classId,
      'manual_cadence': manualCadence,
      'auto_cadence': autoCadence,
      'auto_cadence_time': autoCadenceTime,
      'notification': notification,
      'homework_prompt': homeworkPrompt,
      'homework_document': homeworkDocument,
      'is_auto_enabled': isAutoEnabled,
      'last_run_at': lastRunAt,
      'next_run_at': nextRunAt,
      'school_id': schoolId,
    };
  }
}

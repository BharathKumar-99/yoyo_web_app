import '../../../config/constants/constants.dart';
import '../../home/model/phrases_model.dart';

class HomeworkModel {
  final int? id;
  final DateTime? createdAt;
  final String? title;
  final DateTime? setDate;
  final DateTime? dueDate;
  final bool? repeat;
  final List<PhraseModel>? phrases;

  HomeworkModel({
    this.id,
    this.createdAt,
    this.title,
    this.setDate,
    this.dueDate,
    this.repeat,
    this.phrases,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return HomeworkModel();

    return HomeworkModel(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      title: json['title'] as String?,
      setDate: json['set_date'] != null
          ? DateTime.tryParse(json['set_date'])
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'])
          : null,
      repeat: json['repeat'] as bool?,
      phrases: (json[DbTable.phrase] as List?)
          ?.map((e) => PhraseModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'title': title,
      'set_date': setDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'repeat': repeat,
    };
  }
}

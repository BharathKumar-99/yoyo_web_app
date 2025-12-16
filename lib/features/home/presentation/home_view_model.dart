import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/add_teacher/model/teacher_model.dart';
import 'package:yoyo_web_app/features/home/data/home_repo.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';
import '../../add_user/model/level.dart';
import '../../common/common_view_model.dart';
import '../model/classes_model.dart';
import '../model/school.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_saver/file_saver.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepo _repo = HomeRepo();
  List<School> homedata = [];
  List<Language?> languages = [];
  int participation = 0;
  int effort = 0;
  int avrageScore = 0;
  List<int> efforts = [];
  List<int> average = [];
  List<UserResult> participationList = [];
  int totalNoStudents = 0;
  School? selectedSchool;
  Classes? selectedClass;
  Level? selectedLevel;
  String? selectedTimeFrame;
  List<Level> levels = [];
  List<String> timeFrame = ["Today", "This Week", "This Month", "This Year"];
  Language? selectedLanguage;
  List<String> goodWords = [];
  List<String> badWords = [];
  List<Student> students = [];
  List<Student> filteredStudents = [];
  String? sortKey = 'participated';
  bool ascending = true;
  List<TeacherModel>? teacherModel;
  CommonViewModel? commonViewModel;

  HomeViewModel() {
    getHomeData();
  }

  getHomeData() async {
    homedata = await _repo.getHomeData();

    applyFilter();
    applyStudentFilter();
    assignLanLvl();
    commonViewModel = Provider.of<CommonViewModel>(ctx!, listen: false);
    teacherModel = commonViewModel?.teacher?.teacher;
    if (teacherModel?.isNotEmpty ?? false) {
      selectSchool(
        homedata.firstWhere(
          (val) => val.id == commonViewModel?.teacher?.schools?.id,
        ),
      );
    }
    sortBy('participated');
    notifyListeners();
  }

  T? getMaxOrNull<T extends num>(List<T> list) {
    if (list.isEmpty) return null;
    return list.reduce((a, b) => a > b ? a : b);
  }

  // 1. Data Mapping
  List<List<String>> _mapStudentsToPdfData(List<Student> students) {
    final maxScore = students.map((e) => e.score).toList().maxValue;
    final maxEffort = students.map((e) => e.effort).toList().maxValue;
    final maxVocab = students.map((e) => e.vocab).toList().maxValue;

    return students.map((student) {
      // NOTE: This array order must match the headers in _generatePdf
      return [
        student.userModel?.firstName ?? 'N/A',
        student.userModel?.username ?? 'N/A',
        (student.userModel?.userResult?.length ?? 0) > 0 ? "✅" : "❌",
        (student.level?.level?.length ?? 0) >= 2
            ? student.level!.level!.substring(0, 2)
            : student.level?.level ?? 'N/A',

        (student.vocab == maxVocab && student.vocab != 0
            ? "${student.vocab} 🥇"
            : "${student.vocab}"),
        (student.score == maxScore && student.score != 0
            ? "${student.score}% 🥇"
            : "${student.score}%"),
        (student.effort == maxEffort && student.effort != 0
            ? "${student.effort}% 🥇"
            : "${student.effort}%"),
      ];
    }).toList();
  }

  Future<pw.MemoryImage> _loadAssetImage(
    BuildContext context,
    String assetPath,
  ) async {
    final ByteData bytes = await DefaultAssetBundle.of(context).load(assetPath);
    final Uint8List list = bytes.buffer.asUint8List();
    return pw.MemoryImage(list);
  }

  Future<pw.MemoryImage?> _loadNetworkImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return pw.MemoryImage(response.bodyBytes);
      } else {
        log(
          'Failed to load image from $url. Status code: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      log('Error loading network image: $e');
      return null;
    }
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];

    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  String formatCustomDateTime(DateTime dateTime) {
    String getDaySuffix(int day) {
      if (day >= 11 && day <= 13) return 'th';
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    final day = dateTime.day;
    final daySuffix = getDaySuffix(day);
    final timeFormat = (dateTime.minute == 0) ? 'h a' : 'h:mm a';

    final monthAndTime = DateFormat('MMMM @ $timeFormat').format(dateTime);

    final customDayString = '$day$daySuffix ';

    return customDayString + monthAndTime;
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    BuildContext context,
    List<Student> filteredStudents,
  ) async {
    final pdf = pw.Document(title: '${selectedSchool?.schoolName} Scoreboard');
    final pw.Font emojiFont = await PdfGoogleFonts.notoColorEmoji();
    final data = _mapStudentsToPdfData(filteredStudents);
    final chunkedData = _chunkList(data, 13);
    DateTime time = DateTime.now();

    final PdfColor startColor = PdfColor.fromHex('8A2BE2');
    final PdfColor endColor = PdfColor.fromHex('FF6347');

    final headerTextStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );

    try {
      final image = await _loadNetworkImage(selectedSchool?.image ?? '');
      final logo = await _loadAssetImage(context, ImageConstants.logoHome);

      for (var chunk in chunkedData) {
        pdf.addPage(
          pw.Page(
            pageFormat: format.landscape,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context pageContext) {
              final backgroundWidget = pw.Container(
                width: pageContext.page.pageFormat.width,
                height: pageContext.page.pageFormat.height,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    begin: pw.Alignment.topLeft,
                    end: pw.Alignment.bottomRight,
                    colors: [startColor, endColor],
                    stops: const [0.0, 1.0],
                  ),
                ),
              );

              final contentStructure = pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          if (image != null)
                            pw.Image(image, width: 100, height: 100),
                          pw.SizedBox(width: 30),
                          pw.Text(
                            'Dated: ${formatCustomDateTime(time)}',
                            style: headerTextStyle,
                          ),
                        ],
                      ),
                      pw.Image(logo, width: 80, height: 80),
                    ],
                  ),
                  pw.Text(
                    selectedSchool?.schoolName ?? '',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  pw.Expanded(
                    child: pw.TableHelper.fromTextArray(
                      context: pageContext,
                      headers: const [
                        'Name',
                        'UserName',
                        'Participated',
                        'Level',
                        'Vocab',
                        'Av. Score',
                        'Effort',
                      ],
                      data: chunk,
                      border: pw.TableBorder.all(width: 1.0),
                      headerStyle: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                      headerDecoration: const pw.BoxDecoration(
                        color: PdfColors.purple,
                      ),
                      cellAlignment: pw.Alignment.center,
                      cellStyle: pw.TextStyle(
                        fontSize: 12,
                        fontFallback: [emojiFont],
                      ),
                      cellDecoration: (index, data, rowNum) =>
                          pw.BoxDecoration(color: PdfColors.white),
                    ),
                  ),
                ],
              );

              final finalContentWrapper = pw.Padding(
                padding: const pw.EdgeInsets.all(30),
                child: contentStructure,
              );

              return pw.Stack(
                children: [backgroundWidget, finalContentWrapper],
              );
            },
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }

    return pdf.save();
  }

  pdfCreater() async {
    final pdfBytes = await _generatePdf(
      PdfPageFormat.a4,
      ctx!,
      filteredStudents.where((val) => val.userModel?.isTester != true).toList(),
    );

    await FileSaver.instance.saveFile(
      name: selectedSchool?.schoolName ?? '',
      bytes: pdfBytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );

    ScaffoldMessenger.of(
      ctx!,
    ).showSnackBar(const SnackBar(content: Text('PDF download initiated!')));
  }

  assignLanLvl() {
    List<Level> lvl = [];
    List<Language> lang = [];
    if (selectedSchool != null) {
      selectedSchool?.schoolLanguage?.forEach((val) {
        lang.add(val.language!);
      });
      if (selectedClass != null) {
        selectedClass?.classLevel?.forEach((val) {
          lvl.add(val.levelModel!);
        });
      } else {
        selectedSchool?.classes?.forEach((cal) {
          cal.classLevel?.forEach((l) {
            lvl.add(l.levelModel!);
          });
        });
      }
    } else {
      for (var val in homedata) {
        val.schoolLanguage?.forEach((ln) {
          lang.add(ln.language!);
        });
        val.classes?.forEach((cal) {
          cal.classLevel?.forEach((l) {
            lvl.add(l.levelModel!);
          });
        });
      }
    }

    levels = lvl.toSet().toList();
    languages = lang.toSet().toList();
  }

  List<UserResult> getUniqueUsers(List<UserResult> usersResult) {
    final seen = <String>{};
    final uniqueList = <UserResult>[];

    for (var user in usersResult) {
      if (user.type == 'Learned') {
        if (user.userId != null && !seen.contains(user.userId)) {
          seen.add(user.userId!);
          if (matchTimeFrame(user.createdAt!)) {
            uniqueList.add(user);
          }
        }
      }
    }

    return uniqueList;
  }

  void sortBy(String key) {
    if (sortKey == key) {
      ascending = !ascending; // toggle ASC ↔ DESC
    } else {
      sortKey = key;
      ascending = true;
    }

    filteredStudents.sort((a, b) {
      dynamic x;
      dynamic y;

      switch (key) {
        case "name":
          x = a.userModel?.firstName ?? "";
          y = b.userModel?.firstName ?? "";
          break;

        case "username":
          x = a.userModel?.username ?? "";
          y = b.userModel?.username ?? "";
          break;

        case "participated":
          x = a.userModel?.userResult?.length ?? 0;
          y = b.userModel?.userResult?.length ?? 0;
          break;

        case "level":
          x = a.level?.level ?? "";
          y = b.level?.level ?? "";
          break;

        case "phrases":
          x = a.userModel?.userResult?.length ?? 0;
          y = b.userModel?.userResult?.length ?? 0;
          break;

        case "vocab":
          x = a.vocab ?? 0;
          y = b.vocab ?? 0;
          break;

        case "avgScore":
          x = a.score ?? 0;
          y = b.score ?? 0;
          break;

        default:
          x = "";
          y = "";
      }

      int result = Comparable.compare(x, y);
      return ascending ? result : -result;
    });
    notifyListeners();
  }

  void selectSchool(School? val) {
    selectedSchool = val;
    selectedClass = null;
    selectedLanguage = null;
    selectedLevel = null;
    applyFilter();
    notifyListeners();
  }

  void selectClass(Classes? val) {
    selectedClass = val;
    applyFilter();
    notifyListeners();
  }

  void selectLevel(Level? val) {
    selectedLevel = val;
    applyFilter();
    applyStudentFilter();
    notifyListeners();
  }

  void selectTimeFrame(String? val) {
    selectedTimeFrame = val;
    applyFilter();
    applyStudentFilter();
    notifyListeners();
  }

  void selectLanguage(Language? val) {
    selectedLanguage = val;
    applyFilter();
    applyStudentFilter();
    notifyListeners();
  }

  applyFilter() {
    int avgTotalStudents = 0;
    totalNoStudents = 0;
    effort = 0;
    avrageScore = 0;
    int scoreSum = 0;
    participationList = [];
    students = [];
    selectedSchool == null
        ? homedata.forEach((val) {
            val.classes?.forEach((cal) {
              totalNoStudents = totalNoStudents + (cal.students?.length ?? 0);
              avgTotalStudents =
                  avgTotalStudents +
                  (cal.students?.where((sc) => (sc.score ?? 0) > 0).length ??
                      0);
              cal.students?.forEach((std) {
                students.add(std);
                scoreSum = scoreSum + (std.score ?? 0);
                std.userModel?.userResult?.forEach((user) {
                  participationList.add(user);
                });
              });
            });
          })
        : selectedClass == null
        ? selectedSchool?.classes?.forEach((cal) {
            totalNoStudents = totalNoStudents + (cal.students?.length ?? 0);
            avgTotalStudents =
                avgTotalStudents +
                (cal.students?.where((sc) => (sc.score ?? 0) > 0).length ?? 0);
            cal.students?.forEach((std) {
              students.add(std);
              scoreSum = scoreSum + (std.score ?? 0);
              std.userModel?.userResult?.forEach((user) {
                participationList.add(user);
              });
            });
          })
        : selectedClass?.students?.forEach((std) {
            students.add(std);
            totalNoStudents = totalNoStudents + 1;
            if ((std.score ?? 0) > 0) {
              avgTotalStudents = avgTotalStudents + 1;
            }
            scoreSum = scoreSum + (std.score ?? 0);
            std.userModel?.userResult?.forEach((user) {
              participationList.add(user);
            });
          });
    filteredStudents = students;
    for (var attempt in participationList) {
      attempt.goodWords?.forEach((val) {
        goodWords.add(val);
      });
      attempt.badWords?.forEach((val) {
        badWords.add(val);
      });
      effort = effort + (attempt.attempt ?? 0);
    }

    participationList = getUniqueUsers(participationList);

    int activeusers = 0;
    int totalusers = 0;
    for (var std in filteredStudents) {
      if (std.userModel?.isTester != true) {
        totalusers++;
        if ((std.userModel?.userResult?.length ?? 0) > 0) {
          activeusers++;
        }
      }
    }
    participation = ((activeusers / totalusers) * 100).toInt();
    avrageScore = (scoreSum / avgTotalStudents).toInt();
    goodWords = getTopWords(goodWords);
    badWords = getTopWords(badWords);
    assignLanLvl();
    notifyListeners();
  }

  bool matchLanguage(UserResult val) {
    if (selectedLanguage == null) return true;
    return (val.phraseModel?.language ?? 0) == selectedLanguage!.id;
  }

  bool matchTimeFrame(DateTime date) {
    switch (selectedTimeFrame) {
      case 'Today':
        return date.isToday;
      case 'This Week':
        return date.isThisWeek;
      case 'This Month':
        return date.isThisMonth;
      case 'This Year':
        return date.isThisYear;
      default:
        return true;
    }
  }

  void applyStudentFilter() {
    final List<Student> originalList = students;
    filteredStudents = [];

    for (var student in originalList) {
      // Level filter
      if (selectedLevel != null && student.level?.id != selectedLevel!.id) {
        continue; // Skip this student
      }

      final results = <UserResult>[];

      for (var val in (student.userModel?.userResult ?? [])) {
        final date = val.createdAt!;
        if (matchTimeFrame(date) && matchLanguage(val)) {
          results.add(val);
        }
      }

      // Only include the student if they have filtered results
      if (results.isNotEmpty) {
        student.userModel?.userResult = results;
        filteredStudents.add(student);
      }
    }
  }

  List<String> getTopWords(List<String> words, {int top = 10}) {
    final counts = <String, int>{};

    for (var w in words) {
      w = w.toLowerCase().trim();
      if (w.isEmpty) continue;

      counts[w] = (counts[w] ?? 0) + 1;
    }

    final sortedKeys = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

    return sortedKeys.take(top).toList();
  }
}

extension on List<int?> {
  get maxValue => reduce((a, b) => a! > b! ? a : b);
}

extension DateExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();

    // Start of current week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    // End of current week (Sunday)
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }
}

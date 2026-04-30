import 'dart:developer';
import 'dart:math' hide log;
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/date_externtion.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';
import '../../add_user/model/level.dart';
import '../../common/common_view_model.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeViewModel extends ChangeNotifier {
  List<Language?> languages = [];
  int participation = 0;
  int participationPercentage = 0;
  int effort = 0;
  int effortPercentage = 0;
  int avrageScore = 0;
  int avrageScorePercentage = 0;

  Level? selectedLevel;
  String? selectedTimeFrame;
  List<Level> levels = [];
  List<String> timeFrame = ["Today", "This Week", "This Month", "This Year"];
  Language? selectedLanguage;
  List<String> goodWords = [];
  List<String> topGoodWords = [];
  List<String> badWords = [];
  List<String> topBadWords = [];

  String? sortKey = 'participated';
  bool ascending = true;

  final CommonViewModel commonViewModel;

  List<Student> allStudents = [];
  List<UserResult> allUserResults = [];
  List<Student> students = [];
  List<UserResult> filteredResults = [];

  HomeViewModel(this.commonViewModel) {
    commonViewModel.addListener(onSchoolChanged);
    getHomeData();
  }

  getHomeData() async {
    assignStudentsFromSchools();
    assignUserResultsFromStudents();
    applyFilters();
  }

  void assignStudentsFromSchools() {
    allStudents = [];
    for (var school in commonViewModel.schools) {
      school.classes?.forEach((cls) {
        cls.studentClasses?.forEach((studentClass) {
          if (studentClass.user?.student != null &&
              studentClass.user?.isTester != true) {
            allStudents.add(studentClass.user!.student!);
          }
        });
      });
    }
  }

  applyFilters() async {
    getResults();
    assignResultsToStudents();
    applyMetrics();
    applyOldMetrics();
    notifyListeners();
  }

  getResults() {
    goodWords = [];
    badWords = [];
    filteredResults = [];
    for (UserResult res in allUserResults) {
      if (selectedTimeFrame == null) {
        if (matchLanguage(res)) {
          res.goodWords?.forEach((w) => goodWords.add(w));
          res.badWords?.forEach((w) => badWords.add(w));
          filteredResults.add(res);
        }
      } else if (res.createdAt != null && matchTimeFrame(res.createdAt!)) {
        if (matchLanguage(res)) {
          res.goodWords?.forEach((w) => goodWords.add(w));
          res.badWords?.forEach((w) => badWords.add(w));
          filteredResults.add(res);
        }
      }
    }

    topGoodWords = getTopWords(goodWords);
    topBadWords = getTopWords(badWords);
  }

  void assignUserResultsFromStudents() {
    allUserResults = [];
    for (var student in allStudents) {
      allUserResults.addAll(student.userModel?.userResult ?? []);
    }
  }

  assignResultsToStudents() {
    List<String> userIds = [];
    List<UserResult> uniqueResults = [];
    students = [];
    for (var res in filteredResults) {
      if (res.userId != null && !userIds.contains(res.userId)) {
        userIds.add(res.userId!);
        uniqueResults.add(res);
      }
    }

    for (var student in allStudents) {
      if (commonViewModel.selectedSchool == null) {
        students.add(student);
      } else if (commonViewModel.selectedSchool != null &&
          commonViewModel.selectedClass == null) {
        if (student.userModel?.school == commonViewModel.selectedSchool?.id) {
          students.add(student);
        }
      } else if (student.userModel?.studentClasses?.first.classId ==
          commonViewModel.selectedClass?.id) {
        students.add(student);
      }
    }

    for (var std in students) {
      std.userModel?.userResult = filteredResults
          .where((res) => res.userId == std.userId)
          .toList();
    }
  }

  applyMetrics() {
    List<String> userIds = [];
    List<UserResult> uniqueResults = [];
    List<Student> classStudent = [];
    List<Student> totalclassStudent = [];

    for (var res in filteredResults) {
      if (res.userId != null && !userIds.contains(res.userId)) {
        userIds.add(res.userId!);
        if (students.any((s) => s.userId == res.userId)) {
          uniqueResults.add(res);
        }
      }
    }
    for (var student in allStudents) {
      for (var res in uniqueResults) {
        if (student.userId == res.userId) {
          if (commonViewModel.selectedSchool == null) {
            classStudent.add(student);
          } else if (commonViewModel.selectedSchool != null &&
              commonViewModel.selectedClass == null) {
            if (student.userModel?.school ==
                commonViewModel.selectedSchool?.id) {
              classStudent.add(student);
            }
          } else if (student.userModel?.studentClasses?.first.classId ==
              commonViewModel.selectedClass?.id) {
            classStudent.add(student);
          }
        }
      }
    }

    for (var student in allStudents) {
      if (commonViewModel.selectedSchool == null) {
        totalclassStudent.add(student);
      } else if (commonViewModel.selectedSchool != null &&
          commonViewModel.selectedClass == null) {
        if (student.userModel?.school == commonViewModel.selectedSchool?.id) {
          totalclassStudent.add(student);
        }
      } else if (student.userModel?.studentClasses?.first.classId ==
          commonViewModel.selectedClass?.id) {
        totalclassStudent.add(student);
      }
    }
    int activeusers = classStudent.length;
    participation = classStudent.isEmpty
        ? 0
        : ((activeusers / totalclassStudent.length) * 100).round();
    int totalAttempts = uniqueResults.fold(
      0,
      (sum, res) => sum + (res.attempt ?? 0).toInt(),
    );
    int totalListens = uniqueResults.fold(
      0,
      (sum, res) => sum + (res.listen ?? 0).toInt(),
    );
    int P = uniqueResults.where((res) => (res.scoreSubmitted == true)).length;
    int U = uniqueResults.where((res) => (res.phrasesId != null)).length;

    effort = calculateEffort(totalAttempts, totalListens, P, U).toInt();

    int totalScoreSum = 0;
    int totalStudentsWithScores = 0;
    for (var element in uniqueResults) {
      if ((element.score ?? 0) > 80 && element.scoreSubmitted == true) {
        totalScoreSum += (element.score ?? 0);
        totalStudentsWithScores++;
      }
    }

    avrageScore = totalScoreSum == 0
        ? 0
        : (totalScoreSum / totalStudentsWithScores).round();
  }

  applyOldMetrics() {
    List<UserResult> results = [];
    for (UserResult res in allUserResults) {
      if (selectedTimeFrame == null) {
        if (matchLanguage(res)) {
          res.goodWords?.forEach((w) => goodWords.add(w));
          res.badWords?.forEach((w) => badWords.add(w));
          results.add(res);
        }
        continue;
      } else if (res.createdAt != null &&
          matchPreviousTimeFrame(res.createdAt!)) {
        if (matchLanguage(res)) {
          res.goodWords?.forEach((w) => goodWords.add(w));
          res.badWords?.forEach((w) => badWords.add(w));
          results.add(res);
        }
      }
    }

    List<String> userIds = [];
    List<UserResult> uniqueResults = [];
    List<Student> classStudent = [];
    for (var res in results) {
      if (res.userId != null && !userIds.contains(res.userId)) {
        userIds.add(res.userId!);
        uniqueResults.add(res);
      }
    }
    for (var student in allStudents) {
      for (var res in uniqueResults) {
        if (student.userId == res.userId) {
          if (commonViewModel.selectedSchool == null) {
            classStudent.add(student);
            break;
          } else if (commonViewModel.selectedSchool != null &&
              commonViewModel.selectedClass == null) {
            if (student.userModel?.school ==
                commonViewModel.selectedSchool?.id) {
              classStudent.add(student);
              break;
            }
          } else if (student.userModel?.studentClasses?.first.classId ==
              commonViewModel.selectedClass?.id) {
            classStudent.add(student);
            break;
          }
        }
      }
    }
    int activeusers = classStudent
        .where((s) => (s.userModel?.userResult?.isNotEmpty ?? false))
        .length;

    int totalAttempts = filteredResults.fold(
      0,
      (sum, res) => sum + (res.attempt ?? 0).toInt(),
    );
    int totalListens = filteredResults.fold(
      0,
      (sum, res) => sum + (res.listen ?? 0).toInt(),
    );
    int P = filteredResults.where((res) => (res.scoreSubmitted == true)).length;
    int U = filteredResults.where((res) => (res.phrasesId != null)).length;

    effortPercentage = calculateGrowthPercentage(
      oldValue: calculateEffort(
        totalAttempts, // A
        totalListens, // L
        P, // P
        U, // U
      ).toInt(),
      newValue: effort,
    );
    int totalScoreSum = classStudent.fold(
      0,
      (sum, student) => sum + (student.score ?? 0),
    );

    participationPercentage = calculateGrowthPercentage(
      oldValue: classStudent.isEmpty
          ? 0
          : ((activeusers / classStudent.length) * 100).toInt(),
      newValue: participation,
    );
    int avgTotalStudents = classStudent.where((s) => (s.score ?? 0) > 0).length;

    avrageScorePercentage = calculateGrowthPercentage(
      oldValue: avgTotalStudents == 0
          ? 0
          : (totalScoreSum / avgTotalStudents).toInt(),
      newValue: avrageScore,
    );
  }

  int calculateGrowthPercentage({
    required int oldValue,
    required int newValue,
  }) {
    if (oldValue <= 10) {
      return newValue - oldValue; // raw change
    }

    return (((newValue - oldValue) / oldValue) * 100).round();
  }

  double calculateEffort(
    int A, // total attempts
    int L, // total listens
    int P, // total phrases learned
    int U, // total unique phrases attempted
  ) {
    // Tuning constants
    const double k1 = 5; // struggle curve
    const double k2 = 8; // listening curve
    const double k3 = 20; // volume curve

    // Safety guards
    final double safeP = max(P, 1).toDouble();
    final double safeU = max(U, 1).toDouble();

    // Normalised per-phrase values (with caps)
    final double attemptsPerPhrase = min(A / safeP, 20);
    final double listensPerPhrase = min(L / safeP, 30);

    // Core scores (0–1)
    final double struggleScore = 1 - exp(-attemptsPerPhrase / k1);

    final double listeningScore = 1 - exp(-listensPerPhrase / k2);

    final double volumeScore = 1 - exp(-P / k3);

    final double coverageScore = min(P / safeU, 1);

    // Weighted effort (0–100)
    final double effort =
        100 *
        (0.40 * struggleScore +
            0.25 * listeningScore +
            0.25 * volumeScore +
            0.10 * coverageScore);

    return effort.clamp(0, 100);
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
        (student.userModel?.userResult?.length ?? 0).toString(),
        (student.userModel?.userResult?.fold(
          0,
          (prev, en) => prev + (en.attempt ?? 0),
        )).toString(),
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
    final pdf = pw.Document(
      title: '${commonViewModel.selectedSchool?.schoolName} Scoreboard',
    );
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
      final image = await _loadNetworkImage(
        commonViewModel.selectedSchool?.image ?? '',
      );
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
                    commonViewModel.selectedSchool?.schoolName ?? '',
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
                        'Phrases',
                        'Attempt',
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
      students.where((val) => val.userModel?.isTester != true).toList(),
    );

    await FileSaver.instance.saveFile(
      name: commonViewModel.selectedSchool?.schoolName ?? '',
      bytes: pdfBytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );

    ScaffoldMessenger.of(
      ctx!,
    ).showSnackBar(const SnackBar(content: Text('PDF download initiated!')));
  }

  void onSchoolChanged() {
    selectedLanguage = null;
    selectedLevel = null;
    getHomeData();
    selectLanguage(commonViewModel.selectedClass?.language);
    notifyListeners();
  }

  void selectLevel(Level? val) {
    selectedLevel = val;
    applyFilters();
    notifyListeners();
  }

  void selectTimeFrame(String? val) {
    selectedTimeFrame = val;
    applyFilters();
    notifyListeners();
  }

  void selectLanguage(Language? val) {
    selectedLanguage = val;
    applyFilters();
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

  bool matchPreviousTimeFrame(DateTime date) {
    switch (selectedTimeFrame) {
      case 'Today':
        return date.isYesterday;

      case 'This Week':
        return date.isLastWeek;

      case 'This Month':
        return date.isLastMonth;

      case 'This Year':
        return date.isLastYear;

      default:
        return false;
    }
  }

  void sortBy(String key) {
    if (sortKey == key) {
      ascending = !ascending;
    } else {
      sortKey = key;
      ascending = true;
    }

    students.sort((a, b) {
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

        case "vocab":
          x = a.vocab ?? 0;
          y = b.vocab ?? 0;
          break;

        case "avgScore":
          x = a.score ?? 0;
          y = b.score ?? 0;
          break;

        case "active":
          x = (a.userModel?.isActivated ?? false) ? 1 : 0;
          y = (b.userModel?.isActivated ?? false) ? 1 : 0;
          break;

        case "phrases":
          x = a.userModel?.userResult?.length ?? 0;
          y = b.userModel?.userResult?.length ?? 0;
          break;

        case "attempt":
          x = a.userModel?.userResult?.fold(
            0,
            (prev, el) => prev + (el.attempt ?? 0),
          );
          y = b.userModel?.userResult?.fold(
            0,
            (prev, el) => prev + (el.attempt ?? 0),
          );
          break;

        default:
          x = 0;
          y = 0;
      }

      final result = Comparable.compare(x, y);
      return ascending ? result : -result;
    });

    notifyListeners();
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

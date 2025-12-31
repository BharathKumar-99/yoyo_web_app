import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../home_view_model.dart';

class HomeWidgets {
  static Wrap getFilters(HomeViewModel viewModel) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );

    // Reusable "All" dropdown item
    DropdownMenuItem<T?> allItem<T>() =>
        DropdownMenuItem<T>(value: null, child: Text("All"));

    return Wrap(
      runAlignment: WrapAlignment.start,
      alignment: WrapAlignment.start,
      spacing: 20,
      runSpacing: 20,
      children: [
        // ---------------- SCHOOL ----------------
        if (viewModel.teacherModel?.isEmpty ?? true)
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'School',
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<School?>(
                  initialValue: viewModel.selectedSchool,
                  items: [
                    allItem<School>(),
                    ...viewModel.homedata.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.schoolName ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) => viewModel.selectSchool(val),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(
                        color: Color(0xff9D5DE6),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // ---------------- CLASS ----------------
        // IntrinsicWidth(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Class Group',
        //         style: AppTextStyles.textTheme.headlineMedium!.copyWith(
        //           color: Colors.grey,
        //         ),
        //       ),
        //       const SizedBox(height: 6),
        //       DropdownButtonFormField<Classes?>(
        //         initialValue: viewModel.selectedClass,
        //         items: [
        //           allItem<Classes>(),
        //           ...(viewModel.selectedSchool?.classes ?? []).map(
        //             (e) => DropdownMenuItem(
        //               value: e,
        //               child: Text(e.className ?? ''),
        //             ),
        //           ),
        //         ],
        //         onChanged: (val) => viewModel.selectClass(val),
        //         decoration: InputDecoration(
        //           contentPadding: const EdgeInsets.symmetric(
        //             horizontal: 12,
        //             vertical: 14,
        //           ),
        //           border: border,
        //           enabledBorder: border,
        //           focusedBorder: border.copyWith(
        //             borderSide: const BorderSide(
        //               color: Color(0xff9D5DE6),
        //               width: 2,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // ---------------- LANGUAGE ----------------
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Language',
                style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<Language?>(
                initialValue: viewModel.selectedLanguage,
                items: [
                  allItem<Language>(),
                  ...viewModel.languages.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e?.language ?? ''),
                    ),
                  ),
                ],
                onChanged: (val) => viewModel.selectLanguage(val),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: const BorderSide(
                      color: Color(0xff9D5DE6),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ---------------- LEVEL ----------------
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level',
                style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<Level?>(
                initialValue: viewModel.selectedLevel,
                items: [
                  allItem<Level>(),
                  ...viewModel.levels.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        (e.level?.length ?? 0) >= 2
                            ? e.level?.substring(0, 2) ?? ''
                            : e.level ?? '',
                      ),
                    ),
                  ),
                ],
                onChanged: (val) => viewModel.selectLevel(val),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: const BorderSide(
                      color: Color(0xff9D5DE6),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ---------------- TIME FRAME ----------------
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time Frame',
                style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String?>(
                initialValue: viewModel.selectedTimeFrame,
                items: [
                  const DropdownMenuItem(value: null, child: Text("All")),
                  ...viewModel.timeFrame.map(
                    (e) => DropdownMenuItem(value: e, child: Text(e)),
                  ),
                ],
                onChanged: (val) => viewModel.selectTimeFrame(val),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: const BorderSide(
                      color: Color(0xff9D5DE6),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Row schoolHeading() {
    return Row(
      spacing: 20,
      children: [
        Text('Schools', style: AppTextStyles.textTheme.headlineLarge),
        GestureDetector(
          onTap: () => NavigationHelper.go(RouteNames.addSchool),
          child: Chip(
            label: Text(
              'Add',
              style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
            ),
            avatar: Icon(Icons.add, color: Colors.white),
            color: WidgetStatePropertyAll(Colors.green),
          ),
        ),
      ],
    );
  }

  static Widget homeCard(
    String heading,
    String percentage,
    String upPercentage,
  ) => GradientBorderContainer(
    child: Container(
      padding: EdgeInsets.all(12),
      height: 180,
      width: 180,
      decoration: BoxDecoration(
        color: Color(0xff9D5DE6).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(height: 5),
          Text(
            heading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.textTheme.headlineSmall,
          ),
          Spacer(),
          Text(
            percentage,
            style: AppTextStyles.textTheme.headlineLarge?.copyWith(
              fontSize: 45,
            ),
          ),
          Spacer(),
          Row(children: [Icon(Icons.arrow_outward_sharp), Text(upPercentage)]),
          SizedBox(height: 5),
        ],
      ),
    ),
  );

  static Card getWordsCard(List<String> words, {Color color = Colors.green}) =>
      Card.filled(
        color: color == Colors.green
            ? color.withValues(alpha: 0.2)
            : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.circular(16),
        ),
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  spacing: 5,
                  children: [
                    Text(
                      color == Colors.green ? 'Green' : "Red",
                      style: AppTextStyles.textTheme.titleMedium!.copyWith(
                        color: color,
                      ),
                    ),
                    Text(
                      'words',
                      style: AppTextStyles.textTheme.titleMedium!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Wrap(
                  runSpacing: 10,
                  spacing: 6,
                  children: List.generate(words.length, (index) {
                    final val = words[index];
                    final isLast = index == words.length - 1;

                    return Text(
                      isLast ? val : "$val,",
                      style: AppTextStyles.textTheme.titleMedium!.copyWith(
                        color: Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );

  static Color successGreen = Color(0xFF00C853);
}

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  const GradientBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GradientBorderPainter(), child: child);
  }
}

class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final rrect = RRect.fromRectAndRadius(rect.deflate(2), Radius.circular(12));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

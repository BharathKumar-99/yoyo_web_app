import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../home_view_model.dart';

class HomeWidgets {
  
  static Row schoolHeading() {
    return Row(
      spacing: 20,
      children: [
        Text('Schools', style: AppTextStyles.textTheme.headlineLarge),
        Chip(
          label: Text(
            'Add',
            style: AppTextStyles.textTheme.headlineMedium!.copyWith(
              color: Colors.white,
            ),
          ),
          avatar: Icon(Icons.add, color: Colors.white),
          color: WidgetStatePropertyAll(Colors.green),
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
          Text(heading, style: AppTextStyles.textTheme.headlineSmall),
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

  static Widget schoolWidget(HomeViewModel viewModel, {bool isMobile = false}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: isMobile
            ? MediaQuery.sizeOf(ctx!).width * 2
            : MediaQuery.sizeOf(ctx!).width * 0.8,
        child: Table(
          children: [
            TableRow(
              children: [
                _tableCellHeader('Name'),
                _tableCellHeader('Years'),
                _tableCellHeader('Head Teacher'),
                _tableCellHeader('Languages'),
                _tableCellHeader('Av. Score'),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ],
            ),
            if (viewModel.filteredTableModel.isEmpty)
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                      ),
                      child: Text(
                        '',
                        style: AppTextStyles.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                      ),
                      child: Text(
                        '',
                        style: AppTextStyles.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                      ),
                      child: Center(
                        child: Text(
                          'No Data Found',
                          style: AppTextStyles.textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                      ),
                      child: Text(
                        '',
                        style: AppTextStyles.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                      ),
                      child: Text(
                        '',
                        style: AppTextStyles.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),

            ...viewModel.filteredTableModel.map(
              (val) => TableRow(
                children: [
                  _tableCell(val.name),
                  _tableCell('Years ${val.years.join(',')}'),
                  _tableCell(val.headTeacher),
                  _tableCell(val.languages.toString()),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          Text(
                            '${val.avScore}%',
                            style: AppTextStyles.textTheme.titleLarge!.copyWith(
                              color: Colors.green,
                            ),
                          ),
                          Chip(label: Text('Edit')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TableCell _tableCell(String data, {Color color = Colors.black}) => TableCell(
  child: Padding(
    padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 8),
    child: Text(
      data,
      style: AppTextStyles.textTheme.titleLarge!.copyWith(color: color),
    ),
  ),
);
TableCell _tableCellHeader(String data) => TableCell(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(data, style: AppTextStyles.textTheme.headlineMedium),
  ),
);

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

class FilterSection extends StatelessWidget {
  final HomeViewModel viewModel;
  const FilterSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: CommonWidgets.buildDropdown("School", [
                  "All",
                  ...viewModel.homedata.map((val) => val.schoolName ?? ''),
                ], (val) => viewModel.changeSchool(val)),
              ),
              Expanded(
                child: CommonWidgets.buildDropdown("Time", [
                  "All",
                  "Morning",
                  "Evening",
                ], (v) {}),
              ),
            ],
          ),
          Row(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CommonWidgets.buildDropdown("Language", [
                  "All",

                  ...viewModel.languages.map((val) => val?.language ?? ''),
                ], (val) => viewModel.changeLanguage(val)),
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => viewModel.applyFilter(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2DD36F),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "GO",
                        style: AppTextStyles.textTheme.headlineLarge,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

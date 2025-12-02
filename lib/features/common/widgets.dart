import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';

class CommonWidgets {
  static Widget buildDropdown(
    String label,
    List<String> items,
    Function(dynamic) onChanged,
  ) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.textTheme.headlineMedium),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: items.first,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
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
    );
  }

  static AppBar homeAppBar() {
    return AppBar(
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'YoYo Technologies Ltd',
            style: AppTextStyles.textTheme.titleLarge,
          ),
          SizedBox(width: 30),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: VerticalDivider(),
          ),
          SizedBox(width: 30),
          Text('B Fountain', style: AppTextStyles.textTheme.titleMedium),
          SizedBox(width: 60),
          CircleAvatar(
            backgroundColor: Color(0xffED8768),
            child: Text(
              'BF',
              style: AppTextStyles.textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
            ),
          ),
        ),
      ),
    );
  }

  static AppBar homeAppBarMobile() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Color(0xffED8768),
          child: Text(
            'BF',
            style: AppTextStyles.textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
      title: Text(
        'YoYo Technologies Ltd',
        style: AppTextStyles.textTheme.titleLarge,
      ),
      actions: [Text('B Fountain', style: AppTextStyles.textTheme.titleMedium)],
      actionsPadding: EdgeInsets.only(right: 8),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
            ),
          ),
        ),
      ),
    );
  }
}

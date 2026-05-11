import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import '../constants/constants.dart';
import '../router/navigation_helper.dart';

class PopupDialog {
  static OverlayEntry? _loaderEntry;
  static OverlayEntry? _loaderEntryUpdate;

  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yy').format(date);
  }

  static void show(DateTime time, UserModel? user, int homeworkId) {
    if (_loaderEntry != null) return;

    final context = GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    _loaderEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(color: Colors.black26),
            ),
          ),

          /// Dialog Center
          Center(
            child: AlertDialog.adaptive(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Center(child: Text('Homework is Set!')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 200, child: SuccessAnimation()),
                  Row(
                    spacing: 20,
                    children: [
                      Text('✅'),
                      Text(
                        '10 Phrase created',
                        style: TextTheme.of(context).titleSmall,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Text('✅'),
                      Text(
                        'Notification Sent',
                        style: TextTheme.of(context).titleSmall,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Text('✅'),
                      Text(
                        'Due ${formatDate(time)}',
                        style: TextTheme.of(context).titleSmall,
                      ),
                    ],
                  ),

                  if (user == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 18),
                        Text(
                          'Teacher details missing.\nTest unavailable.',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextTheme.of(
                            context,
                          ).titleSmall?.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                ],
              ),
              actions: [
                (user != null)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => hide(user, homeworkId),
                            child: Text('Test it out'),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _loaderEntry?.remove();
                              _loaderEntry = null;
                              _loaderEntry?.remove();
                              _loaderEntry = null;
                            },
                            child: Text('Ok'),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );

    GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.insert(_loaderEntry!);
  }

  static void hide(UserModel user, int homeworkId) async {
    String email = user.username ?? '';
    String code = user.activationCode ?? "";
    _loaderEntry?.remove();
    _loaderEntry = null;
    _loaderEntry?.remove();
    _loaderEntry = null;
    final url =
        'https://app.yoyospeak.com/autoLink?email=$email&code=$code&homeworkId=$homeworkId';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void hideUpdate() {
    _loaderEntryUpdate?.remove();
    _loaderEntryUpdate = null;
  }

  static void showWidget(Widget child) {
    if (_loaderEntryUpdate != null) return;

    final context = GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    _loaderEntryUpdate = OverlayEntry(
      builder: (context) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black54,
        child: Center(child: child),
      ),
    );

    GoRouter.of(ctx!).routerDelegate.navigatorKey.currentState?.overlay?.insert(
      _loaderEntryUpdate!,
    );
  }
}

class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({super.key});

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // 🔥 This keeps the animation at the last frame
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
        _controller.value = 1.0; // lock to last frame
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AnimationConstants.popupsuccess,
      controller: _controller,
      fit: BoxFit.fill,
      repeat: false,
      renderCache: RenderCache.raster, // ✅ important for web
      options: LottieOptions(
        enableMergePaths: false, // ✅ prevents recursion crash
      ),
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..forward();

        _controller.addListener(() {
          if (_controller.value >= 0.85) {
            _controller.stop(); // stop before broken frames
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

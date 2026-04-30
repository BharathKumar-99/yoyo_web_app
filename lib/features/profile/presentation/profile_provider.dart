import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';
import 'package:yoyo_web_app/features/profile/data/profile_repository.dart';

import '../../../config/router/route_names.dart';
import '../../common/common_view_model.dart';
import '../../home/model/classes_model.dart';
import '../../home/model/user_model.dart';
import '../model/user_view_data_model.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository;
  CommonViewModel? commonViewModel;
  final TextEditingController email = TextEditingController();
  UserViewDataModel? user;
  bool isLoading = true;
  Classes? classes;
  String? nameFromUser;
  List<UserResult>? results = [];
  StreamSubscription<UserViewDataModel?>? _userSubscription;
  School? school;
  String userId;
  ProfileProvider(this.profileRepository, this.userId) {
    initialize();
  }

  void initialize() async {
    try {
      _subscribeToUserData();
    } catch (e) {
      debugPrint("ProfileProvider initialize error: $e");
    }
    notifyListeners();
  }

  String extractCaps(String text) {
    final matches = RegExp(r'(^[A-Za-z])|-(\s*[A-Za-z])').allMatches(text);

    // Extract the actual letters, remove '-', trim spaces
    final letters = matches.map((m) {
      return (m.group(1) ?? m.group(2))!
          .replaceAll('-', '')
          .trim()
          .toUpperCase();
    }).join();

    return letters;
  }

  void _subscribeToUserData() async {
    try {
      isLoading = true;

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      classes = await profileRepository.getClass();
      _userSubscription?.cancel();
      _userSubscription = profileRepository
          .getUserDataStream(userId)
          .listen(
            (userData) async {
              try {
                if (userData == null) return;

                user = userData;

                school = await profileRepository.getSchoolData(
                  user?.schoolId ?? 0,
                );
                nameFromUser = extractCaps(user?.username ?? '');

                email.text = user?.email ?? "";
                isLoading = false;

                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => notifyListeners(),
                );
              } catch (e) {
                debugPrint("User stream inner error: $e");
              }
            },
            onError: (error) {
              debugPrint('User stream error: $error');
              isLoading = false;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => notifyListeners(),
              );
            },
          );
      results = await profileRepository.getResults(userId);
    } catch (e) {
      debugPrint("ProfileProvider subscribe error: $e");
    }
    notifyListeners();
  }

  Future<void> logoutUser() async {
    showDialog(
      context: ctx!,
      builder: (_) => AlertDialog.adaptive(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => {Navigator.pop(ctx!)},
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Logout"),
            onPressed: () {
              Navigator.pop(ctx!);
              logout();
            },
          ),
        ],
      ),
    );
  }

  void logout() async {
    GlobalLoader.show();
    await Supabase.instance.client.auth.signOut();
    GlobalLoader.hide();
    NavigationHelper.go(RouteNames.login);
  }

  @override
  void dispose() {
    try {
      _userSubscription?.cancel();
      email.dispose();
      super.dispose();
    } catch (e) {
      debugPrint("ProfileProvider dispose error: $e");
    }
  }

  void goToDesktopApp(BuildContext context) async {
    commonViewModel = context.read<CommonViewModel>();
    UserModel model = await commonViewModel?.getCode(user?.username ?? '');
    String email = model.username ?? '';
    String code = model.activationCode ?? "";
    final url = 'https://app.yoyospeak.com/autoLink?email=$email&code=$code';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

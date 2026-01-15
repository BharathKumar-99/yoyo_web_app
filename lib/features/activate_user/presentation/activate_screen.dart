import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/features/add_teacher/data/add_teacher_repo.dart';

class ActivateScreen extends StatefulWidget {
  const ActivateScreen({super.key});

  @override
  State<ActivateScreen> createState() => _ActivateScreenState();
}

class _ActivateScreenState extends State<ActivateScreen> {
  String message = "Activating your account...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _activate();
  }

  Future<void> _activate() async {
    try {
      final uid = Uri.base.queryParameters["uid"];

      if (uid == null || uid.isEmpty) {
        setState(() {
          message = "Invalid activation link.";
          isLoading = false;
        });
        return;
      }

      message = await AddTeacherRepo().activateTeacher(uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        message = "Something went wrong: $e";
        isLoading = false;
      });
    }
    Future.delayed(Duration(seconds: 2), () async {
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (_) {}
      context.go(RouteNames.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  CircularProgressIndicator(),
                  Text('Redirecting'),
                ],
              ),
      ),
    );
  }
}

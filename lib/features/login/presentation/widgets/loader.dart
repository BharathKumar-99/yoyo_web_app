import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';

class WebStyleLoader extends StatelessWidget {
  const WebStyleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9D5DE6), Color(0xFFF78C59)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 420,
            height: 420,
            child: Lottie.asset(
              AnimationConstants.loaderAnimation,
              repeat: true,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),
          Image.asset(IconConstants.loader),
        ],
      ),
    );
  }
}

class YoyoWaiting extends StatefulWidget {
  const YoyoWaiting({super.key});

  @override
  State<YoyoWaiting> createState() => _YoyoWaitingState();
}

class _YoyoWaitingState extends State<YoyoWaiting> {
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;

      setState(() {
        _dotCount = (_dotCount % 3) + 1;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Color(0xFF9D5DE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Lottie.asset(
              AnimationConstants.loaderAnimation,
              repeat: true,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Building${'.' * _dotCount}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

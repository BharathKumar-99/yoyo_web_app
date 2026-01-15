import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';

class LoaderWithoutBg extends StatefulWidget {
  const LoaderWithoutBg({super.key});

  @override
  State<LoaderWithoutBg> createState() => _LoaderWithoutBgState();
}

class _LoaderWithoutBgState extends State<LoaderWithoutBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, // 135deg
          end: Alignment.bottomRight,
          colors: [Color(0xFF9D5DE6), Color(0xFFF78C59)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// LOGO
          Image.asset(
            IconConstants.logopre, // same as HTML
            width: 512,
            height: 512,
          ),

          const SizedBox(height: 20),

          /// SPINNER
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: const _Spinner(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WebStyleLoader extends StatefulWidget {
  const WebStyleLoader({super.key});

  @override
  State<WebStyleLoader> createState() => _WebStyleLoaderState();
}

class _WebStyleLoaderState extends State<WebStyleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, // 135deg
            end: Alignment.bottomRight,
            colors: [Color(0xFF9D5DE6), Color(0xFFF78C59)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// LOGO
            Image.asset(
              IconConstants.logopre, // same as HTML
              width: 512,
              height: 512,
            ),

            const SizedBox(height: 20),

            /// SPINNER
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: const _Spinner(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(painter: _SpinnerPainter()),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = const Color(0xFFF3F3F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final topPaint = Paint()
      ..color = const Color(0xFF9D5DE6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    canvas.drawCircle(
      Offset(radius, radius),
      radius - strokeWidth / 2,
      basePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -pi / 2,
      pi / 2,
      false,
      topPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

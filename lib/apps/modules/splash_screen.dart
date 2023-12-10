import 'package:afs_test/utils/navigators.dart';
import 'package:flutter/material.dart';
import 'package:afs_test/utils/assets_paths.dart';
import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/apps/modules/auth/screens/sign_up_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ),
    );

    _animationController?.forward();

    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        pushTo(const SignUpScreen());
      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation!,
          builder: (context, child) {
            final clampedOpacity =
                math.max(0.0, math.min(1.0, _animation!.value + 0.2));
            return Transform.scale(
              scale: _animation!.value * 1.2 + 0.8,
              child: Transform.rotate(
                angle: _animation!.value * 2 * math.pi,
                child: Opacity(
                  opacity: clampedOpacity,
                  child: Image.asset(AssetPaths.splashImage),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

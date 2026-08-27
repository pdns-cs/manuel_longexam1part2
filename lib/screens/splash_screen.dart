import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/user_service.dart';
import '../widgets/loop_brand.dart';

/// First screen shown on launch. Decides whether the user goes to the home
/// screen (token persisted in shared_preferences) or to login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    final loggedIn = await _userService.isLoggedIn();
    if (!mounted) return;
    // Replace the whole stack so the splash never remains behind Home/Login
    // (prevents "back" from returning to splash/login).
    Navigator.pushNamedAndRemoveUntil(
      context,
      loggedIn ? '/home' : '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LOOP_BG,
      body: Center(
        child: FadeTransition(
          opacity: _controller,
          child: ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoopLogo(size: 64),
                const SizedBox(height: 14),
                Text(
                  'Stay in the loop.',
                  style: TextStyle(color: LOOP_MUTED, fontSize: 14),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(LOOP_ACCENT),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

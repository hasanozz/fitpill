import 'package:fitpill/features/auth/pages/login_page.dart';
import 'package:fitpill/features/auth/pages/register_page.dart';
import 'package:flutter/material.dart';

import 'package:fitpill/generated/l10n/l10n.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.cyan.shade700,
              Colors.tealAccent.shade400,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.15,
              left: -50,
              child: _buildAnimatedCircle(150, 2000),
            ),
            Positioned(
              bottom: size.height * 0.2,
              right: -30,
              child: _buildAnimatedCircle(100, 2200),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppLogo(),
                  const SizedBox(height: 20),
                  _buildHeader(context),
                  const SizedBox(height: 30),
                  _buildHeroImage(),
                  const SizedBox(height: 50),
                  _buildButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle(double size, int duration) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(255, 255, 255, 0.15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/pill.png',
          width: 60,
          height: 60,
        ),
        const Text(
          "Fitpill",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context)!.healthyLifeJourney,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            S.of(context)!.personalizedTraining,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(255, 255, 255, 0.9),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onboarding.jpg'),
          fit: BoxFit.contain,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        _buildAuthButton(
          text: S.of(context)!.startFree,
          icon: Icons.rocket_launch,
          color: Colors.cyan.shade300,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegisterPage())),
        ),
        const SizedBox(height: 20),
        _buildAuthButton(
          text: S.of(context)!.alreadyMember,
          icon: Icons.login,
          color: Colors.white,
          textColor: Colors.blue.shade900,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage())),
        ),
      ],
    );
  }

  Widget _buildAuthButton({
    required String text,
    required IconData icon,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 280,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 1.1,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.3),
        ),
      ),
    );
  }
}

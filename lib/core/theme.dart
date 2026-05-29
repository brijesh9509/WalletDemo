import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color backgroundMid = Color(0xFF161616);
  static const Color surfaceCard = Color(0xFF1F1F1F);
  static const Color surfaceCardBorder = Color(0xFF2B2B2B);

  // Brand
  static const Color walletYellow = Color(0xFFFFBF00);
  static const Color walletYellowDark = Color(0xFFC68B00);
  static const Color walletGreen = Color(0xFF2D6A2D);
  static const Color ctaGreen = Color(0xFF3C8C3C);
  static const Color ctaGreenLight = Color(0xFF4CAF50);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0XFFD7D3BB);
  static const Color textMuted = Color(0xFF706848);

  // Dots texture
  static const Color dotsColor = Color(0xFF8B7A30);

  // Confetti colors
  static const List<Color> confettiColors = [
    Color(0xFFFF4444),
    Color(0xFF4444FF),
    Color(0xFF44FF44),
    Color(0xFFFFFF44),
    Color(0xFFFF44FF),
    Color(0xFF44FFFF),
    Color(0xFFFF8844),
    Color(0xFF8844FF),
  ];
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle brandName = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle moneyTitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 38,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 6,
    height: 1.0,
  );

  static const TextStyle txtTitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle txtSubtitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle ctaButton = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle bottomSlogan = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: Color(0xFF3A3520),
    letterSpacing: 1,
    height: 1.3,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.walletYellow,
          surface: AppColors.backgroundMid,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2D6A4F);
  static const Color accent = Color(0xFFD4E157);
  static const Color background = Color(0xFFF4F6F4);
  static const Color cardBorder = Color(0xFFEEF2EE);
  static const Color white = Colors.white;

  // Service type colors
  static const Color privateLesson = Color(0xFF7C3AED);
  static const Color groupLesson = Color(0xFF059669);
  static const Color communityEvent = Color(0xFFD97706);
  static const Color virtualSession = Color(0xFF2563EB);

  // Status colors
  static const Color statusPending = Color(0xFFD97706);
  static const Color statusConfirmed = Color(0xFF059669);
  static const Color statusCancelled = Color(0xFFDC2626);
  static const Color statusCompleted = Color(0xFF6B7280);

  static Color serviceColor(String type) {
    switch (type) {
      case 'private_lesson':
        return privateLesson;
      case 'group_lesson':
        return groupLesson;
      case 'community_event':
        return communityEvent;
      case 'virtual_session':
        return virtualSession;
      default:
        return primary;
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case 'pending':
        return statusPending;
      case 'confirmed':
        return statusConfirmed;
      case 'cancelled':
        return statusCancelled;
      case 'completed':
        return statusCompleted;
      default:
        return statusPending;
    }
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.statusCancelled),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        selectedColor: AppColors.primary.withOpacity(0.15),
        labelStyle: GoogleFonts.poppins(fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
    );
  }
}

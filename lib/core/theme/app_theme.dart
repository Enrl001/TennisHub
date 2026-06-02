import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2D6A4F);
  static const Color tennisGreen = Color(0xFFCCE226);
  static const Color accent = Color(0xFFCCE226);
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFF0F0F0);
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

/// Shared layout tokens used by Coach Hub and customer booking flows.
class HubStyle {
  HubStyle._();

  static const Color pageBg = Color(0xFFF5F6F8);
  static const Color hubOlive = Color(0xFF526300);
  static const Color cardBorder = Color(0xFFE4E6DC);
  static const Color darkPanel = Color(0xFF252B2B);
  static const Color textPrimary = Color(0xFF181A20);
  static const Color textMuted = Color(0xFF6B7280);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.tennisGreen,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
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
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
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
          borderSide:
              const BorderSide(color: AppColors.tennisGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.statusCancelled),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tennisGreen,
          foregroundColor: const Color(0xFF1A3A10),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.tennisGreen,
        foregroundColor: Color(0xFF1A3A10),
        elevation: 2,
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
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppColors.tennisGreen.withOpacity(0.25),
        labelStyle: GoogleFonts.poppins(fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
    );
  }
}

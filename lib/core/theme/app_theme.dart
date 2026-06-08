import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stitch design system — Coach Hub / MyClub.
class AppColors {
  AppColors._();

  /// Brand olive (Stitch primary).
  static const Color primary = Color(0xFF526300);
  static const Color tennisGreen = Color(0xFFCCE226);
  static const Color accent = Color(0xFFCCE226);
  static const Color background = Color(0xFFF5F6F8);
  static const Color cardBorder = Color(0xFFE4E6DC);
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

/// Shared layout tokens — Stitch project 2470079703981227643.
class HubStyle {
  HubStyle._();

  static const Color pageBg = Color(0xFFF5F6F8);
  static const Color hubOlive = Color(0xFF526300);
  static const Color hubOliveDark = Color(0xFF4B5F00);
  static const Color accentLime = Color(0xFFCCE226);
  static const Color cardBorder = Color(0xFFE4E6DC);
  static const Color cardBg = Colors.white;
  static const Color darkPanel = Color(0xFF252B2B);
  static const Color textPrimary = Color(0xFF181A20);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color slateMuted = Color(0xFF53657E);

  static const double radiusSm = 8;
  static const double radiusMd = 12;

  static const TextStyle brandTitle = TextStyle(
    color: hubOlive,
    fontSize: 18,
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.2,
  );

  static const TextStyle sectionLabel = TextStyle(
    color: hubOliveDark,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.6,
  );

  static const TextStyle bodyMuted = TextStyle(
    color: textMuted,
    fontSize: 14,
    height: 1.45,
  );

  /// Calendar / schedule section eyebrow (matches hub section labels).
  static const TextStyle calendarEyebrow = TextStyle(
    color: textMuted,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.6,
  );

  static const TextStyle calendarHeadline = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static const TextStyle calendarPill = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle timelineTitle = TextStyle(
    color: textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle timelineMeta = TextStyle(
    color: hubOlive,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle timelineBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme);

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: HubStyle.hubOlive,
        primary: HubStyle.hubOlive,
        secondary: HubStyle.accentLime,
        surface: HubStyle.cardBg,
      ),
      scaffoldBackgroundColor: HubStyle.pageBg,
      textTheme: textTheme.apply(
        bodyColor: HubStyle.textPrimary,
        displayColor: HubStyle.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: HubStyle.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: HubStyle.brandTitle.copyWith(fontSize: 17),
        iconTheme: const IconThemeData(color: HubStyle.hubOlive),
      ),
      cardTheme: CardThemeData(
        color: HubStyle.cardBg,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          side: const BorderSide(color: HubStyle.cardBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HubStyle.cardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          borderSide: const BorderSide(color: HubStyle.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          borderSide: const BorderSide(color: HubStyle.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          borderSide: const BorderSide(color: HubStyle.hubOlive, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          borderSide: const BorderSide(color: AppColors.statusCancelled),
        ),
        labelStyle: const TextStyle(color: HubStyle.textMuted),
        hintStyle: const TextStyle(color: HubStyle.textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HubStyle.hubOlive,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: HubStyle.hubOlive,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: HubStyle.hubOlive,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: HubStyle.hubOlive,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: HubStyle.hubOlive),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: HubStyle.cardBg,
        selectedItemColor: HubStyle.hubOlive,
        unselectedItemColor: HubStyle.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      dividerTheme: const DividerThemeData(
        color: HubStyle.cardBorder,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: HubStyle.cardBg,
        selectedColor: HubStyle.hubOlive.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.poppins(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HubStyle.radiusMd),
        ),
        side: const BorderSide(color: HubStyle.cardBorder),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: HubStyle.hubOlive,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HubStyle.radiusSm),
        ),
      ),
    );
  }
}

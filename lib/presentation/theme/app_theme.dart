import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
class AppTheme {
  AppTheme._();

  // Design System Colors - Dark Competition Theme
  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color accentOrange = Color(0xFFFF8533);
  static const Color deepCharcoal = Color(0xFF1A1A1A);
  static const Color elevatedSurface = Color(0xFF2D2D2D);
  static const Color pureBlack = Color(0xFF000000);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color successGreen = Color(0xFF00C851);
  static const Color warningOrange = Color(0xFFFFB347);
  static const Color errorRed = Color(0xFFFF4444);
  static const Color borderGray = Color(0xFF333333);

  // Shadow and overlay colors
  static const Color shadowColor = Color(0x33000000); // 20% opacity
  static const Color overlayColor = Color(0x80000000); // 50% opacity

  /// Dark theme (primary theme for video platform)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryOrange,
      onPrimary: pureBlack,
      primaryContainer: accentOrange,
      onPrimaryContainer: pureBlack,
      secondary: deepCharcoal,
      onSecondary: textPrimary,
      secondaryContainer: elevatedSurface,
      onSecondaryContainer: textPrimary,
      tertiary: accentOrange,
      onTertiary: pureBlack,
      tertiaryContainer: warningOrange,
      onTertiaryContainer: pureBlack,
      error: errorRed,
      onError: textPrimary,
      surface: elevatedSurface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderGray,
      outlineVariant: borderGray,
      shadow: shadowColor,
      scrim: overlayColor,
      inverseSurface: textPrimary,
      onInverseSurface: pureBlack,
      inversePrimary: primaryOrange,
    ),
    scaffoldBackgroundColor: pureBlack,
    cardColor: elevatedSurface,
    dividerColor: borderGray,

    // AppBar Theme - Transparent for video content
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary, size: 24),
    ),

    // Card Theme - Elevated surfaces
    // cardTheme: CardTheme(
    //   color: elevatedSurface,
    //   elevation: 2.0,
    //   shadowColor: shadowColor,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    //   margin: const EdgeInsets.all(8.0),
    // ),

    // Bottom Navigation - Competition focused
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: deepCharcoal,
      selectedItemColor: primaryOrange,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button - Contextual actions
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
      foregroundColor: pureBlack,
      elevation: 6.0,
      focusElevation: 8.0,
      hoverElevation: 8.0,
      highlightElevation: 12.0,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: pureBlack,
        backgroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: primaryOrange, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    // Text Theme - Inter font family
    textTheme: _buildTextTheme(),

    // Input Decoration - Clean forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: elevatedSurface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderGray, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderGray, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryOrange, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Interactive Elements
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange.withAlpha(77);
        }
        return borderGray;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(pureBlack),
      side: const BorderSide(color: borderGray, width: 1.5),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return borderGray;
      }),
    ),

    // Progress Indicators
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryOrange,
      linearTrackColor: borderGray,
      circularTrackColor: borderGray,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryOrange,
      thumbColor: primaryOrange,
      overlayColor: primaryOrange.withAlpha(51),
      inactiveTrackColor: borderGray,
      trackHeight: 4.0,
    ),

    // Tab Bar Theme
    // tabBarTheme: TabBarTheme(
    //   labelColor: primaryOrange,
    //   unselectedLabelColor: textSecondary,
    //   indicatorColor: primaryOrange,
    //   indicatorSize: TabBarIndicatorSize.tab,
    //   labelStyle: GoogleFonts.inter(
    //     fontSize: 14,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   unselectedLabelStyle: GoogleFonts.inter(
    //     fontSize: 14,
    //     fontWeight: FontWeight.w400,
    //   ),
    // ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: elevatedSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: elevatedSurface,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryOrange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 6.0,
    ),

    // Dialog Theme
    // dialogTheme: DialogTheme(
    //   backgroundColor: elevatedSurface,
    //   elevation: 8.0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12.0),
    //   ),
    //   titleTextStyle: GoogleFonts.inter(
    //     color: textPrimary,
    //     fontSize: 18,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   contentTextStyle: GoogleFonts.inter(
    //     color: textPrimary,
    //     fontSize: 14,
    //     fontWeight: FontWeight.w400,
    //   ),
    // ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: elevatedSurface,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    ),
  );

  /// Light theme (secondary theme for accessibility)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryOrange,
      onPrimary: textPrimary,
      primaryContainer: accentOrange,
      onPrimaryContainer: pureBlack,
      secondary: const Color(0xFFF5F5F5),
      onSecondary: pureBlack,
      secondaryContainer: const Color(0xFFE0E0E0),
      onSecondaryContainer: pureBlack,
      tertiary: accentOrange,
      onTertiary: textPrimary,
      tertiaryContainer: warningOrange,
      onTertiaryContainer: pureBlack,
      error: errorRed,
      onError: textPrimary,
      surface: textPrimary,
      onSurface: pureBlack,
      onSurfaceVariant: const Color(0xFF666666),
      outline: const Color(0xFFCCCCCC),
      outlineVariant: const Color(0xFFE0E0E0),
      shadow: const Color(0x1A000000),
      scrim: const Color(0x80000000),
      inverseSurface: pureBlack,
      onInverseSurface: textPrimary,
      inversePrimary: primaryOrange,
    ),
    scaffoldBackgroundColor: textPrimary,
    cardColor: const Color(0xFFF8F8F8),
    dividerColor: const Color(0xFFE0E0E0),
    textTheme: _buildTextTheme(isLight: true),
    dialogTheme: DialogThemeData(backgroundColor: textPrimary),
  );

  /// Helper method to build text theme using Inter font
  static TextTheme _buildTextTheme({bool isLight = false}) {
    final Color textColor = isLight ? pureBlack : textPrimary;
    final Color secondaryTextColor = isLight
        ? const Color(0xFF666666)
        : textSecondary;

    return TextTheme(
      // Display styles - Large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      // Headline styles - Section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      // Title styles - Card titles, dialog titles
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),

      // Body styles - Main content text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0.4,
      ),

      // Label styles - Buttons, captions, data
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );
  }
}

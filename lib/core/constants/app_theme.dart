import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Paleta Premium Dark
  static const Color background = Color(0xFF121212); // Preto quase absoluto
  static const Color cardSurface = Color(0xFF1E1E1E); // Cinza escuro para cards
  static const Color primaryGold = Color(0xFFD4AF37); // Dourado Metálico
  static const Color textWhite = Color(0xFFEDEDED);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color successGreen = Color(0xFF4CAF50);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryGold,

      // Configuração de Texto Global
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
            color: AppColors.primaryGold, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.roboto(color: AppColors.textWhite),
        bodyMedium: GoogleFonts.roboto(color: AppColors.textGrey),
      ),

      // Estilo dos Cards (Sem const aqui!)
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Estilo da AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textWhite),
      ),
      
      // Esquema de cores para componentes padrão
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber, // Fallback
      ).copyWith(
        primary: AppColors.primaryGold,
        secondary: AppColors.primaryGold,
        surface: AppColors.cardSurface,
      ),
    );
  }
}
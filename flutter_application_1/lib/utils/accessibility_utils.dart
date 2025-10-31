import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  // Mostrar snackbar accesible
  static void showAccessibleSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          liveRegion: true,
          child: Text(message, style: const TextStyle(fontSize: 16)),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // Announce for accessibility services (screen readers)
    try {
      SemanticsService.announce(message, Directionality.of(context));
    } catch (_) {
      // Si falle la llamada (por ejemplo en tests), ignore.
    }
  }

  // Realizar un anuncio explícito para servicios de accesibilidad.
  static void announce(BuildContext context, String message) {
    try {
      SemanticsService.announce(message, Directionality.of(context));
    } catch (_) {
      // En entornos donde SemanticsService no esté disponible, no hacer nada.
    }
  }

  // Verificar contraste de colores
  static double calculateLuminance(Color color) {
    return (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  }

  static bool hasSufficientContrast(Color background, Color foreground) {
    final backgroundLum = calculateLuminance(background) + 0.05;
    final foregroundLum = calculateLuminance(foreground) + 0.05;
    final contrastRatio =
        backgroundLum > foregroundLum
            ? backgroundLum / foregroundLum
            : foregroundLum / backgroundLum;
    return contrastRatio >= 4.5; // Estándar WCAG AA
  }

  // Generar descripciones semánticas
  static String generateImageDescription(String imageName) {
    final descriptions = {
      'profile': 'Foto de perfil del usuario',
      'logo': 'Logo de la aplicación',
      'settings': 'Icono de configuración',
      'home': 'Icono de inicio',
    };
    return descriptions[imageName] ?? 'Imagen $imageName';
  }
}

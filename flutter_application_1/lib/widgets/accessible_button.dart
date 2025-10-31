import 'package:flutter/material.dart';
import '../utils/accessibility_utils.dart';

class AccessibleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double? width;
  final String? announcement;
  final bool announceOnPress;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.width,
    this.announcement,
    this.announceOnPress = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ajustar contraste: si la combinación solicitada no cumple WCAG AA,
    // forzar un color de texto legible (blanco) para fondo oscuro.
    final Color effectiveTextColor =
        AccessibilityUtils.hasSufficientContrast(backgroundColor, textColor)
            ? textColor
            : Colors.white;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: text,
      child: Container(
        width: width,
        constraints: const BoxConstraints(
          minHeight: 44, // Altura mínima para accesibilidad táctil
        ),
        child: ElevatedButton(
          onPressed:
              onPressed == null
                  ? null
                  : () {
                    // Ejecutar la acción original
                    onPressed!();
                    // Anunciar si se requiere feedback auditivo
                    if (announceOnPress && announcement != null) {
                      AccessibilityUtils.announce(
                        // Usar contexto actual para dirección de texto
                        context,
                        announcement!,
                      );
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: effectiveTextColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 2),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

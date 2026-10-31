import 'package:flutter/material.dart';

/// Background bergradasi + lingkaran dekoratif, mengikuti warna tema.
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primaryContainer.withOpacity(0.55),
                  cs.surface,
                  cs.secondaryContainer.withOpacity(0.45),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -70,
          right: -50,
          child: _lingkaran(cs.primary.withOpacity(0.10), 220),
        ),
        Positioned(
          bottom: -90,
          left: -60,
          child: _lingkaran(cs.tertiary.withOpacity(0.10), 260),
        ),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _lingkaran(Color warna, double ukuran) => Container(
        width: ukuran,
        height: ukuran,
        decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
      );
}

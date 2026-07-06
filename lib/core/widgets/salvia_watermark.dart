import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class SalviaWatermark extends StatelessWidget {
  const SalviaWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Opacity(
          opacity: 0.22,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SalarSalvia',
                style: GoogleFonts.dancingScript(
                  fontSize: 48,
                  color: AppColors.spaceIndigo,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'a genius from neverland 👅',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.plasmaPin,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

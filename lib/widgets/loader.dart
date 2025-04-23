import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoaderWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final bool barrierDismissible;

  const LoaderWidget({
    super.key,
    this.message,
    this.color,
    this.barrierDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: barrierDismissible,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: color ?? Colors.black,
                  strokeWidth: 3,
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
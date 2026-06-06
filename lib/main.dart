import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // Preload all our bundled fonts synchronously before running the app to prevent layout shifts (FOUT)
  await GoogleFonts.pendingFonts([
    GoogleFonts.inter(fontWeight: FontWeight.normal), // w400
    GoogleFonts.inter(fontWeight: FontWeight.w500),
    GoogleFonts.inter(fontWeight: FontWeight.w600),
    GoogleFonts.inter(fontWeight: FontWeight.bold),   // w700
    GoogleFonts.libreCaslonText(fontWeight: FontWeight.normal), // w400
    GoogleFonts.libreCaslonText(fontWeight: FontWeight.bold),   // w700
  ]);

  runApp(const ChronicleApp());
}

class ChronicleApp extends StatelessWidget {
  const ChronicleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chronicle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: appRouter,
      builder: (context, child) {
        // On web, constrain to mobile phone dimensions
        if (kIsWeb) {
          return _MobileOnlyWrapper(child: child!);
        }
        return child!;
      },
    );
  }
}

/// Wraps the app in a phone-sized container on web desktop browsers.
/// On actual mobile browsers the app fills the screen naturally.
class _MobileOnlyWrapper extends StatelessWidget {
  const _MobileOnlyWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If viewport is wider than a phone, center in a phone frame
        if (constraints.maxWidth > 480) {
          return Center(
            child: Container(
              width: 430,
              height: 932,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF504532), width: 1),
                borderRadius: BorderRadius.circular(0),
              ),
              child: ClipRect(child: child),
            ),
          );
        }
        // On actual mobile viewport, fill the screen
        return child;
      },
    );
  }
}

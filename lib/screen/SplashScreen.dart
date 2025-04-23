import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/providers/profile_provider.dart';
import 'package:iostest/screen/main/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:iostest/providers/config_provider.dart';
import 'package:iostest/screen/LoginScreen.dart';
import 'dart:async';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Navigate to LoginScreen after a delay
//     Timer(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacementNamed('/login');
//     });

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'JustPe',
//               style: GoogleFonts.urbanist(
//                 color: Colors.white,
//                 fontSize: 45,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Payments',
//               style: GoogleFonts.urbanist(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Loading ...',
//               style: GoogleFonts.urbanist(
//                 color: Colors.redAccent,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 








class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

 
  Future<void> _initializeApp() async {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        
        var token=SecureStorageService.getToken();
                final hasToken=token!="";
              
print(hasToken);
print("------has token----");
    // First try to load from local storage
  // Load config
    bool hasConfig = await configProvider.loadStoredConfig();
    if (!hasConfig) {
      hasConfig = await configProvider.fetchConfig();
      if (!hasConfig && mounted) {
        _showError(configProvider.error);
        return;
      }
    }


if (hasToken) {
      final profileSuccess = await profileProvider.fetchProfile();
      print("------profile fetch----");
      print(profileSuccess);
      if (profileSuccess) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
        return;
      }
    }
    
    // If no stored config, fetch from network
    bool success = await configProvider.fetchConfig();
    if (mounted) {
      if (success) {
        _navigateToLogin();
      } else {
       _showError("Error fetching config");
      }
    }
  }




  void _showError(String? error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Failed to load configuration'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _initializeApp,
        ),
      ),
    );
  }

   void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {




        return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JustPe',
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Payments',
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading ...',
              style: GoogleFonts.urbanist(
                color: Colors.redAccent,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
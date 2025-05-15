import 'package:flutter/material.dart';
import 'package:iostest/providers/GoldPriceProvider.dart';
import 'package:iostest/providers/PaymentNotifier.dart';
import 'package:iostest/providers/bill_notifier.dart';
import 'package:iostest/providers/config_provider.dart';
import 'package:iostest/providers/gold_profile_provider.dart';
import 'package:iostest/providers/hotel_city_provider.dart';
import 'package:iostest/providers/hotels_list_provider.dart';
import 'package:iostest/providers/otp_provider.dart';
import 'package:iostest/providers/payment_status_notifier.dart';
import 'package:iostest/providers/profile_provider.dart';
import 'package:iostest/screen/SplashScreen.dart';
import 'package:iostest/screen/LoginScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iostest/screen/OTPScreen.dart';
import 'package:iostest/screen/bill/ViewBillScreen.dart';
import 'package:iostest/screen/main/HomePage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(create: (_) => OtpNotifier()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BillNotifier()),
        ChangeNotifierProvider(create: (_) => PaymentNotifier()),
        ChangeNotifierProvider(create: (_) => PaymentStatusNotifier()),
        ChangeNotifierProvider(create: (_) => GoldProfileProvider()),
        ChangeNotifierProvider(create: (_) => GoldPriceProvider()),
        ChangeNotifierProvider(create: (_) => HotelCityProvider()),
        ChangeNotifierProvider(create: (_) => HotelsListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustPe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/view-bill':
            (context) => const ViewBillScreen(
              consumerNumber: '',
              operatorName: 'Default Operator',
              number: '',
              operatorId: '12345',
              selectedCircleId: '',
              category: 'Electricity',
              billData: {
                'billAmount': 0.0,
                'userName': 'Guest',
                'dueDate': 'N/A',
              },
            ),
        '/home': (context) => HomePage(),
        '/otp': (context) => OTPScreen(phoneNumber: '+91 8886389900'),
      },
    );
  }
}

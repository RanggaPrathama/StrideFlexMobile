import 'package:flutter/material.dart';
import 'package:strideflex_application_1/core.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stride Flex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      //home: const SplashScreen(),
      initialRoute: Login.routeName,
      routes: routers,
    );
  }
}

// ThemeData(
//         fontFamily: 'Poppins',
//         appBarTheme: AppBarTheme(
//             backgroundColor: Colors.white,
//             surfaceTintColor:
//                 Colors.transparent // Atur warna latar belakang app bar di sini
//             ),
//         useMaterial3: true,
//       )

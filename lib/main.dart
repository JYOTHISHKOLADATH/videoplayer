import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Pages/home.dart';
import 'Pages/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  @override
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
        builder: (_,mode,__) {
          return MaterialApp(
          debugShowCheckedModeBanner: false,
            themeMode: mode,
            theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
            // ThemeData(
            //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            //   useMaterial3: true,
            // ),
            home: const Login(),
          );
        },
    );
  }
}

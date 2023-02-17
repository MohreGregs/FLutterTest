import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertest/database/database.dart';
import 'package:fluttertest/widgets/adminWidget.dart';
import 'package:fluttertest/widgets/diagramWidget.dart';
import 'package:fluttertest/widgets/insertDataWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.openAppDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context){
        return AppLocalizations.of(context)!.appTitle;
      },
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', '')
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const InsertDataPage(),
        '/data': (context) => const DiagramPage(),
        '/admin': (context) => const AdminWidget(),
      },
    );
  }
}

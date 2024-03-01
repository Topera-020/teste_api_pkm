import 'package:flutter/material.dart';
import 'package:pokelens/pages/card_page.dart';
import 'package:pokelens/pages/collections_page.dart';
import 'package:pokelens/pages/loading_page.dart';
import 'package:pokelens/pages/settings_page.dart';
import 'package:pokelens/pages/test_page.dart';

//import 'package:pokelens/pages/test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéLens',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 6, 131, 130), // Defina a cor principal desejada
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 6, 131, 130), // Defina a cor de fundo da AppBar
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // Defina a cor dos ícones na AppBar
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const CollectionsPage(),
        '/loading': (_) => const LoadingPage(),
        '/cardsPage': (context) => const CardPage(collection: null),
        '/collectionsPage': (context) => const CollectionsPage(),
        '/settings': (context) => const SettingsPage(),
        '/test': (_) => const TestPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:pokelens/pages/home_page.dart';
import 'package:pokelens/pages/card_page.dart';
import 'package:pokelens/data/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.instance.database;

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Teste API',
      theme: ThemeData(
        primaryColor: Colors.red[700], // Defina a cor principal desejada
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[700], // Defina a cor de fundo da AppBar
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Defina a cor dos ícones na AppBar
          ),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/cardsPage': (context) => const CardPage(collection: null,),
      },
    );
  }
}

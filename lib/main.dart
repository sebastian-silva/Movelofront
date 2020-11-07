import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_final/pages/login_page.dart';
import 'package:proyecto_final/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movelo',
      
      initialRoute: 'home',
      routes: getApplicationRoutes(),

      onGenerateRoute: (RouteSettings settings) {
        // print('ruta llamada ${settings.name} ');
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      },
    );
  }
}
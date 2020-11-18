import 'package:flutter/material.dart';
import 'package:proyecto_final/pages/listaAlarmas.dart';
import 'package:proyecto_final/pages/login_page.dart';
import 'package:proyecto_final/pages/mapaAlarma.dart';
import 'package:proyecto_final/pages/menu.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'login': (BuildContext context) => LoginPage(),
    'menu': (BuildContext context) => Menu(),
    'lista': (BuildContext context) => ListaAlarmas(),
    'mapaalarma': (BuildContext context) => MapaAlarmaPage(),
  };
}
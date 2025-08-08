import 'package:app_gasto/screen/credito_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Gestión de Crédito',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CreditoMainPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'formulario_credito_page.dart';
import 'lista_pagos_page.dart';

class CreditoMainPage extends ConsumerStatefulWidget {
  const CreditoMainPage({super.key});

  @override
  ConsumerState<CreditoMainPage> createState() => _CreditoMainPageState();
}

class _CreditoMainPageState extends ConsumerState<CreditoMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    FormularioCreditoPage(),
    ListaPagosPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Registrar pago',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ver pagos',
          ),
        ],
      ),
    );
  }
}

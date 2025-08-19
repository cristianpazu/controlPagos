import 'package:app_gasto/screen/credito_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';

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
      home: CreditoMainPage(),
    );
  }
}

class MyShopPage extends StatefulWidget {
  @override
  _MyShopPageState createState() => _MyShopPageState();
}

class _MyShopPageState extends State<MyShopPage> {
  late Function(GlobalKey) runAddToCartAnimation;
  final GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [ ],
        ),
        body: SafeArea(
          child: AddToCartAnimation(
            cartKey: cartKey,
            height: 30,
            width: 30,
            opacity: 0.85,
            dragAnimation: const DragToCartAnimationOptions(
              rotation: true,
            ),
            createAddToCartAnimation: (addToCartAnimationMethod) {
              runAddToCartAnimation = addToCartAnimationMethod;
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      GlobalKey imageKey = GlobalKey();
                      return ListTile(
                        title: Text('Producto $index'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            runAddToCartAnimation(imageKey);
                          },
                          child: Container(
                            key: imageKey,
                            child: Text('Agregar Producto'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
AddToCartIcon(
                  key: cartKey,
                  icon: Icon(Icons.shopping_cart),
                  badgeOptions: BadgeOptions(
                    active: true,
                    backgroundColor: Colors.orange,
                  ),
                ),
                
              ],
            ),
          ),
        ));
  }
}

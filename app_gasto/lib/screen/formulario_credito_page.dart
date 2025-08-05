import 'package:app_gasto/notifiers/gasto_state_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormularioCreditoPage extends ConsumerStatefulWidget {
  const FormularioCreditoPage({super.key});

  @override
  ConsumerState<FormularioCreditoPage> createState() =>
      _FormularioCreditoPageState();
}

class _FormularioCreditoPageState extends ConsumerState<FormularioCreditoPage> {
  final precioCtrl = TextEditingController(text: '161000000');
  final anticipoCtrl = TextEditingController(text: '40000000');
  final tasaCtrl = TextEditingController(text: '1.5');
  final cuotaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gastoProvider);
    final notifier = ref.read(gastoProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Pago Crédito')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio total'),
            ),
            TextField(
              controller: anticipoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Anticipo'),
            ),
            TextField(
              controller: tasaCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tasa %'),
            ),
            TextField(
              controller: cuotaCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Cuota o abono a capital'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: state.isLoding
                  ? null
                  : () async {
                      await notifier.guardarPago(
                        precio: double.parse(precioCtrl.text),
                        anticipo: double.parse(anticipoCtrl.text),
                        tasaPct: double.parse(tasaCtrl.text),
                        abonoCapital: double.parse(cuotaCtrl.text),
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pago registrado')),
                        );
                        cuotaCtrl.clear();
                      }
                    },
              child: state.isLoding
                  ? const CircularProgressIndicator()
                  : const Text('Guardar Pago'),
            ),
          ],
        ),
      ),
    );
  }
}

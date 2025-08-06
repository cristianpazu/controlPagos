import 'package:app_gasto/notifiers/gasto_state_notifiers.dart';
import 'package:app_gasto/utils/formateoMonedas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 // ruta donde guardes la clase

class FormularioCreditoPage extends ConsumerStatefulWidget {
  const FormularioCreditoPage({super.key});

  @override
  ConsumerState<FormularioCreditoPage> createState() => _FormularioCreditoPageState();
}

class _FormularioCreditoPageState extends ConsumerState<FormularioCreditoPage> {
  final precioCtrl = TextEditingController(text: '');
  final anticipoCtrl = TextEditingController(text: '');
  final tasaCtrl = TextEditingController(text: '1.5');
  final abonoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gastoProvider.notifier).cargarGastos();
    });
  }

  double parseMoneda(String valor) {
    return double.tryParse(valor.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gastoProvider);
    final notifier = ref.read(gastoProvider.notifier);
    final esPrimerRegistro = state.registroGasto.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Pago Crédito')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (esPrimerRegistro) ...[
              TextField(
                controller: precioCtrl,
                keyboardType: TextInputType.number,
               inputFormatters: [
    CustomCurrencyFormatter(), // ✅ nuestro formateador limpio
  ],
                decoration: const InputDecoration(labelText: 'Precio total'),
              ),
              TextField(
                controller: anticipoCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CustomCurrencyFormatter(), // ✅ con formato
                ],
                decoration: const InputDecoration(labelText: 'Anticipo'),
              ),
              TextField(
                controller: tasaCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Tasa %'),
              ),
            ] else ...[
              TextField(
                controller: abonoCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CustomCurrencyFormatter(), // ✅ con formato
                ],
                decoration: const InputDecoration(labelText: 'Abono a capital'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: state.isLoding
                  ? null
                  : () async {
                      if (esPrimerRegistro) {
                        await notifier.guardarPago(
                          precio: parseMoneda(precioCtrl.text),
                          anticipo: parseMoneda(anticipoCtrl.text),
                          tasaPct: double.parse(tasaCtrl.text),
                          abonoCapital: 0,
                        );
                      } else {
                        await notifier.guardarPago(
                          precio: 0,
                          anticipo: 0,
                          tasaPct: double.parse(tasaCtrl.text),
                          abonoCapital: parseMoneda(abonoCtrl.text),
                        );
                      }

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pago registrado')),
                        );
                        abonoCtrl.clear();
                      }
                    },
              child: state.isLoding
                  ? const CircularProgressIndicator()
                  : Text(esPrimerRegistro ? 'Registrar crédito' : 'Registrar pago'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app_gasto/notifiers/gasto_state_notifiers.dart';
import 'package:app_gasto/utils/formateoMonedas.dart'; // CustomCurrencyFormatter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FormularioCreditoPage extends ConsumerStatefulWidget {
  const FormularioCreditoPage({super.key});

  @override
  ConsumerState<FormularioCreditoPage> createState() =>
      _FormularioCreditoPageState();
}

class _FormularioCreditoPageState extends ConsumerState<FormularioCreditoPage> {
  final precioCtrl = TextEditingController(text: '');
  final anticipoCtrl = TextEditingController(text: '');
  final tasaCtrl = TextEditingController(text: '1.5');
  final abonoCtrl = TextEditingController();

  // Solo lectura (preview del interés)
  final _interesROCtrl = TextEditingController();

  final _fmt = NumberFormat.currency(locale: 'es_CO', symbol: '\$');

  // Nota explicativa del interés mostrado
  String _interesNote = '';

  // ---------- Helpers ----------
  double _parseMoneda(String valor) =>
      double.tryParse(valor.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  bool _esMismoMes(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  void _updateInteresPreview() {
    final state = ref.read(gastoProvider);

    if (state.registroGasto.isEmpty) {
      // Aún no hay crédito registrado (periodo 0)
      _interesROCtrl.text = '';
      _interesNote = 'Se calculará después de registrar el crédito';
      setState(() {});
      return;
    }

    final ultimo = state.registroGasto.last;
    final ahora = DateTime.now();
    final mismoMes = (ultimo.fecha != null) && _esMismoMes(ahora, ultimo.fecha!);

    final saldoInicial = ultimo.saldoFinal;
    final tasaPct = double.tryParse(tasaCtrl.text.replaceAll(',', '.')) ?? 0.0;

    // Si es nuevo mes, siguiente periodo = ultimo.periodo + 1; si es mismo mes, se mantiene
    final siguientePeriodo = mismoMes ? ultimo.periodo : ultimo.periodo + 1;

    // Regla de interés
    double interes = 0.0;
    if (!mismoMes && siguientePeriodo >= 7) {
      interes = saldoInicial * (tasaPct / 100.0);
      _interesNote = 'Interés aplicado (mes ${siguientePeriodo} ≥ 7)';
    } else if (mismoMes) {
      _interesNote = 'Sin interés (abono adicional del mismo mes)';
    } else {
      _interesNote = 'Sin interés (meses 1–6)';
    }

    _interesROCtrl.text = _fmt.format(interes);
    setState(() {});
  }

  // ---------- Ciclo de vida ----------
  @override
  void initState() {
    super.initState();

    // Cargar lista inicial y luego calcular interés
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(gastoProvider.notifier).cargarGastos();
      _updateInteresPreview();
    });

    // Recalcular cuando cambie la tasa
    tasaCtrl.addListener(_updateInteresPreview);
  }

  @override
  void dispose() {
    precioCtrl.dispose();
    anticipoCtrl.dispose();
    tasaCtrl.dispose();
    abonoCtrl.dispose();
    _interesROCtrl.dispose();
    super.dispose();
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    // Escucha cambios del provider y recalcula el interés
    ref.listen(gastoProvider, (prev, next) {
      _updateInteresPreview();
    });

    final state = ref.watch(gastoProvider);
    final notifier = ref.read(gastoProvider.notifier);
    final esPrimerRegistro = state.registroGasto.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Pago Crédito')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo SIEMPRE visible: Interés del mes (auto)
              TextField(
                controller: _interesROCtrl,
                readOnly: true,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  labelText: 'Interés del mes (auto)',
                  helperText: _interesNote.isEmpty ? null : _interesNote,
                ),
              ),
              const SizedBox(height: 16),

              if (esPrimerRegistro) ...[
                TextField(
                  controller: precioCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CustomCurrencyFormatter()],
                  decoration: const InputDecoration(labelText: 'Precio total'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: anticipoCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CustomCurrencyFormatter()],
                  decoration: const InputDecoration(labelText: 'Anticipo'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tasaCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Tasa %'),
                ),
              ] else ...[
                const SizedBox(height: 4),
                TextField(
                  controller: abonoCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CustomCurrencyFormatter()],
                  decoration:
                      const InputDecoration(labelText: 'Abono a capital'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tasaCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Tasa %'),
                  onChanged: (_) => _updateInteresPreview(),
                ),
              ],

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: state.isLoding
                    ? null
                    : () async {
                        if (esPrimerRegistro) {
                          await notifier.guardarPago(
                            precio: _parseMoneda(precioCtrl.text),
                            anticipo: _parseMoneda(anticipoCtrl.text),
                            tasaPct: double.parse(
                                tasaCtrl.text.replaceAll(',', '.')),
                            abonoCapital: 0, // periodo 0 sin abono
                          );
                        } else {
                          await notifier.guardarPago(
                            precio: 0,
                            anticipo: 0,
                            tasaPct: double.parse(
                                tasaCtrl.text.replaceAll(',', '.')),
                            abonoCapital: _parseMoneda(abonoCtrl.text),
                          );
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pago registrado')),
                          );
                          abonoCtrl.clear();
                          _updateInteresPreview();
                        }
                      },
                child: state.isLoding
                    ? const CircularProgressIndicator()
                    : Text(
                        esPrimerRegistro ? 'Registrar crédito' : 'Registrar pago',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

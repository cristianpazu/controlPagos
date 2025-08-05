import 'package:app_gasto/notifiers/gasto_state_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ListaPagosPage extends ConsumerWidget {
  const ListaPagosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gastoProvider);
    final formatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Pagos registrados')),
      body: state.isLoding
          ? const Center(child: CircularProgressIndicator())
          : state.registroGasto.isEmpty
              ? const Center(child: Text('No hay pagos registrados'))
              : ListView.separated(
                  itemCount: state.registroGasto.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final pago = state.registroGasto[i];
                    return ListTile(
                      leading: Text('#${pago.periodo}'),
                      title: Text('Cuota: ${formatter.format(pago.cuota)}'),
                      subtitle: Text(
                        'Interés: ${formatter.format(pago.interes)} | '
                        'Amortización: ${formatter.format(pago.amortizacion)}\n'
                        'Saldo: ${formatter.format(pago.saldoInicial)} → ${formatter.format(pago.saldoFinal)}',
                      ),
                      trailing: Text(
                        DateFormat('dd/MM/yyyy').format(pago.fecha!),
                      ),
                    );
                  },
                ),
    );
  }
}

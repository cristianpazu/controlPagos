import 'package:app_gasto/notifiers/gasto_state.dart';
import 'package:app_gasto/provider/gasto_provider.dart';
import 'package:app_gasto/service/credito_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gastoProvider = StateNotifierProvider<GastoStateNotifiers, GastoState>((ref) {
  final serviceAsync = ref.watch(gastosServiceProvider);

  return serviceAsync.maybeWhen(
    data: (service) => GastoStateNotifiers(service),
    orElse: () => GastoStateNotifiers(null),
  );
});



class GastoStateNotifiers extends StateNotifier<GastoState> {
 final CreditoService? service;

  GastoStateNotifiers(this.service) : super(GastoState()) {
    if (service != null) {
      cargarGastos();
    }
  }

  /// Cargar todos los registros guardados
  Future<void> cargarGastos() async {
    if (service == null) return;
    state = state.copyWith(isLoding: true);

    try {
      final lista = await service!.repo.consultarTodosGasto();
      state = state.copyWith(isLoding: false, registroGasto: lista);
    } catch (e) {
      state = state.copyWith(isLoding: false);
    }
  }

  /// Guardar un nuevo pago del crédito
 Future<void> guardarPago({
  required double precio,
  required double anticipo,
  required double tasaPct,
  required double abonoCapital,
}) async {
  if (service == null) return;
  state = state.copyWith(isLoding: true);
  await service!.guardarSiguiente(
    precio: precio,
    anticipo: anticipo,
    tasaPct: tasaPct,
    abonoCapital: abonoCapital,
  );
  await cargarGastos(); // <-- Esto es lo que actualiza la lista
}

Future<void> limpiarTodo() async {
  if (service == null) return;
  state = state.copyWith(isLoding: true);

  await service!.repo.borrarTodos(); // Nuevo método en el repositorio
  await cargarGastos();
}



}
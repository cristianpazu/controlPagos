import 'package:app_gasto/doimain/repositories/gastosRepositories.dart';
import 'package:app_gasto/model/registroGasto.dart';

class CreditoService {
  final Gastosrepositories repo;
  CreditoService(this.repo);

  Future<Registrogasto> guardarSiguiente({
    required double precio,
    required double anticipo,
    required double tasaPct,
    required double abonoCapital,
  }) async {
    // Obtener el último registro
    final lista = await repo.consultarTodosGasto();
    final ultimo = lista.isNotEmpty ? lista.last : null;

    double saldoInicial;
    int periodo;

    if (ultimo == null) {
      // Primer periodo
      saldoInicial = precio - anticipo;
      if (saldoInicial <= 0) throw Exception('Anticipo >= precio.');
      periodo = 0;
    } else {
      saldoInicial = ultimo.saldoFinal;
      if (saldoInicial <= 0) throw Exception('Crédito saldado.');
      periodo = ultimo.periodo + 1;
    }

    // Calcular interés (solo si periodo >= 7)
    double interes = 0;
    if (periodo >= 7) {
      interes = saldoInicial * (tasaPct / 100.0);
    }

    // Asegurar que abono no sea negativo ni mayor que el saldo
    final double amortizacion = abonoCapital.clamp(0, saldoInicial);

    // Calcular cuota = interés + abono a capital
    final cuota = interes + amortizacion;

    // Calcular saldo final
    final saldoFinal = saldoInicial - amortizacion;

    // Crear registro
    final reg = Registrogasto(
      id: null,
      fecha: DateTime.now(),
      periodo: periodo,
      tasa: tasaPct / 100.0,
      cuota: cuota,
      saldoInicial: saldoInicial,
      interes: interes,
      amortizacion: amortizacion,
      saldoFinal: saldoFinal < 0 ? 0 : saldoFinal,
    );

    // Guardar en la base de datos
    await repo.guardarGasto(reg);

    return reg;
  }
}

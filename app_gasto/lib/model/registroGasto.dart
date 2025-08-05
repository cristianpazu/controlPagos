class Registrogasto {
  final int? id;
  final DateTime? fecha; // DateTime.now().toIso8601String()
  final int periodo;
  final double tasa; // 0.015
  final double cuota; // 3000000
  final double saldoInicial;
  final double interes;
  final double amortizacion;
  final double saldoFinal;

  Registrogasto({
    this.id,
    required this.fecha,
    required this.periodo,
    required this.tasa,
    required this.cuota,
    required this.saldoInicial,
    required this.interes,
    required this.amortizacion,
    required this.saldoFinal,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'fecha': fecha?.toIso8601String(),
        'periodo': periodo,
        'tasa': tasa,
        'cuota': cuota,
        'saldo_inicial': saldoInicial,
        'interes': interes,
        'amortizacion': amortizacion,
        'saldo_final': saldoFinal,
      };

  factory Registrogasto.fromMap(Map<String, dynamic> m) => Registrogasto(
        id: m['id'] as int?,
        fecha: m['fecha'] != null
            ? DateTime.parse(
                m['fecha'] as String) // ✅ Parsear String a DateTime
            : null,
        periodo: m['periodo'] as int,
        tasa: (m['tasa'] as num).toDouble(),
        cuota: (m['cuota'] as num).toDouble(),
        saldoInicial: (m['saldo_inicial'] as num).toDouble(),
        interes: (m['interes'] as num).toDouble(),
        amortizacion: (m['amortizacion']).toDouble(),
        saldoFinal: (m['saldo_final'] as num).toDouble(),
      );
}

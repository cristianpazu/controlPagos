import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter/services.dart';

class CustomCurrencyFormatter extends TextInputFormatter {
  final String leadingSymbol;
  final ThousandSeparator thousandSeparator;

  CustomCurrencyFormatter({
    this.leadingSymbol = '\$',
    this.thousandSeparator = ThousandSeparator.Period,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // ✅ Si el texto está vacío, devolver vacío
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Quitar todo lo que no sean dígitos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Convertir a número
    final number = int.tryParse(digitsOnly) ?? 0;

    // Formatear con separador de miles
    final formatted = toCurrencyString(
      number.toString(),
      leadingSymbol: leadingSymbol,
      thousandSeparator: thousandSeparator,
      mantissaLength: 0,
    );

    // Mantener el cursor al final
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

import 'package:app_gasto/conexion/DB_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
// Asegúrate de importar tu clase DB correctamente

final databaseProvider = FutureProvider<Database>((ref) async {
  return await DB.instance();
});

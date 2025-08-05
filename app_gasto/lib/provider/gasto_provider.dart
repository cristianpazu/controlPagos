import 'package:app_gasto/conexion/databaseprovider.dart';
import 'package:app_gasto/doimain/datasource/gastosDatasource.dart';
import 'package:app_gasto/infractructure/datasource_IMPL/gastos_datasource_impl.dart';
import 'package:app_gasto/infractructure/repository_controller/gastos_repositories_IMPL.dart';
import 'package:app_gasto/service/credito_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final gastosServiceProvider =FutureProvider<CreditoService>((ref) async {
  final db = await ref.watch(databaseProvider.future); // ← Esperamos la base de datos
  final datasource = GastosDatasourceImpl(db);
  final repository = GastosRepositoriesIMPL(datasource);

  final service = CreditoService(repository); // ← Si tu servicio necesita el repositorio

  return service;
});

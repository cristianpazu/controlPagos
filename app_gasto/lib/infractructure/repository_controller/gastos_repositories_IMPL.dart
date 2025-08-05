import 'package:app_gasto/doimain/datasource/gastosDatasource.dart';
import 'package:app_gasto/doimain/repositories/gastosRepositories.dart';
import 'package:app_gasto/model/registroGasto.dart';

 class GastosRepositoriesIMPL extends Gastosrepositories {

  final GastosDatasource gastosDatasource;

GastosRepositoriesIMPL(this.gastosDatasource);


  @override
  Future<List<Registrogasto>> consultarTodosGasto() {
return gastosDatasource.consultarTodosGasto();
  }

  @override
  Future<int> guardarGasto(Registrogasto registroGasto) {
    return gastosDatasource.guardarGasto(registroGasto);
  }
}
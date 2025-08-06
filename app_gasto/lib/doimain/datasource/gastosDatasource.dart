import 'package:app_gasto/model/registroGasto.dart';

abstract class GastosDatasource {

Future<int> guardarGasto(Registrogasto registroGasto);


Future<List<Registrogasto>> consultarTodosGasto();

Future<void> borrarTodos();

}
import 'package:app_gasto/model/registroGasto.dart';

abstract class Gastosrepositories {
  Future<int> guardarGasto(Registrogasto registroGasto);


Future<List<Registrogasto>> consultarTodosGasto();

}
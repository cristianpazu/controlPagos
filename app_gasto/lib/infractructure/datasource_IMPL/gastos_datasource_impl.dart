import 'package:app_gasto/doimain/datasource/gastosDatasource.dart';
import 'package:app_gasto/model/registroGasto.dart';
import 'package:sqflite/sqflite.dart';

class GastosDatasourceImpl  extends GastosDatasource{
final Database db;

  GastosDatasourceImpl(this.db);
  @override
  Future<int> guardarGasto(Registrogasto registroGasto) {
    
final guadaCreditop =  db.insert('registros', registroGasto.toMap());
print('guadaCreditopguadaCreditop ${registroGasto.fecha}');
return guadaCreditop;
  }
  
  @override
  Future<List<Registrogasto>> consultarTodosGasto() async{
   final rows = await db.query('registros', orderBy: 'periodo ASC');

print('rowsZZZZZZZZZZZZZZZZ $rows');

    return rows.map(Registrogasto.fromMap).toList();
  }

 }
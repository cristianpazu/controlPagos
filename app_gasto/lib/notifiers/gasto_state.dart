import 'package:app_gasto/model/registroGasto.dart';

class GastoState {
  final bool isLoding;
  final List<Registrogasto> registroGasto;
  final bool isSaving;

GastoState( {

 this.isLoding = false, 
 this.registroGasto = const [], 
  this.isSaving = false,
});

GastoState copyWith({
  bool? isLoding,
  List<Registrogasto>? registroGasto,
  bool? isSaving,
}) => GastoState(
  isLoding: isLoding ?? this.isLoding,
  registroGasto: registroGasto ?? this.registroGasto,
   isSaving: isSaving ?? this.isSaving,
);



}
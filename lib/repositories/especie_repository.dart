import '../models/especie_model.dart';
import '../settings/database_connection.dart';

class EspecieRepository {
  final tableName = "especies";
  final database = DatabaseConnection.instance;

  // funcion para insertar datos
  Future<int> create(EspecieModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap()); 
  }

  // funcion para editar datos
  Future<int> edit(EspecieModel data) async {
    final db = await database.db; 
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id_especie = ?',
      whereArgs: [data.idEspecie],
    ); 
  }

  // funcion para eliminar
  Future<int> delete(int id) async {
    final db = await database.db; 
    return await db.delete(
      tableName,
      where: 'id_especie = ?',
      whereArgs: [id],
    ); 
  }

  // funcion para listar datos
  Future<List<EspecieModel>> getAll() async {
    final db = await database.db; 
    final response = await db.query(tableName);

    return response.map((e) => EspecieModel.fromMap(e)).toList();
  }
}

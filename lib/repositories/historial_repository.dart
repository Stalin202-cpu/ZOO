import '../models/historial_model.dart';
import '../settings/database_connection.dart';

class HistorialRepository {
  final tableName = "historial_medico";
  final database = DatabaseConnection.instance;

  // insertar
  Future<int> create(HistorialModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // editar
  Future<int> edit(HistorialModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id_historial = ?',
      whereArgs: [data.idHistorial],
    );
  }

  // listar
  Future<List<HistorialModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName, orderBy: 'fecha DESC');

    return response.map((e) => HistorialModel.fromMap(e)).toList();
  }

  // eliminar
  Future<int> delete(int id) async {
    final db = await database.db;
    return await db.delete(
      tableName,
      where: 'id_historial = ?',
      whereArgs: [id],
    );
  }
}

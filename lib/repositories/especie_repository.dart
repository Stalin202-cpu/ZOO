import 'package:sqflite/sqflite.dart';

import '../models/recinto_model.dart';
import '../settings/database_connection.dart';

class RecintoRepository {
  final tableName = "recintos";
  final database = DatabaseConnection.instance;

  // funcion para insertar datos
  Future<int> create(RecintoModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // funcion para editar datos
  Future<int> edit(RecintoModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id_recinto = ?',
      whereArgs: [data.idRecinto],
    );
  }

  // funcion para listar datos
  Future<List<RecintoModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);

    return response.map((e) => RecintoModel.fromMap(e)).toList();
  }

  // validación: contar animales asignados a un recinto (consulta permitida: animales)
  Future<int> countAnimalesAsignados(int idRecinto) async {
    final db = await database.db;

    final res = await db.rawQuery(
      'SELECT COUNT(*) FROM animales WHERE id_recinto = ?',
      [idRecinto],
    );

    return Sqflite.firstIntValue(res) ?? 0;
  }

  // funcion para eliminar (validación: no eliminar recintos con animales asignados)
  Future<int> delete(int id) async {
    final total = await countAnimalesAsignados(id);
    if (total > 0) {
      throw Exception("RECINTO_CON_ANIMALES");
    }

    final db = await database.db;
    return await db.delete(tableName, where: 'id_recinto = ?', whereArgs: [id]);
  }
}

import 'package:sqflite/sqflite.dart';

import '../models/recinto_model.dart';
import '../settings/database_connection.dart';

class RecintoRepository {
  final tableName = "recintos";
  final database = DatabaseConnection.instance;

  Future<int> create(RecintoModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  Future<int> edit(RecintoModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id_recinto = ?',
      whereArgs: [data.idRecinto],
    );
  }

  Future<List<RecintoModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => RecintoModel.fromMap(e)).toList();
  }

  // validación: contar animales asignados a un recinto
  Future<int> countAnimalesAsignados(int idRecinto) async {
    final db = await database.db;

    final res = await db.rawQuery(
      'SELECT COUNT(*) FROM animales WHERE id_recinto = ?',
      [idRecinto],
    );

    return Sqflite.firstIntValue(res) ?? 0;
  }

  // validación: no eliminar si tiene animales
  Future<int> delete(int idRecinto) async {
    final total = await countAnimalesAsignados(idRecinto);
    if (total > 0) {
      throw Exception("RECINTO_CON_ANIMALES");
    }

    final db = await database.db;
    return await db.delete(
      tableName,
      where: 'id_recinto = ?',
      whereArgs: [idRecinto],
    );
  }
}

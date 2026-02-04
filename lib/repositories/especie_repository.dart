import 'package:sqflite/sqflite.dart';

import '../models/especie_model.dart';
import '../settings/database_connection.dart';

class EspecieRepository {
  final tableName = "especies";
  final database = DatabaseConnection.instance;

  // insertar
  Future<int> create(EspecieModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // editar
  Future<int> edit(EspecieModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id_especie = ?',
      whereArgs: [data.idEspecie],
    );
  }

  // listar
  Future<List<EspecieModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);

    return response.map((e) => EspecieModel.fromMap(e)).toList();
  }

  // validación: animales asociados
  Future<int> countAnimales(int idEspecie) async {
    final db = await database.db;

    final res = await db.rawQuery(
      'SELECT COUNT(*) FROM animales WHERE id_especie = ?',
      [idEspecie],
    );

    return Sqflite.firstIntValue(res) ?? 0;
  }

  // eliminar
  Future<int> delete(int id) async {
    final total = await countAnimales(id);
    if (total > 0) {
      throw Exception("ESPECIE_CON_ANIMALES");
    }

    final db = await database.db;
    return await db.delete(tableName, where: 'id_especie = ?', whereArgs: [id]);
  }
}

import 'package:sqflite/sqflite.dart';

import '../models/animal_model.dart';
import '../settings/database_connection.dart';

class AnimalRepository {
  final tableName = "animales";
  final database = DatabaseConnection.instance;

  // =========================
  // INSERTAR
  // =========================
  Future<int> create(AnimalModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // =========================
  // EDITAR
  // =========================
  Future<int> edit(AnimalModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id_animal = ?',
      whereArgs: [data.idAnimal],
    );
  }

  // =========================
  // LISTAR CON RELACIONES
  // =========================
  Future<List<AnimalModel>> getAll() async {
    final db = await database.db;

    final res = await db.rawQuery('''
      SELECT a.*, 
             e.nombre_comun AS especieNombre,
             r.nombre AS recintoNombre
      FROM animales a
      INNER JOIN especies e ON a.id_especie = e.id_especie
      INNER JOIN recintos r ON a.id_recinto = r.id_recinto
      ORDER BY a.nombre
    ''');

    return res.map((e) => AnimalModel.fromMap(e)).toList();
  }

  // =========================
  // CONTAR HISTORIAL MÉDICO
  // =========================
  Future<int> countHistorial(int idAnimal) async {
    final db = await database.db;

    final res = await db.rawQuery(
      'SELECT COUNT(*) FROM historial_medico WHERE id_animal = ?',
      [idAnimal],
    );

    return Sqflite.firstIntValue(res) ?? 0;
  }

  // =========================
  // ELIMINAR CON VALIDACIÓN
  // =========================
  Future<int> delete(int id) async {
    final total = await countHistorial(id);

    if (total > 0) {
      throw Exception("ANIMAL_CON_HISTORIAL");
    }

    final db = await database.db;
    return await db.delete(tableName, where: 'id_animal = ?', whereArgs: [id]);
  }
}

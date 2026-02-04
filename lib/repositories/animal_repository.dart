import '../models/animal_model.dart';
import '../settings/database_connection.dart';

class AnimalRepository {
  final tableName = 'animales';
  final database = DatabaseConnection();

  // funcion para insertar datos
  Future<int> create(AnimalModel data) async {
    final db = await database.db; // 1. Llamar a la conexion
    return await db.insert(tableName, data.toMap()); // 2. ejecuto el sql
  }

  // funcion para editar datos
  Future<int> edit(AnimalModel data) async {
    final db = await database.db; // 1. Llamar a la conexion
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id_animal = ?',
      whereArgs: [data.id],
    ); // 2. ejecuto el sql
  }

  // funcion para eliminar datos
  Future<int> delete(int id) async {
    final db = await database.db; // 1. Llamar a la conexion
    return await db.delete(
      tableName,
      where: 'id_animal = ?',
      whereArgs: [id],
    ); // 2. ejecuto el sql
  }

  // funcion para listar datos
  Future<List<AnimalModel>> getAll() async {
    final db = await database.db; // 1. Llamar a la conexion
    final response = await db.query(tableName); // 2. ejecuto el sql
    return response
        .map((e) => AnimalModel.fromMap(e))
        .toList(); // 3. transformar de json a clase
  }

  // Proxima clase replicar la clase para especies, recintos e historial medico
}

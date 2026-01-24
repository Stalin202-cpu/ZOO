import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  // Singleton para la instancia de conexión
  static final DatabaseConnection instance = DatabaseConnection._internal();
  factory DatabaseConnection() => instance;

  // Constructor interno
  DatabaseConnection._internal();

  // Referencia a la base de datos
  static Database? _database;

  // Getter para obtener la instancia de la base de datos
  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _inicializarDb();
    return _database!;
  }

  // Función para inicializar la base de datos
  Future<Database> _inicializarDb() async {
    final rutaDb = await getDatabasesPath();
    final rutaFinal = join(rutaDb, 'zoologico.db');

    return await openDatabase(
      rutaFinal,
      version: 1,
      onConfigure: (Database db) async {
        // IMPORTANTE: habilitar claves foráneas en SQLite
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database db, int version) async {
        // =========================
        // TABLA: especies
        // =========================
        await db.execute('''
          CREATE TABLE especies (
            id_especie INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre_comun TEXT NOT NULL,
            nombre_cientifico TEXT NOT NULL,
            alimentacion TEXT NOT NULL,
            habitat TEXT NOT NULL,
            nivel_peligro TEXT NOT NULL
          )
        ''');

        // =========================
        // TABLA: recintos
        // =========================
        await db.execute('''
          CREATE TABLE recintos (
            id_recinto INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            tipo TEXT NOT NULL,
            capacidad INTEGER NOT NULL,
            ubicacion TEXT NOT NULL
          )
        ''');

        // =========================
        // TABLA: animales (RELACIONADA)
        // =========================
        await db.execute('''
          CREATE TABLE animales (
            id_animal INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            sexo TEXT NOT NULL,
            fecha_nacimiento TEXT NOT NULL,
            estado_salud TEXT NOT NULL,
            id_especie INTEGER NOT NULL,
            id_recinto INTEGER NOT NULL,
            FOREIGN KEY (id_especie) REFERENCES especies (id_especie)
              ON UPDATE CASCADE
              ON DELETE RESTRICT,
            FOREIGN KEY (id_recinto) REFERENCES recintos (id_recinto)
              ON UPDATE CASCADE
              ON DELETE RESTRICT
          )
        ''');

        // =========================
        // TABLA: historial_medico (RELACIONADA)
        // =========================
        await db.execute('''
          CREATE TABLE historial_medico (
            id_historial INTEGER PRIMARY KEY AUTOINCREMENT,
            id_animal INTEGER NOT NULL,
            fecha TEXT NOT NULL,
            diagnostico TEXT NOT NULL,
            tratamiento TEXT NOT NULL,
            observaciones TEXT,
            FOREIGN KEY (id_animal) REFERENCES animales (id_animal)
              ON UPDATE CASCADE
              ON DELETE CASCADE
          )
        ''');

        // (Opcional) Índices para acelerar búsquedas
        await db.execute('CREATE INDEX idx_animales_especie ON animales(id_especie)');
        await db.execute('CREATE INDEX idx_animales_recinto ON animales(id_recinto)');
        await db.execute('CREATE INDEX idx_historial_animal ON historial_medico(id_animal)');
      },
    );
  }
}

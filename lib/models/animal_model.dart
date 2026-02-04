class AnimalModel {
  int? idAnimal;
  String nombre;
  String sexo;
  String fechaNacimiento;
  String estadoSalud;
  int idEspecie;
  int idRecinto;

  // CAMPOS DE JOIN (IMPORTANTES)
  String? especieNombre;
  String? recintoNombre;

  AnimalModel({
    this.idAnimal,
    required this.nombre,
    required this.sexo,
    required this.fechaNacimiento,
    required this.estadoSalud,
    required this.idEspecie,
    required this.idRecinto,
    this.especieNombre,
    this.recintoNombre,
  });

  // =========================
  // FROM MAP
  // =========================
  factory AnimalModel.fromMap(Map<String, dynamic> map) {
    return AnimalModel(
      idAnimal: map['id_animal'],
      nombre: map['nombre'],
      sexo: map['sexo'],
      fechaNacimiento: map['fecha_nacimiento'],
      estadoSalud: map['estado_salud'],
      idEspecie: map['id_especie'],
      idRecinto: map['id_recinto'],

      //  CLAVE DEL PROBLEMA
      especieNombre: map['especieNombre'] ?? map['nombre_comun'],
      recintoNombre: map['recintoNombre'] ?? map['recinto_nombre'],
    );
  }

  // =========================
  // TO MAP
  // =========================
  Map<String, dynamic> toMap() {
    return {
      'id_animal': idAnimal,
      'nombre': nombre,
      'sexo': sexo,
      'fecha_nacimiento': fechaNacimiento,
      'estado_salud': estadoSalud,
      'id_especie': idEspecie,
      'id_recinto': idRecinto,
    };
  }
}

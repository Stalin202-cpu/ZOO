class AnimalModel {
  int? id;
  String nombre;
  String sexo;
  String fechaNacimiento;
  String estadoSalud;
  int idEspecie;
  int idRecinto;

  // Constructor de la clase
  AnimalModel({
    this.id,
    required this.nombre,
    required this.sexo,
    required this.fechaNacimiento,
    required this.estadoSalud,
    required this.idEspecie,
    required this.idRecinto,
  });

  // Convertir de map a clase (SELECT)
  factory AnimalModel.fromMap(Map<String, dynamic> data) {
    return AnimalModel(
      id: data["id_animal"],
      nombre: data["nombre"],
      sexo: data["sexo"],
      fechaNacimiento: data["fecha_nacimiento"],
      estadoSalud: data["estado_salud"],
      idEspecie: data["id_especie"],
      idRecinto: data["id_recinto"],
    );
  }

  // Convertir de clase a map (INSERT, UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'sexo': sexo,
      'fecha_nacimiento': fechaNacimiento,
      'estado_salud': estadoSalud,
      'id_especie': idEspecie,
      'id_recinto': idRecinto,
    };
  }
}

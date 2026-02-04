class EspecieModel {
  int? idEspecie;
  String nombreComun;
  String nombreCientifico;
  String alimentacion;
  String habitat;
  String nivelPeligro;

  // Constructor
  EspecieModel({
    this.idEspecie,
    required this.nombreComun,
    required this.nombreCientifico,
    required this.alimentacion,
    required this.habitat,
    required this.nivelPeligro,
  });

  // FROM MAP (SELECT)
  factory EspecieModel.fromMap(Map<String, dynamic> data) {
    return EspecieModel(
      idEspecie: data['id_especie'],
      nombreComun: data['nombre_comun'],
      nombreCientifico: data['nombre_cientifico'],
      alimentacion: data['alimentacion'],
      habitat: data['habitat'],
      nivelPeligro: data['nivel_peligro'],
    );
  }

  // TO MAP (INSERT / UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'id_especie': idEspecie,
      'nombre_comun': nombreComun,
      'nombre_cientifico': nombreCientifico,
      'alimentacion': alimentacion,
      'habitat': habitat,
      'nivel_peligro': nivelPeligro,
    };
  }
}

class HistorialModel {
  int? idHistorial;
  int idAnimal;
  String fecha;
  String diagnostico;
  String tratamiento;
  String? observaciones;

  // Constructor
  HistorialModel({
    this.idHistorial,
    required this.idAnimal,
    required this.fecha,
    required this.diagnostico,
    required this.tratamiento,
    this.observaciones,
  });

  // FROM MAP (SELECT)
  factory HistorialModel.fromMap(Map<String, dynamic> data) {
    return HistorialModel(
      idHistorial: data['id_historial'],
      idAnimal: data['id_animal'],
      fecha: data['fecha'],
      diagnostico: data['diagnostico'],
      tratamiento: data['tratamiento'],
      observaciones: data['observaciones'],
    );
  }

  // TO MAP (INSERT / UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'id_historial': idHistorial,
      'id_animal': idAnimal,
      'fecha': fecha,
      'diagnostico': diagnostico,
      'tratamiento': tratamiento,
      'observaciones': observaciones,
    };
  }
}

class RecintoModel {
  int? idRecinto;
  String nombre;
  String tipo;
  int capacidad;
  String ubicacion;

  RecintoModel({
    this.idRecinto,
    required this.nombre,
    required this.tipo,
    required this.capacidad,
    required this.ubicacion,
  });

  factory RecintoModel.fromMap(Map<String, dynamic> data) {
    return RecintoModel(
      idRecinto: data['id_recinto'],
      nombre: data['nombre'],
      tipo: data['tipo'],
      capacidad: data['capacidad'],
      ubicacion: data['ubicacion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_recinto': idRecinto,
      'nombre': nombre,
      'tipo': tipo,
      'capacidad': capacidad,
      'ubicacion': ubicacion,
    };
  }
}

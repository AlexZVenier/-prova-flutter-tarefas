
class Tarefa {
  int? id;
  String titulo;
  String descricao;
  int prioridade;
  String criadoEm;
  String departamento;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.criadoEm,
    required this.departamento,
  });

  // Converte um objeto Tarefa em um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade,
      'criadoEm': criadoEm,
      'departamento': departamento,
    };
  }

  // Converte um Map em um objeto Tarefa
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      prioridade: map['prioridade'],
      criadoEm: map['criadoEm'],
      departamento: map['departamento'],
    );
  }
}

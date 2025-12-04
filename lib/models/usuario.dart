class Usuario {
  int? id;
  String nomeCompleto;
  String cpf;
  DateTime dataNascimento;
  String email;
  String senhaHash;

  Usuario({
    this.id,
    required this.nomeCompleto,
    required this.cpf,
    required this.dataNascimento,
    required this.email,
    required this.senhaHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_completo': nomeCompleto,
      'cpf': cpf,
      'data_nascimento': dataNascimento.toIso8601String(),
      'email': email,
      'senha_hash': senhaHash,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nomeCompleto: map['nome_completo'],
      cpf: map['cpf'],
      dataNascimento: DateTime.parse(map['data_nascimento']),
      email: map['email'],
      senhaHash: map['senha_hash'],
    );
  }
}
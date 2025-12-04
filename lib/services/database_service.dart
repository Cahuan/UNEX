// database_service.dart - VERSÃO EM MEMÓRIA (SEM SQLITE)
import '../models/usuario.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Lista em memória para armazenar usuários
  final List<Usuario> _usuarios = [];

  // Inserir usuário
  Future<int> inserirUsuario(Usuario usuario) async {
    // Verifica se email já existe
    final emailExiste = _usuarios.any((u) => u.email.toLowerCase() == usuario.email.toLowerCase());
    if (emailExiste) {
      throw Exception('Email já cadastrado');
    }
    
    // Verifica se CPF já existe
    final cpfExiste = _usuarios.any((u) => u.cpf == usuario.cpf);
    if (cpfExiste) {
      throw Exception('CPF já cadastrado');
    }
    
    // Atribui ID sequencial
    usuario.id = _usuarios.length + 1;
    _usuarios.add(usuario);
    print('Usuário cadastrado: ${usuario.nomeCompleto} (ID: ${usuario.id})');
    return usuario.id!;
  }

  // Buscar usuário por email
  Future<Usuario?> buscarUsuarioPorEmail(String email) async {
    try {
      final usuario = _usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
      return usuario;
    } catch (e) {
      return null;
    }
  }

  // Verificar login
  Future<bool> verificarLogin(String email, String senhaHash) async {
    try {
      final usuario = _usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.senhaHash == senhaHash,
      );
      return usuario != null;
    } catch (e) {
      return false;
    }
  }

  // Método para debug: listar todos os usuários
  List<Usuario> listarTodosUsuarios() {
    return List.from(_usuarios);
  }

  // Método para debug: limpar todos os usuários
  void limparTodosUsuarios() {
    _usuarios.clear();
  }

  // Contar usuários
  int contarUsuarios() {
    return _usuarios.length;
  }
}
// auth_service.dart - VERSÃO COMPATÍVEL
import 'dart:convert';
import '../models/usuario.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _dbService = DatabaseService();

  // Função para hash da senha (base64 para simplificar)
  String hashSenha(String senha) {
    return base64.encode(utf8.encode(senha));
  }

  // Validação de senha
  Map<String, bool> validarSenha(String senha) {
    return {
      'maiuscula': RegExp(r'[A-Z]').hasMatch(senha),
      'minuscula': RegExp(r'[a-z]').hasMatch(senha),
      'numero': RegExp(r'[0-9]').hasMatch(senha),
      'especial': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(senha),
      'tamanho': senha.length >= 8,
    };
  }

  bool senhaValida(String senha) {
    final validacoes = validarSenha(senha);
    return validacoes.values.every((v) => v);
  }

  // Validação de CPF
  bool validarCPF(String cpf) {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
    return cpfLimpo.length == 11;
  }

  // Formatar CPF
  String formatarCPF(String cpf) {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (cpfLimpo.length != 11) return cpf;
    
    return '${cpfLimpo.substring(0, 3)}.${cpfLimpo.substring(3, 6)}.${cpfLimpo.substring(6, 9)}-${cpfLimpo.substring(9)}';
  }

  // Validação de nome completo
  bool validarNomeCompleto(String nome) {
    final partes = nome.trim().split(' ');
    return partes.length >= 2 && partes.every((parte) => parte.length > 1);
  }

  // Cadastrar usuário
  Future<bool> cadastrarUsuario(Usuario usuario) async {
    try {
      usuario.senhaHash = hashSenha(usuario.senhaHash);
      // Formatar CPF
      usuario.cpf = formatarCPF(usuario.cpf);
      
      await _dbService.inserirUsuario(usuario);
      return true;
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      return false;
    }
  }

  // Login
  Future<bool> login(String email, String senha) async {
    final senhaHash = hashSenha(senha);
    return await _dbService.verificarLogin(email, senhaHash);
  }

  // Buscar usuário por email
  Future<Usuario?> buscarUsuario(String email) async {
    return await _dbService.buscarUsuarioPorEmail(email);
  }

  // Método para debug
  void mostrarUsuariosCadastrados() {
    final usuarios = _dbService.listarTodosUsuarios();
    print('=== USUÁRIOS CADASTRADOS (${usuarios.length}) ===');
    for (var usuario in usuarios) {
      print('ID: ${usuario.id}, Nome: ${usuario.nomeCompleto}, Email: ${usuario.email}');
    }
  }
}
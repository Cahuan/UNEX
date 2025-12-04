import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

class CadastroViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();

  // Estado
  DateTime? _dataNascimento;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _loading = false;
  String? _erro;

  // Getters
  DateTime? get dataNascimento => _dataNascimento;
  bool get senhaVisivel => _senhaVisivel;
  bool get confirmarSenhaVisivel => _confirmarSenhaVisivel;
  bool get loading => _loading;
  String? get erro => _erro;

  // Setters
  set dataNascimento(DateTime? value) {
    _dataNascimento = value;
    notifyListeners();
  }

  void toggleSenhaVisivel() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  void toggleConfirmarSenhaVisivel() {
    _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
    notifyListeners();
  }

  // Validações
  Map<String, bool> get validacoesSenha {
    return _authService.validarSenha(senhaController.text);
  }

  bool get todasValidacoesSenhaPassaram {
    return _authService.senhaValida(senhaController.text);
  }

  bool get senhasConferem {
    return senhaController.text == confirmarSenhaController.text;
  }

  bool get formularioValido {
    return nomeController.text.isNotEmpty &&
        cpfController.text.isNotEmpty &&
        _dataNascimento != null &&
        emailController.text.isNotEmpty &&
        senhaController.text.isNotEmpty &&
        confirmarSenhaController.text.isNotEmpty &&
        validarNomeCompleto(nomeController.text) &&
        validarCPF(cpfController.text) &&
        _authService.senhaValida(senhaController.text) &&
        senhasConferem;
  }

  // Métodos de validação (moved from AuthService)
  bool validarNomeCompleto(String nome) {
    final partes = nome.trim().split(' ');
    return partes.length >= 2 && partes.every((parte) => parte.length > 1);
  }

  bool validarCPF(String cpf) {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
    return cpfLimpo.length == 11;
  }

  // Cadastrar
  Future<bool> cadastrar() async {
    if (!formularioValido) return false;

    _loading = true;
    _erro = null;
    notifyListeners();

    try {
      final usuario = Usuario(
        nomeCompleto: nomeController.text.trim(),
        cpf: cpfController.text.replaceAll(RegExp(r'[^\d]'), ''),
        dataNascimento: _dataNascimento!,
        email: emailController.text.trim(),
        senhaHash: senhaController.text,
      );

      final sucesso = await _authService.cadastrarUsuario(usuario);
      
      if (!sucesso) {
        _erro = 'Erro ao cadastrar usuário. Email ou CPF já cadastrado.';
      }
      
      return sucesso;
    } catch (e) {
      _erro = 'Erro: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Limpar
  void limpar() {
    nomeController.clear();
    cpfController.clear();
    emailController.clear();
    senhaController.clear();
    confirmarSenhaController.clear();
    _dataNascimento = null;
    _erro = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  // Estado
  bool _senhaVisivel = false;
  bool _loading = false;
  String? _erro;

  // Getters
  bool get senhaVisivel => _senhaVisivel;
  bool get loading => _loading;
  String? get erro => _erro;
  bool get formularioValido {
    return emailController.text.isNotEmpty && 
           senhaController.text.isNotEmpty;
  }

  // Setters
  void toggleSenhaVisivel() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  // Login
  Future<bool> login() async {
    if (!formularioValido) return false;

    _loading = true;
    _erro = null;
    notifyListeners();

    try {
      final sucesso = await _authService.login(
        emailController.text.trim(),
        senhaController.text,
      );

      if (!sucesso) {
        _erro = 'Email ou senha incorretos';
      }

      return sucesso;
    } catch (e) {
      _erro = 'Erro ao realizar login: ${e.toString()}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
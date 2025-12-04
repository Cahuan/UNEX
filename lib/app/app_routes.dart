import 'package:flutter/material.dart';
import '../views/tela_cadastro.dart';
import '../views/tela_login.dart';
import '../views/tela_principal.dart';
import '../views/tela_resultados.dart';

class AppRoutes {
  static const String login = '/';
  static const String cadastro = '/cadastro';
  static const String principal = '/principal';
  static const String resultados = '/resultados';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => TelaLogin());
      
      case cadastro:
        return MaterialPageRoute(builder: (_) => TelaCadastro());
      
      case principal:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TelaPrincipal(
            email: args?['email'] ?? '',
          ),
        );
      
      case resultados:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TelaResultados(
            frases: args?['frases'] ?? 0,
            caracteresComEspacos: args?['caracteresComEspacos'] ?? 0,
            caracteresSemEspacos: args?['caracteresSemEspacos'] ?? 0,
            totalPalavras: args?['totalPalavras'] ?? 0,
            tempoLeitura: args?['tempoLeitura'] ?? 0.0,
            topPalavras: args?['topPalavras'] ?? [],
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Métodos auxiliares para navegação
  static Future<dynamic> pushNamed(String routeName, {Object? arguments}) async {
    return await navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushReplacementNamed(
    String routeName, {
    Object? arguments,
  }) async {
    return await navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pop() {
    navigatorKey.currentState!.pop();
  }

  static Future<dynamic> navigateToLogin() async {
    return await pushReplacementNamed(login);
  }

  static Future<dynamic> navigateToCadastro() async {
    return await pushReplacementNamed(cadastro);
  }

  static Future<dynamic> navigateToPrincipal(String email) async {
    return await pushReplacementNamed(
      principal,
      arguments: {'email': email},
    );
  }

  static Future<dynamic> navigateToResultados({
    required int frases,
    required int caracteresComEspacos,
    required int caracteresSemEspacos,
    required int totalPalavras,
    required double tempoLeitura,
    required List<MapEntry<String, int>> topPalavras,
  }) async {
    return await pushNamed(
      resultados,
      arguments: {
        'frases': frases,
        'caracteresComEspacos': caracteresComEspacos,
        'caracteresSemEspacos': caracteresSemEspacos,
        'totalPalavras': totalPalavras,
        'tempoLeitura': tempoLeitura,
        'topPalavras': topPalavras,
      },
    );
  }
}
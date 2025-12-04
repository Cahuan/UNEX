import 'package:flutter/material.dart';

class AnaliseViewModel with ChangeNotifier {
  // Controlador do campo de texto
  final TextEditingController _controller = TextEditingController();
  
  // Lista de stopwords
  final Set<String> stopwords = {
    'a', 'o', 'os', 'as', 'que', 'de', 'para', 'com', 'sem',
    'mas', 'e', 'ou', 'entre', 'em', 'por', 'da', 'do', 'dos', 'das',
  };

  // Estado da análise
  int? _frases;
  int? _caracteresComEspacos;
  int? _caracteresSemEspacos;
  int? _totalPalavras;
  double? _tempoLeitura;
  List<MapEntry<String, int>>? _topPalavras;
  String? _usuarioLogado;

  // Getters
  TextEditingController get controller => _controller;
  int? get frases => _frases;
  int? get caracteresComEspacos => _caracteresComEspacos;
  int? get caracteresSemEspacos => _caracteresSemEspacos;
  int? get totalPalavras => _totalPalavras;
  double? get tempoLeitura => _tempoLeitura;
  List<MapEntry<String, int>>? get topPalavras => _topPalavras;
  String? get usuarioLogado => _usuarioLogado;

  // Setters
  set usuarioLogado(String? value) {
    _usuarioLogado = value;
    notifyListeners();
  }

  // Funções de análise
  void analisarTexto() {
    String texto = _controller.text.trim();
    
    if (texto.isEmpty) {
      throw Exception('Digite um texto para analisar.');
    }

    _frases = contarFrases(texto);
    _caracteresComEspacos = contarCaracteresComEspacos(texto);
    _caracteresSemEspacos = contarCaracteresSemEspacos(texto);
    _totalPalavras = contarPalavrasTotais(texto);
    _tempoLeitura = estimarTempoLeitura(texto);
    _topPalavras = top10Palavras(texto);

    notifyListeners();
  }

  void limparAnalise() {
    _controller.clear();
    _frases = null;
    _caracteresComEspacos = null;
    _caracteresSemEspacos = null;
    _totalPalavras = null;
    _tempoLeitura = null;
    _topPalavras = null;
    notifyListeners();
  }

  // Funções auxiliares
  int contarFrases(String texto) {
    final frases = RegExp(r'[.!?]+').allMatches(texto).length;
    return frases > 0 ? frases : 1;
  }

  int contarCaracteresComEspacos(String texto) => texto.length;

  int contarCaracteresSemEspacos(String texto) => texto.replaceAll(' ', '').length;

  int contarPalavrasTotais(String texto) {
    final palavras = RegExp(r'\b\w+\b').allMatches(texto);
    return palavras.length;
  }

  double estimarTempoLeitura(String texto) {
    final totalPalavras = contarPalavrasTotais(texto);
    return (totalPalavras / 250).clamp(0.1, double.infinity);
  }

  List<MapEntry<String, int>> top10Palavras(String texto) {
    final palavras = RegExp(r'\b\w+\b')
        .allMatches(texto.toLowerCase())
        .map((m) => m.group(0)!)
        .where((p) => !stopwords.contains(p))
        .toList();

    final frequencias = <String, int>{};
    for (var palavra in palavras) {
      frequencias[palavra] = (frequencias[palavra] ?? 0) + 1;
    }

    List<MapEntry<String, int>> entries = frequencias.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(10).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
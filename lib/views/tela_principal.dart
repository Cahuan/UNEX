// tela_principal.dart - Corrigindo o erro de print
import 'package:flutter/material.dart';
import '../viewmodels/analise_viewmodel.dart';
import '../services/auth_service.dart';
import '../app/app_routes.dart';

class TelaPrincipal extends StatefulWidget {
  final String email;

  const TelaPrincipal({super.key, required this.email});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late final AuthService _authService;
  String? _nomeUsuario;
  bool _carregandoUsuario = true;
  final AnaliseViewModel _analiseViewModel = AnaliseViewModel();

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    try {
      final usuario = await _authService.buscarUsuario(widget.email);
      if (mounted) {
        setState(() {
          _nomeUsuario = usuario?.nomeCompleto;
          _carregandoUsuario = false;
        });
      }
    } catch (e) {
      // Em vez de print, você pode usar debugPrint ou apenas ignorar
      debugPrint('Erro ao carregar usuário: $e');
      if (mounted) {
        setState(() {
          _carregandoUsuario = false;
        });
      }
    }
  }

  Future<void> _sair() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await AppRoutes.navigateToLogin();
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisador de Texto'),
        centerTitle: true,
        actions: [
          if (_nomeUsuario != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    _nomeUsuario!.split(' ').first,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sair,
                    icon: const Icon(Icons.exit_to_app, size: 20),
                    tooltip: 'Sair',
                  ),
                ],
              ),
            ),
          if (_carregandoUsuario)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo de texto
              TextField(
                controller: _analiseViewModel.controller,
                maxLines: 10,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Digite ou cole seu texto aqui...',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        try {
                          _analiseViewModel.analisarTexto();
                          
                          // Navegar para tela de resultados
                          AppRoutes.navigateToResultados(
                            frases: _analiseViewModel.frases!,
                            caracteresComEspacos: _analiseViewModel.caracteresComEspacos!,
                            caracteresSemEspacos: _analiseViewModel.caracteresSemEspacos!,
                            totalPalavras: _analiseViewModel.totalPalavras!,
                            tempoLeitura: _analiseViewModel.tempoLeitura!,
                            topPalavras: _analiseViewModel.topPalavras!,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.analytics),
                      label: const Text(
                        "Analisar",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar'),
                          content: const Text('Tem certeza que deseja limpar o texto?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                _analiseViewModel.limparAnalise();
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Texto limpo.'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Text(
                                'Limpar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
                    tooltip: 'Limpar texto',
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Pré-visualização dos resultados
              if (_analiseViewModel.totalPalavras != null) ...[
                const SizedBox(height: 24),
                const Divider(thickness: 1.2),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pré-visualização:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildEstatistica('Palavras', '${_analiseViewModel.totalPalavras}'),
                          _buildEstatistica('Caracteres', '${_analiseViewModel.caracteresComEspacos}'),
                          _buildEstatistica('Frases', '${_analiseViewModel.frases}'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildEstatistica('Sem espaços', '${_analiseViewModel.caracteresSemEspacos}'),
                          _buildEstatistica('Tempo leitura', '${_analiseViewModel.tempoLeitura!.toStringAsFixed(1)} min'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Clique em "Analisar" para ver detalhes completos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              
              const SizedBox(height: 40),

              // Rodapé
              Column(
                children: [
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),
                  const Text(
                    'Produzido por Cahuan Gomes',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstatistica(String titulo, String valor) {
    return Column(
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _analiseViewModel.dispose();
    super.dispose();
  }
}
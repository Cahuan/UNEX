import 'package:flutter/material.dart';

class TelaResultados extends StatelessWidget {
  final int frases;
  final int caracteresComEspacos;
  final int caracteresSemEspacos;
  final int totalPalavras;
  final double tempoLeitura;
  final List<MapEntry<String, int>> topPalavras;

  const TelaResultados({
    super.key,
    required this.frases,
    required this.caracteresComEspacos,
    required this.caracteresSemEspacos,
    required this.totalPalavras,
    required this.tempoLeitura,
    required this.topPalavras,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Análise'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.indigo),
                        const SizedBox(width: 8),
                        Text(
                          'Análise Concluída',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seu texto foi analisado com sucesso. Veja os resultados abaixo:',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Estatísticas principais
            Text(
              'Estatísticas Gerais',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildCardEstatistica(
                  'Palavras',
                  totalPalavras.toString(),
                  Icons.text_fields,
                  Colors.blue,
                ),
                _buildCardEstatistica(
                  'Caracteres (com espaços)',
                  caracteresComEspacos.toString(),
                  Icons.format_size,
                  Colors.green,
                ),
                _buildCardEstatistica(
                  'Caracteres (sem espaços)',
                  caracteresSemEspacos.toString(),
                  Icons.space_bar,
                  Colors.orange,
                ),
                _buildCardEstatistica(
                  'Frases',
                  frases.toString(),
                  Icons.message,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tempo de leitura
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tempo estimado de leitura',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tempoLeitura.toStringAsFixed(2)} minutos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Baseado em 250 palavras por minuto',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Palavras mais frequentes
            Text(
              'Top 10 Palavras (sem stopwords)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Stopwords ignoradas: artigos, preposições, conjunções comuns',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            if (topPalavras.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Não foram encontradas palavras significativas para análise.',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              ...topPalavras.asMap().entries.map((entry) {
                final index = entry.key;
                final palavra = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getCorPorPosicao(index),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      palavra.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Frequência: ${palavra.value} ${palavra.value == 1 ? 'vez' : 'vezes'}',
                    ),
                    trailing: Chip(
                      label: Text(
                        '#${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getCorPorPosicao(index),
                    ),
                  ),
                );
              }),

            const SizedBox(height: 32),

            // Botão para voltar
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar para Análise'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardEstatistica(
      String titulo, String valor, IconData icone, Color cor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: cor, size: 32),
            const SizedBox(height: 12),
            Text(
              valor,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCorPorPosicao(int index) {
    final cores = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
    ];
    return index < cores.length ? cores[index] : Colors.grey;
  }
}